defmodule Bds.ContrastTest do
  use ExUnit.Case, async: true

  alias Bds.Contrast
  alias Bds.Tokens

  doctest Bds.Contrast

  describe "ratio/2" do
    test "matches WCAG reference values" do
      assert Contrast.ratio("#000", "#fff") == 21.0
      assert Contrast.ratio("#fff", "#fff") == 1.0
      # #767676 on white is the classic 4.54:1 minimum grey
      assert_in_delta Contrast.ratio("#767676", "#ffffff"), 4.54, 0.01
      assert_in_delta Contrast.ratio("#959595", "#ffffff"), 2.99, 0.01
    end

    test "is symmetric" do
      assert Contrast.ratio("#212492", "#ffffff") == Contrast.ratio("#ffffff", "#212492")
    end
  end

  describe "passes?/3" do
    test "never rounds up" do
      refute Contrast.passes?(4.499, :text, :aa)
      assert Contrast.passes?(4.5, :text, :aa)
      assert Contrast.passes?(3.0, :large_text, :aa)
      assert Contrast.passes?(3.0, :non_text, :aa)
      refute Contrast.passes?(21.0, :non_text, :aaa)
    end
  end

  test "format_ratio/1 truncates" do
    assert Contrast.format_ratio(4.4999) == "4.49:1"
    assert Contrast.format_ratio(21.0) == "21.00:1"
  end

  test "parse_hex/1 rejects invalid input" do
    assert {:error, :invalid_hex} = Contrast.parse_hex("#12345")
    assert {:error, :invalid_hex} = Contrast.parse_hex("#gggggg")
  end

  describe "Bds.Tokens" do
    test "reads light and dark color tokens from the built CSS" do
      assert Tokens.color("bt-color-primary", :light) == "#212492"
      assert Tokens.color("--bt-color-primary", :dark) == "#8da2ff"
      # not overridden in dark: inherits light
      assert Tokens.color("bt-color-secondary", :dark) ==
               Tokens.color("bt-color-secondary", :light)
    end

    test "failing pairs get a passing palette suggestion" do
      # Card borders are decorative (exempt), so they stay below 3:1 on purpose
      divider = Enum.find(Tokens.audit(:light), &(&1.name == "Divider / card border"))
      refute divider.passes
      assert %{token: "--bt-palette-" <> _, ratio: ratio} = divider.suggestion
      assert ratio >= 3.0
      assert Enum.all?(Tokens.audit(:light), &(&1.passes or &1.suggestion))
    end

    test "tokens defined with var() resolve to the referenced hex" do
      assert Tokens.color("bt-color-success-text", :light) ==
               Tokens.color("bt-palette-teal-70", :light)

      assert Tokens.color("bt-color-success-text", :dark) ==
               Tokens.color("bt-palette-teal-40", :dark)
    end

    test "text, status and control pairs meet WCAG AA in both themes" do
      for theme <- [:light, :dark],
          pair <- Tokens.audit(theme),
          pair.name != "Divider / card border" do
        assert pair.passes,
               "#{theme}: #{pair.name} #{pair.foreground_hex} on #{pair.background_hex} " <>
                 "is #{Bds.Contrast.format_ratio(pair.result.ratio)}"
      end
    end

    test "audit/1 resolves every pair" do
      for theme <- [:light, :dark] do
        audit = Tokens.audit(theme)
        assert length(audit) == length(Tokens.pairs())
        assert Enum.all?(audit, &is_boolean(&1.passes))
      end
    end
  end
end
