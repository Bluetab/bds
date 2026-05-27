defmodule Bds.Catalog.Preview do
  @moduledoc """
  Renders catalog examples with `Bds.Components` for Storybook previews.
  """
  use Phoenix.Component

  import Phoenix.HTML

  @bulk Bds.Catalog.Preview.Bulk

  @component_ids Bds.Catalog.components() |> Enum.map(& &1["id"])

  @renderers Map.new(@component_ids, fn id -> {id, @bulk} end)

  attr :component_id, :string, required: true
  attr :index, :integer, required: true

  def catalog_example(assigns) do
    case render_example(assigns.component_id, assigns.index, assigns) do
      nil ->
        ref = "#{assigns.component_id}:#{assigns.index}"
        assigns = assign(assigns, :html, Bds.Catalog.example_html(ref))
        ~H"{raw(@html)}"

      rendered ->
        rendered
    end
  end

  defp render_example(component_id, index, assigns) do
    case Map.get(@renderers, component_id) do
      nil -> nil
      module -> module.render(component_id, index, assigns)
    end
  end
end
