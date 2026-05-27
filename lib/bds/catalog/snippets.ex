defmodule Bds.Catalog.Snippets do
  @moduledoc """
  HEEx documentation snippets for catalog examples (`component_id:index` refs).
  """

  @modules [Bds.Catalog.Snippets.Bulk]

  @snippets Enum.reduce(@modules, %{}, fn mod, acc ->
              Map.merge(acc, mod.snippets())
            end)

  @doc false
  @spec heex(String.t()) :: String.t()
  def heex(ref) when is_binary(ref) do
    Map.get(@snippets, ref, fallback(ref))
  end

  @doc false
  @spec heex!(String.t()) :: String.t()
  def heex!(ref), do: Map.fetch!(@snippets, ref)

  defp fallback(ref) do
    """
    # No HEEx snippet registered for #{ref}
    # Import components: import Bds.Components
    # import Bds.Components.CatalogUi
    """
    |> String.trim()
  end
end
