defmodule Bds.GettextTest do
  @moduledoc """
  Gettext serves fuzzy entries at runtime, so a `mix gettext.merge` guess
  (e.g. "Search users…" → "Search projects…") ships as a real translation.
  """
  use ExUnit.Case, async: true

  @po Path.wildcard(Path.expand("../../priv/gettext/*/LC_MESSAGES/*.po", __DIR__))

  test "no .po file has fuzzy entries" do
    assert @po != []

    fuzzy =
      for file <- @po,
          {line, n} <- file |> File.read!() |> String.split("\n") |> Enum.with_index(1),
          line =~ ~r/^#,.*\bfuzzy\b/ do
        "#{Path.relative_to_cwd(file)}:#{n}"
      end

    assert fuzzy == [],
           "Review these translations and remove the fuzzy flag:\n" <> Enum.join(fuzzy, "\n")
  end
end
