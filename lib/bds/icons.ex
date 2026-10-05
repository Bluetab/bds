defmodule Bds.Icons do
  @moduledoc """
  Names of every Material Symbols Rounded glyph shipped with BDS.

  Generated from `@material-symbols/font-400` (the package the self-hosted
  font comes from) into `priv/material_symbols.json` by
  `npm run export:icons` (also runs after `npm run build:lib`).
  """

  @icons_path Path.join([:code.priv_dir(:bds), "material_symbols.json"])

  @external_resource @icons_path
  @names @icons_path |> File.read!() |> Jason.decode!()
  @name_set MapSet.new(@names)

  @doc "All ligature names, sorted."
  @spec names() :: [String.t()]
  def names, do: @names

  @doc "Number of icons in the library."
  @spec count() :: non_neg_integer()
  def count, do: length(@names)

  @doc "Whether `name` is a ligature of the icon font."
  @spec valid?(String.t()) :: boolean()
  def valid?(name) when is_binary(name), do: MapSet.member?(@name_set, name)

  @doc """
  Names containing every word of `query` (case-insensitive; spaces and `_`
  are interchangeable). Names that start with the query come first.
  """
  @spec search(String.t()) :: [String.t()]
  def search(query) when is_binary(query) do
    case query |> String.downcase() |> String.replace("_", " ") |> String.split() do
      [] ->
        @names

      words ->
        prefix = Enum.join(words, "_")

        @names
        |> Enum.filter(fn name -> Enum.all?(words, &String.contains?(name, &1)) end)
        |> Enum.sort_by(&{not String.starts_with?(&1, prefix), String.length(&1), &1})
    end
  end
end
