defmodule Bds.Contrast do
  @moduledoc """
  WCAG 2.x color contrast helpers.

  Implements the relative luminance and contrast ratio definitions from WCAG 2.0
  (sRGB, IEC 61966-2-1) and the thresholds of:

    * SC 1.4.3 Contrast (Minimum, AA): 4.5:1 for text, 3:1 for large text.
    * SC 1.4.6 Contrast (Enhanced, AAA): 7:1 for text, 4.5:1 for large text.
    * SC 1.4.11 Non-text Contrast (AA, WCAG 2.1): 3:1 for UI component boundaries,
      focus indicators, icons and graphics required to understand content.

  Large text is at least 18pt (24px) regular or 14pt (≈18.66px) bold (700+).
  Ratios are never rounded up when compared: 4.49:1 fails 4.5:1.
  """

  @type rgb :: {0..255, 0..255, 0..255}
  @type usage :: :text | :large_text | :non_text
  @type level :: :aa | :aaa

  @thresholds %{
    {:text, :aa} => 4.5,
    {:text, :aaa} => 7.0,
    {:large_text, :aa} => 3.0,
    {:large_text, :aaa} => 4.5,
    {:non_text, :aa} => 3.0
  }

  @doc """
  Parses `#rgb`, `#rrggbb` (with or without `#`) into an `{r, g, b}` tuple.

      iex> Bds.Contrast.parse_hex("#212492")
      {:ok, {33, 36, 146}}

      iex> Bds.Contrast.parse_hex("fff")
      {:ok, {255, 255, 255}}

      iex> Bds.Contrast.parse_hex("nope")
      {:error, :invalid_hex}
  """
  @spec parse_hex(String.t()) :: {:ok, rgb()} | {:error, :invalid_hex}
  def parse_hex("#" <> hex), do: parse_hex(hex)

  def parse_hex(<<r, g, b>>), do: parse_hex(<<r, r, g, g, b, b>>)

  def parse_hex(<<hex::binary-size(6)>>) do
    case Integer.parse(hex, 16) do
      {value, ""} -> {:ok, {Bitwise.bsr(value, 16), Bitwise.band(Bitwise.bsr(value, 8), 0xFF), Bitwise.band(value, 0xFF)}}
      _ -> {:error, :invalid_hex}
    end
  end

  def parse_hex(_), do: {:error, :invalid_hex}

  @doc "Normalizes a hex color to lowercase `#rrggbb`, or returns `{:error, :invalid_hex}`."
  @spec normalize_hex(String.t()) :: {:ok, String.t()} | {:error, :invalid_hex}
  def normalize_hex(hex) when is_binary(hex) do
    with {:ok, rgb} <- hex |> String.trim() |> parse_hex(), do: {:ok, to_hex(rgb)}
  end

  @doc "Formats an `{r, g, b}` tuple as lowercase `#rrggbb`."
  @spec to_hex(rgb()) :: String.t()
  def to_hex({r, g, b}) do
    "#" <> Enum.map_join([r, g, b], &(&1 |> Integer.to_string(16) |> String.pad_leading(2, "0"))) |> String.downcase()
  end

  @doc """
  Relative luminance (0.0 black – 1.0 white) as defined by WCAG 2.0.

      iex> Bds.Contrast.relative_luminance({255, 255, 255})
      1.0
  """
  @spec relative_luminance(rgb() | String.t()) :: float()
  def relative_luminance(hex) when is_binary(hex), do: hex |> parse_hex!() |> relative_luminance()

  def relative_luminance({r, g, b}) do
    0.2126 * linear_channel(r) + 0.7152 * linear_channel(g) + 0.0722 * linear_channel(b)
  end

  defp linear_channel(value) do
    c = value / 255
    if c <= 0.03928, do: c / 12.92, else: :math.pow((c + 0.055) / 1.055, 2.4)
  end

  @doc """
  Contrast ratio `(L1 + 0.05) / (L2 + 0.05)` between two colors, from 1.0 to 21.0.
  Order of the arguments does not matter.

      iex> Bds.Contrast.ratio("#000000", "#ffffff")
      21.0
  """
  @spec ratio(rgb() | String.t(), rgb() | String.t()) :: float()
  def ratio(a, b) do
    {darker, lighter} = Enum.min_max([relative_luminance(a), relative_luminance(b)])
    (lighter + 0.05) / (darker + 0.05)
  end

  @doc "Minimum ratio for `usage` at `level`. Non-text contrast only defines AA."
  @spec threshold(usage(), level()) :: float() | nil
  def threshold(usage, level \\ :aa), do: Map.get(@thresholds, {usage, level})

  @doc "Whether `ratio` meets `usage` at `level` (no rounding up)."
  @spec passes?(float(), usage(), level()) :: boolean()
  def passes?(ratio, usage, level \\ :aa) do
    case threshold(usage, level) do
      nil -> false
      min -> ratio >= min
    end
  end

  @doc """
  Full evaluation of a foreground/background pair.

  Returns the ratio plus pass/fail for every WCAG check, for example:

      %{ratio: 8.59, text_aa: true, text_aaa: true, large_aa: true,
        large_aaa: true, non_text_aa: true}
  """
  @spec evaluate(rgb() | String.t(), rgb() | String.t()) :: map()
  def evaluate(foreground, background) do
    r = ratio(foreground, background)

    %{
      ratio: r,
      text_aa: passes?(r, :text, :aa),
      text_aaa: passes?(r, :text, :aaa),
      large_aa: passes?(r, :large_text, :aa),
      large_aaa: passes?(r, :large_text, :aaa),
      non_text_aa: passes?(r, :non_text, :aa)
    }
  end

  @doc """
  WCAG "large scale" text: at least 24px, or at least 18.66px (14pt) when bold (700+).

      iex> Bds.Contrast.large_text?(24, 400)
      true

      iex> Bds.Contrast.large_text?(19, 700)
      true

      iex> Bds.Contrast.large_text?(18, 400)
      false
  """
  @spec large_text?(number(), number()) :: boolean()
  def large_text?(px, weight \\ 400)
  def large_text?(px, weight) when weight >= 700, do: px >= 18.66
  def large_text?(px, _weight), do: px >= 24

  @doc """
  Formats a ratio for display, truncated (not rounded) to two decimals so a
  failing ratio never displays as passing: `4.4999` → `"4.49:1"`.
  """
  @spec format_ratio(float()) :: String.t()
  def format_ratio(ratio) do
    truncated = Float.floor(ratio * 100) / 100
    :erlang.float_to_binary(truncated, decimals: 2) <> ":1"
  end

  @doc "Picks whichever of black or white text has the higher ratio on `background`."
  @spec best_text_color(rgb() | String.t()) :: String.t()
  def best_text_color(background) do
    if ratio("#000000", background) >= ratio("#ffffff", background), do: "#000000", else: "#ffffff"
  end

  defp parse_hex!(hex) do
    case parse_hex(hex) do
      {:ok, rgb} -> rgb
      {:error, _} -> raise ArgumentError, "invalid hex color #{inspect(hex)}"
    end
  end
end
