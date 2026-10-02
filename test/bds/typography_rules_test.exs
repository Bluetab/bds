defmodule Bds.TypographyRulesTest do
  @moduledoc """
  Typography rule: font weight 750 always carries at least 1px of
  letter-spacing. Scans every CSS rule and every inline `style` in BDS.
  """
  use ExUnit.Case, async: true

  @root Path.expand("../..", __DIR__)
  @heavy ~r/font-weight:\s*(750|var\(--bt-font-weight-heavy\))/

  # Accepted: the token, max(token, …), or a px/em value worth ≥ 1px at the
  # declared font size (em values are resolved against font-size when given).
  defp spacing_ok?(block) do
    case Regex.run(~r/letter-spacing:\s*([^;}"]+)/, block) do
      nil -> false
      [_, value] -> value_ok?(String.trim(value), block)
    end
  end

  defp value_ok?(value, block) do
    cond do
      String.contains?(value, "--bt-letter-spacing-heavy") -> true
      match = Regex.run(~r/^([\d.]+)px$/, value) -> String.to_float(pad(Enum.at(match, 1))) >= 1
      match = Regex.run(~r/^([\d.]+)em$/, value) -> em_ok?(String.to_float(pad(Enum.at(match, 1))), block)
      true -> false
    end
  end

  defp em_ok?(em, block) do
    px =
      case Regex.run(~r/font-size:\s*([\d.]+)(rem|px)/, block) do
        [_, n, "rem"] -> String.to_float(pad(n)) * 16
        [_, n, "px"] -> String.to_float(pad(n))
        _ -> 16
      end

    em * px >= 1
  end

  defp pad("." <> _ = n), do: "0" <> pad_dot(n)
  defp pad(n), do: pad_dot(n)
  defp pad_dot(n), do: if(String.contains?(n, "."), do: n, else: n <> ".0")

  defp offenders(blocks, label) do
    for {where, block} <- blocks, Regex.match?(@heavy, block), not spacing_ok?(block) do
      "#{label}#{where}: #{String.slice(block, 0, 120)}"
    end
  end

  test "every CSS rule with weight 750 has ≥ 1px letter-spacing" do
    css_files = Path.wildcard(Path.join(@root, "assets/src/styles/**/*.css"))
    assert css_files != []

    bad =
      Enum.flat_map(css_files, fn file ->
        blocks =
          ~r/([^{}]+)\{([^{}]*)\}/
          |> Regex.scan(File.read!(file))
          |> Enum.map(fn [_, selector, body] -> {" " <> String.trim(selector), body} end)

        offenders(blocks, Path.relative_to(file, @root))
      end)

    assert bad == [], "weight 750 without ≥ 1px letter-spacing:\n" <> Enum.join(bad, "\n")
  end

  test "every inline style with weight 750 has ≥ 1px letter-spacing" do
    bad =
      Path.join(@root, "lib/**/*.ex")
      |> Path.wildcard()
      |> Enum.flat_map(fn file ->
        blocks =
          ~r/style="([^"]*)"/
          |> Regex.scan(File.read!(file))
          |> Enum.map(fn [_, style] -> {"", style} end)

        offenders(blocks, Path.relative_to(file, @root))
      end)

    assert bad == [], Enum.join(bad, "\n")
  end
end
