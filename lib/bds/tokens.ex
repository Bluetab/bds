defmodule Bds.Tokens do
  @moduledoc """
  Color tokens read at compile time from the shipped `priv/static/bds.css`,
  so documentation (e.g. the contrast audit) always matches the real CSS.

  Only solid hex values are exposed; tokens defined with `color-mix()`, `rgba()`
  or other variables are skipped. Dark values inherit light ones unless
  the `[data-theme="dark"]` block overrides them.
  """

  alias Bds.Contrast

  @css_path Path.join([:code.priv_dir(:bds), "static", "bds.css"])
  @external_resource @css_path

  parse_block = fn css, selector_regex ->
    case Regex.run(~r/#{selector_regex}\s*\{([^}]*--bt-color-[^}]*)\}/s, css) do
      [_, body] ->
        ~r/(--bt-[a-z0-9-]+)\s*:\s*(#[0-9a-fA-F]{3,6})\s*(?:;|$)/
        |> Regex.scan(body)
        |> Map.new(fn [_, name, hex] ->
          {:ok, normalized} = Contrast.normalize_hex(hex)
          {name, normalized}
        end)

      nil ->
        %{}
    end
  end

  css = if File.exists?(@css_path), do: File.read!(@css_path), else: ""
  # `:root` / `html[data-theme="dark"]`, or the theme-zone selectors
  # `:root, [data-theme="light"]` / `[data-theme="dark"]` (tokens.css)
  light = parse_block.(css, ~S|:root(?:\s*,\s*\[data-theme=["']?light["']?\])?|)
  dark_overrides = parse_block.(css, ~S|(?:html)?\[data-theme=["']?dark["']?\]|)

  @light light
  @dark Map.merge(light, dark_overrides)

  @type theme :: :light | :dark

  @doc "Map of `--bt-*` token name → `#rrggbb` for `theme`."
  @spec colors(theme()) :: %{String.t() => String.t()}
  def colors(:light), do: @light
  def colors(:dark), do: @dark

  @doc "Hex value of `token` (with or without leading `--`) in `theme`, or `nil`."
  @spec color(String.t(), theme()) :: String.t() | nil
  def color("--" <> _ = token, theme), do: Map.get(colors(theme), token)
  def color(token, theme), do: color("--" <> token, theme)

  @doc """
  Token pairs that BDS components actually render together, grouped by how
  WCAG evaluates them (`:text`, `:large_text`, `:non_text`).
  Used by the storybook contrast audit; values come from `colors/1`.
  """
  @spec pairs() :: [map()]
  def pairs do
    [
      # Body text on surfaces
      pair("Body text", "bt-color-text", "bt-color-surface", :text, "Paragraphs, labels, table cells"),
      pair("Body text on background", "bt-color-text", "bt-color-background", :text, "Page canvas"),
      pair("Muted text", "bt-color-text-muted", "bt-color-surface", :text, "Descriptions, secondary copy"),
      pair("Muted text on soft surface", "bt-color-text-muted", "bt-color-surface-soft", :text, "Sidebar, cards"),
      pair("Subtle text", "bt-color-text-subtle", "bt-color-surface", :text, "Help text, captions, group titles"),
      pair("Subtle text on background", "bt-color-text-subtle", "bt-color-background", :text, "Metadata on canvas"),
      # Brand
      pair("Primary link", "bt-color-primary", "bt-color-surface", :text, "Links, ghost/outline buttons"),
      pair("Primary button", "bt-color-on-primary", "bt-color-primary", :text, "bt-button--primary, active nav link"),
      pair("Primary on soft", "bt-color-primary", "bt-color-primary-soft", :text, "Selected chips, tinted cards"),
      pair("Secondary button", "bt-color-on-secondary", "bt-color-secondary", :text, "bt-button--secondary, FAB"),
      pair("Secondary as text", "bt-color-secondary", "bt-color-background", :text, "Eyebrows (bt-eyebrow)"),
      pair("Tertiary button", "bt-color-on-tertiary", "bt-color-tertiary", :text, "bt-button--tertiary"),
      # Semantic
      pair("Success on soft", "bt-color-success", "bt-color-success-soft", :text, "Success badges, callouts"),
      pair("Warning on soft", "bt-color-warning", "bt-color-warning-soft", :text, "Warning badges, callouts"),
      pair("Error on soft", "bt-color-error", "bt-color-error-soft", :text, "Error badges, callouts"),
      pair("Info on soft", "bt-color-info", "bt-color-info-soft", :text, "Info badges, callouts"),
      pair("Error text", "bt-color-error", "bt-color-surface", :text, "Field validation messages"),
      pair("White on success", "#ffffff", "bt-color-success", :text, "Solid success badge"),
      pair("White on warning", "#ffffff", "bt-color-warning", :text, "Solid warning badge"),
      pair("White on error", "#ffffff", "bt-color-error", :text, "Danger button"),
      # Large text
      pair("Primary heading", "bt-color-primary", "bt-color-surface", :large_text, "Headings ≥ 24px or ≥ 18.66px bold"),
      pair("Secondary heading", "bt-color-secondary", "bt-color-surface", :large_text, "Display text"),
      # Non-text (SC 1.4.11)
      pair("Input border", "bt-color-border-strong", "bt-color-surface", :non_text, "Text fields, selects, checkboxes"),
      pair("Divider / card border", "bt-color-border", "bt-color-surface", :non_text, "Decorative — exempt if not needed to identify a control"),
      pair("Focus ring (secondary)", "bt-color-secondary", "bt-color-surface", :non_text, ":focus-visible outline (solid)"),
      pair("Focus ring (primary)", "bt-color-primary", "bt-color-surface", :non_text, "Input focus border"),
      pair("Primary button vs. page", "bt-color-primary", "bt-color-background", :non_text, "Button boundary against the canvas"),
      pair("Icon (muted)", "bt-color-text-muted", "bt-color-surface", :non_text, "Meaningful icons")
    ]
  end

  @doc "Resolves `pairs/0` for `theme`, adding hex values and `Bds.Contrast.evaluate/2` results."
  @spec audit(theme()) :: [map()]
  def audit(theme) do
    for %{foreground: fg, background: bg} = pair <- pairs(),
        fg_hex = resolve(fg, theme),
        bg_hex = resolve(bg, theme),
        fg_hex && bg_hex do
      result = Contrast.evaluate(fg_hex, bg_hex)

      passes = passes_for_usage?(result, pair.usage)

      pair
      |> Map.merge(%{foreground_hex: fg_hex, background_hex: bg_hex, result: result})
      |> Map.put(:passes, passes)
      |> Map.put(:suggestion, if(passes, do: nil, else: suggest_for(pair, fg_hex, bg_hex, theme)))
    end
  end

  # Text on a fill whose text color is fixed (white, --bt-color-on-*) is fixed by
  # changing the fill; otherwise the foreground changes.
  defp suggest_for(%{foreground: fg} = pair, fg_hex, bg_hex, theme) do
    if String.starts_with?(fg, "#") or String.starts_with?(fg, "bt-color-on-") do
      with %{} = s <- suggest(bg_hex, fg_hex, pair.usage, theme), do: Map.put(s, :replaces, :background)
    else
      with %{} = s <- suggest(fg_hex, bg_hex, pair.usage, theme), do: Map.put(s, :replaces, :foreground)
    end
  end

  @doc """
  Palette token (`--bt-palette-*`) perceptually closest to `color` (OKLab
  distance, so hue and lightness are preserved) that meets `usage` against
  `other`. Use it to fix a failing pair with the least visual change.
  Returns `nil` when no palette step passes.

      %{token: "--bt-palette-amber-80", hex: "#a26205", ratio: 4.59}
  """
  @spec suggest(String.t(), String.t(), Contrast.usage(), theme()) :: map() | nil
  def suggest(color, other, usage, theme \\ :light) do
    target = oklab(color)
    min = Contrast.threshold(usage)

    palette =
      theme
      |> colors()
      |> Enum.filter(fn {name, _hex} -> String.starts_with?(name, "--bt-palette-") end)
      |> Enum.map(fn {name, hex} -> {name, hex, distance(oklab(hex), target)} end)

    # Stay in the family the color belongs to (a grey stays in the neutral
    # scale); only look elsewhere when no step of that family passes.
    family = palette |> Enum.min_by(&elem(&1, 2)) |> elem(0) |> palette_family()

    {same, others} = Enum.split_with(palette, fn {name, _, _} -> palette_family(name) == family end)

    (closest_passing(same, other, min) || closest_passing(others, other, min))
    |> case do
      nil -> nil
      {name, hex, ratio} -> %{token: name, hex: hex, ratio: ratio, family: palette_family(name)}
    end
  end

  defp closest_passing(candidates, other, min) do
    candidates
    |> Enum.map(fn {name, hex, dist} -> {name, hex, dist, Contrast.ratio(hex, other)} end)
    |> Enum.filter(fn {_, _, _, ratio} -> ratio >= min end)
    |> Enum.min_by(fn {_, _, dist, _} -> dist end, fn -> nil end)
    |> case do
      nil -> nil
      {name, hex, _dist, ratio} -> {name, hex, ratio}
    end
  end

  # "--bt-palette-neutral-black-40" → "neutral-black"
  defp palette_family("--bt-palette-" <> rest), do: rest |> String.replace(~r/-\d+$/, "")

  # Hue/chroma changes weigh more than lightness changes: fixing contrast means
  # going lighter or darker, not switching color (a grey must stay grey).
  @chroma_weight 4
  defp distance({l1, a1, b1}, {l2, a2, b2}),
    do: (l1 - l2) ** 2 + @chroma_weight * ((a1 - a2) ** 2 + (b1 - b2) ** 2)

  # sRGB → OKLab (Björn Ottosson, 2020)
  defp oklab(hex) do
    {:ok, {r, g, b}} = Contrast.parse_hex(hex)
    [r, g, b] = Enum.map([r, g, b], &linear/1)

    l = :math.pow(0.4122214708 * r + 0.5363325363 * g + 0.0514459929 * b, 1 / 3)
    m = :math.pow(0.2119034982 * r + 0.6806995451 * g + 0.1073969566 * b, 1 / 3)
    s = :math.pow(0.0883024619 * r + 0.2817188376 * g + 0.6299787005 * b, 1 / 3)

    {0.2104542553 * l + 0.7936177850 * m - 0.0040720468 * s,
     1.9779984951 * l - 2.4285922050 * m + 0.4505937099 * s,
     0.0259040371 * l + 0.7827717662 * m - 0.8086757660 * s}
  end

  defp linear(value) do
    c = value / 255
    if c <= 0.04045, do: c / 12.92, else: :math.pow((c + 0.055) / 1.055, 2.4)
  end

  defp passes_for_usage?(result, :text), do: result.text_aa
  defp passes_for_usage?(result, :large_text), do: result.large_aa
  defp passes_for_usage?(result, :non_text), do: result.non_text_aa

  defp resolve("#" <> _ = hex, _theme), do: hex
  defp resolve(token, theme), do: color(token, theme)

  defp pair(name, foreground, background, usage, used_in) do
    %{name: name, foreground: foreground, background: background, usage: usage, used_in: used_in}
  end
end
