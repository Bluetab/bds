defmodule Bds.ColorScaleTest do
  @moduledoc """
  The colour scale (`bt_color_scale`): bars with the values underneath. Guards the
  decisions that are easy to undo by accident: no visible step number, legible type,
  one line per value, and a MASTER chip that does not depend on the swatch color.
  """
  use ExUnit.Case, async: true

  import Phoenix.Component
  import Phoenix.LiveViewTest
  import Bds.Components.CatalogUi

  @root Path.expand("../..", __DIR__)
  @forms_css Path.join(@root, "assets/src/styles/components/forms.css")

  defp scale_html(family \\ "bluetab-blue") do
    assigns = %{family: family}
    rendered_to_string(~H|<.bt_color_scale family={@family} />|)
  end

  # Every rule of the colour scale block in forms.css, as {selector, declarations}
  defp scale_rules do
    css = File.read!(@forms_css)
    [_before, scale] = String.split(css, "/* Color scale:", parts: 2)
    scale = Regex.replace(~r/\/\*.*?\*\//s, scale, "")

    ~r/([^{}]+)\{([^{}]*)\}/
    |> Regex.scan(scale)
    |> Enum.map(fn [_, selector, body] -> {String.trim(selector), body} end)
  end

  describe "markup" do
    test "renders nine steps, a copy button for each, and no visible step number" do
      html = scale_html()

      assert length(Regex.scan(~r/class="bt-color-scale__bar"/, html)) == 9
      assert length(Regex.scan(~r/data-copy-hex="#[0-9A-F]{6}"/, html)) == 9
      refute html =~ "bt-color-scale__level\""
      refute html =~ ~r/>\s*(10|20|30|40|50|60|70|80|90)\s*</
    end

    test "each step still shows its tone name, HEX, RGB and CMYK" do
      html = scale_html()

      assert html =~ "#212492"
      assert html =~ "RGB"
      assert html =~ "CMYK"
      assert html =~ "33 36 146"
      assert html =~ "White 80%"
      assert html =~ "Black 80%"
    end

    test "in Spanish the percent sign stays glued to its number (no-break space)" do
      Gettext.put_locale(Bds.Gettext, "es")

      html = scale_html()

      assert html =~ "Blanco 80\u00A0%"
      assert html =~ "Negro 80\u00A0%"
      refute html =~ "Blanco 80 %"
    end

    test "only the master carries the Pantone reference and the MASTER chip" do
      html = scale_html()

      assert length(Regex.scan(~r/bt-color-scale__chip/, html)) == 1
      assert length(Regex.scan(~r/<dt>Pantone<\/dt>/, html)) == 1
      assert html =~ "2746 C"
    end

    test "every swatch can be identified without the number (accessible name carries tone and HEX)" do
      html = scale_html()

      assert html =~ ~r/aria-label="[^"]*#212492[^"]*"/
      assert length(Regex.scan(~r/aria-label="[^"]*#[0-9A-F]{6}/, html)) == 9
    end

    test "contrast is shown as ratio and level on separate lines" do
      html = scale_html()

      assert length(Regex.scan(~r/bt-color-scale__ratio/, html)) == 9
      assert html =~ ~r/\d+\.\d\d:1/
    end

    test "show_contrast={false} hides the contrast block" do
      assigns = %{}
      html = rendered_to_string(~H|<.bt_color_scale family="red" show_contrast={false} />|)

      refute html =~ "bt-color-scale__contrast"
    end
  end

  describe "typography of the scale" do
    test "no text inside the scale is smaller than 0.75rem (12px)" do
      small =
        for {selector, body} <- scale_rules(),
            [_, size] <- Regex.scan(~r/font-size:\s*([\d.]+)rem/, body),
            String.to_float(pad(size)) < 0.75,
            do: "#{selector}: font-size #{size}rem"

      assert small == [], "text under 12px in the colour scale:\n" <> Enum.join(small, "\n")
    end

    test "never uses the 750 'heavy' weight: Titillium Web has no 750 face, it would paint as 900" do
      heavy =
        for {selector, body} <- scale_rules(),
            body =~ ~r/font-weight:\s*(750|var\(--bt-font-weight-heavy\))/,
            do: selector

      assert heavy == []
    end

    test "channel values stay on one line" do
      {_, body} = Enum.find(scale_rules(), fn {selector, _} -> selector == ".bt-color-scale__values" end)

      assert body =~ "white-space: nowrap"
    end

    test "the MASTER chip has its own background, so it never depends on the swatch color" do
      {_, body} = Enum.find(scale_rules(), fn {selector, _} -> selector == ".bt-color-scale__chip" end)

      assert body =~ "background:"
      assert body =~ "color: var(--bt-color-text)"
      refute body =~ "currentColor"
    end
  end

  describe "responsive layout" do
    test "switches from columns to rows with a container query, not a viewport media query" do
      css = File.read!(@forms_css)

      assert css =~ ~r/container:\s*bt-color-scale\s*\/\s*inline-size/
      assert css =~ "@container bt-color-scale (width < 44rem)"
      refute css =~ ~r/@media\s*\([^)]*width[^)]*\)\s*\{\s*\.bt-color-scale/
    end

    test "the bar is a real button that fills its cell" do
      {_, body} = Enum.find(scale_rules(), fn {selector, _} -> selector == ".bt-color-scale__bar" end)

      assert body =~ "cursor: pointer"
      assert body =~ "width: 100%"
    end
  end

  defp pad("." <> _ = n), do: "0" <> n
  defp pad(n), do: if(String.contains?(n, "."), do: n, else: n <> ".0")
end
