defmodule Bds.Catalog do
  @moduledoc """
  Component catalog metadata shared by the Vite HTML catalog and Phoenix storybook apps.

  Data is generated from [`assets/src/catalog.js`](../../assets/src/catalog.js) into
  `priv/catalog.json` via `npm run export:catalog` (also runs after `npm run build:lib`).
  """

  @catalog_path Path.join([:code.priv_dir(:bds), "catalog.json"])

  @external_resource @catalog_path
  @catalog @catalog_path |> File.read!() |> Jason.decode!()

  @group_order @catalog["group_order"]
  @tokens_snippet @catalog["tokens_snippet"]
  @components @catalog["components"]

  @component_ids Map.new(@components, fn component -> {component["id"], component} end)

  @doc "Navigation group order for the catalog sidebar."
  @spec group_order() :: [String.t()]
  def group_order, do: @group_order

  @doc "All catalog components."
  @spec components() :: [map()]
  def components, do: @components

  @doc "CSS tokens snippet shown in the doc panel."
  @spec tokens_snippet() :: String.t()
  def tokens_snippet, do: @tokens_snippet

  @doc "Default component id when none is selected."
  @spec default_id() :: String.t()
  def default_id, do: "get-started"

  @doc false
  @spec get(String.t()) :: map() | nil
  def get(id) when is_binary(id), do: Map.get(@component_ids, id)

  @doc false
  @spec get!(String.t()) :: map()
  def get!(id) when is_binary(id) do
    case get(id) do
      nil -> raise ArgumentError, "unknown catalog component #{inspect(id)}"
      component -> component
    end
  end

  @doc false
  @spec valid_id?(String.t()) :: boolean()
  def valid_id?(id) when is_binary(id), do: Map.has_key?(@component_ids, id)

  @doc """
  Returns components in `group`, optionally filtered by a case-insensitive query on title/id.
  """
  @spec components_in_group(String.t(), String.t()) :: [map()]
  def components_in_group(group, filter \\ "") do
    q = filter |> String.trim() |> String.downcase()

    @components
    |> Enum.filter(&(&1["group"] == group))
    |> Enum.filter(fn component ->
      q == "" or
        String.contains?(String.downcase(component["title"]), q) or
        String.contains?(String.downcase(component["id"]), q)
    end)
  end

  @doc """
  Normalizes an example HTML snippet (trim surrounding blank lines).
  """
  @spec normalize_snippet(String.t()) :: String.t()
  def normalize_snippet(value) when is_binary(value) do
    value
    |> String.trim()
  end

  @doc """
  Returns HTML for a single example by `component_id:index` ref.
  """
  @spec example_html(String.t()) :: String.t()
  def example_html(ref) when is_binary(ref) do
    case String.split(ref, ":", parts: 2) do
      [component_id, index_str] ->
        component = get(component_id)

        with %{} = component,
             examples when is_list(examples) <- component["examples"],
             {index, ""} <- Integer.parse(index_str),
             example when is_map(example) <- Enum.at(examples, index) do
          example["html"] || ""
        else
          _ -> ""
        end

      _ ->
        ""
    end
  end

  @doc """
  Escapes HTML and adds syntax-highlight spans for catalog code blocks.
  """
  @spec highlight_html(String.t()) :: Phoenix.HTML.safe()
  def highlight_html(value) when is_binary(value) do
    value
    |> escape_html()
    |> highlight_tags()
    |> highlight_attrs()
    |> highlight_values()
    |> Phoenix.HTML.raw()
  end

  defp escape_html(value) do
    value
    |> String.replace("&", "&amp;")
    |> String.replace("<", "&lt;")
    |> String.replace(">", "&gt;")
    |> String.replace("\"", "&quot;")
    |> String.replace("'", "&#039;")
  end

  defp highlight_tags(html) do
    Regex.replace(~r/(&lt;\/?)([\w-]+)/, html, "\\1<span class=\"bt-code__tag\">\\2</span>")
  end

  defp highlight_attrs(html) do
    Regex.replace(~r/\s([\w:-]+)=/, html, " <span class=\"bt-code__attr\">\\1</span>=")
  end

  defp highlight_values(html) do
    Regex.replace(~r/(&quot;.*?&quot;)/, html, "<span class=\"bt-code__value\">\\1</span>")
  end
end
