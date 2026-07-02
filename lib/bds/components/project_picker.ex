defmodule Bds.Components.ProjectPicker do
  @moduledoc """
  Searchable project picker widget for forms.

  Renders a card with a combobox search field and a hidden input for the selected
  project id.

  ## Browse mode (org tree)

  Pass a `tree_fn` that accepts `(query, include_ended: boolean)` and returns:

    * `:display_tree` — list of nodes for `bt_tree/1` (project leaves should set
      `:selectable` and `:project_id`)
    * `:expanded_paths` — `MapSet` of branch keys to expand
    * `:projects` — flat list of project maps for selection lookup

  The panel opens on focus and shows the full hierarchy; search filters the tree.

  ## Flat search mode

  Pass a `search_fn` that accepts `(query, include_ended: boolean)` and returns
  a list of projects with at least `id`, `name`, `doc_num`, and optional `end_date`.
  Requires at least two characters before results appear.

  On selection, sends `{:project_picker_change, component_id, project_id, project}` to the
  parent LiveView when `project` is the selected struct/map, or `nil` when cleared.
  """
  use Phoenix.LiveComponent
  use Gettext, backend: Bds.Gettext

  import Bds.Components.CatalogUi

  attr :class, :any, default: nil
  attr :id, :string, required: true
  attr :value, :string, default: nil
  attr :search_fn, :any, default: nil
  attr :tree_fn, :any, default: nil
  attr :field_name, :string, default: "project_id"
  attr :search_name, :string, default: "project_search"
  attr :title, :string, default: "Project"
  attr :description, :string, default: nil
  attr :label, :string, default: nil
  attr :placeholder, :string, default: "Search projects…"
  attr :show_clients_without_group, :boolean, default: false
  attr :show_projects_without_client, :boolean, default: false
  attr :selected_project, :any, default: nil
  attr :bare, :boolean, default: false, doc: "Form field layout without card chrome (e.g. day modal editor)"

  attr :form, :string,
    default: nil,
    doc: "Parent form id when the picker is rendered inside a LiveView form (associates hidden input)"

  @min_query_length 2

  @impl true
  def mount(socket) do
    {:ok,
     socket
     |> assign(:search_query, "")
     |> assign(:projects, [])
     |> assign(:display_tree, [])
     |> assign(:expanded_paths, MapSet.new())
     |> assign(:include_ended, false)
     |> assign(:show_clients_without_group, false)
     |> assign(:show_projects_without_client, false)
     |> assign(:show_panel, false)
     |> assign(:show_config, false)
     |> assign(:loading, false)
     |> assign(:selected_project, nil)
     |> assign(:blur_pending, false)}
  end

  @impl true
  def update(%{close_panel: true}, socket) do
    socket =
      if socket.assigns[:blur_pending] do
        socket
        |> assign(:show_panel, false)
        |> assign(:blur_pending, false)
      else
        socket
      end

    {:ok, socket}
  end

  @impl true
  def update(assigns, socket) do
    socket =
      socket
      |> assign(assigns)
      |> assign_new(:field_name, fn -> "project_id" end)
      |> assign_new(:search_name, fn -> "project_search" end)
      |> assign_new(:title, fn -> gettext("Project") end)
      |> assign_new(:description, fn -> nil end)
      |> assign_new(:placeholder, fn -> gettext("Search projects…") end)
      |> assign_new(:include_inactive_label, fn -> gettext("Include inactive projects") end)
      |> assign_new(:show_clients_without_group_label, fn -> gettext("Show clients without group") end)
      |> assign_new(:show_projects_without_client_label, fn -> gettext("Show projects without client") end)
      |> assign_new(:settings_label, fn -> gettext("Settings") end)
      |> assign_new(:collapse_all_label, fn -> gettext("Collapse all") end)
      |> assign_new(:expand_all_label, fn -> gettext("Expand all") end)
      |> assign_new(:empty_label, fn -> gettext("No projects match your search.") end)
      |> assign_new(:empty_browse_label, fn -> gettext("No projects available.") end)
      |> assign_new(:searching_label, fn -> gettext("Searching…") end)
      |> assign_new(:selected_label, fn -> gettext("Selected") end)
      |> assign_new(:clear_event, fn -> "project_picker_clear" end)
      |> assign_new(:class, fn -> nil end)
      |> assign_new(:form, fn -> nil end)
      |> assign_new(:show_config, fn -> false end)
      |> assign_new(:blur_pending, fn -> false end)
      |> then(fn s -> assign(s, :tree_mode?, tree_mode?(s)) end)
      |> sync_from_value(assigns)

    {:ok, socket}
  end

  @impl true
  def handle_event("project_picker_search", params, socket) do
    query = search_query_from_params(params, socket.assigns.search_name)

    socket =
      socket
      |> assign(:search_query, query)
      |> then(fn s ->
        if tree_mode?(s) do
          load_tree(s, query)
        else
          s
          |> assign(:loading, String.length(query) >= @min_query_length)
          |> assign(:show_panel, String.length(query) >= @min_query_length)
          |> load_flat_search(query)
        end
      end)

    {:noreply, socket}
  end

  def handle_event("project_picker_toggle_ended", _params, socket) do
    include_ended = not socket.assigns.include_ended
    socket =
      socket
      |> assign(:include_ended, include_ended)
      |> reload_for_filter_change()

    {:noreply, socket}
  end

  def handle_event("project_picker_toggle_clients_without_group", _params, socket) do
    socket =
      socket
      |> assign(:show_clients_without_group, not socket.assigns.show_clients_without_group)
      |> reload_for_filter_change()

    {:noreply, socket}
  end

  def handle_event("project_picker_toggle_projects_without_client", _params, socket) do
    socket =
      socket
      |> assign(:show_projects_without_client, not socket.assigns.show_projects_without_client)
      |> reload_for_filter_change()

    {:noreply, socket}
  end

  def handle_event("project_picker_select", %{"project_id" => project_id}, socket) do
    selected =
      Enum.find(socket.assigns.projects, fn project ->
        project_id(project) == project_id
      end)

    socket =
      socket
      |> assign(:selected_project, selected)
      |> assign(:value, if(selected, do: project_id(selected), else: nil))
      |> assign(:search_query, "")
      |> assign(:show_panel, false)
      |> assign(:display_tree, [])
      |> assign(:projects, [])

    notify_parent(socket, selected)

    {:noreply, socket}
  end

  def handle_event("project_picker_clear", _params, socket) do
    socket =
      socket
      |> assign(:selected_project, nil)
      |> assign(:value, nil)
      |> assign(:search_query, "")
      |> assign(:projects, [])
      |> assign(:display_tree, [])
      |> assign(:show_panel, false)

    notify_parent(socket, nil)

    {:noreply, socket}
  end

  def handle_event("project_picker_focus", _params, socket) do
    socket =
      if tree_mode?(socket) do
        socket
        |> assign(:show_panel, true)
        |> assign(:blur_pending, false)
        |> load_tree(socket.assigns.search_query)
      else
        show_panel =
          String.length(socket.assigns.search_query) >= @min_query_length and
            (socket.assigns.loading or socket.assigns.projects != [])

        assign(socket, :show_panel, show_panel)
      end

    {:noreply, socket}
  end

  def handle_event("project_picker_blur", _params, socket) do
    send_update_after(socket.assigns.myself, %{close_panel: true}, 200)
    {:noreply, assign(socket, :blur_pending, true)}
  end

  def handle_event("project_picker_toggle_branch", %{"key" => key}, socket) do
    expanded = socket.assigns.expanded_paths

    expanded =
      if MapSet.member?(expanded, key),
        do: MapSet.delete(expanded, key),
        else: MapSet.put(expanded, key)

    {:noreply,
     socket
     |> assign(:expanded_paths, expanded)
     |> keep_panel_open()}
  end

  def handle_event("project_picker_toggle_config", _params, socket) do
    {:noreply,
     socket
     |> assign(:show_config, not socket.assigns.show_config)
     |> keep_panel_open()}
  end

  def handle_event("project_picker_collapse_all", _params, socket) do
    {:noreply,
     socket
     |> assign(:expanded_paths, MapSet.new())
     |> keep_panel_open()}
  end

  def handle_event("project_picker_expand_all", _params, socket) do
    {:noreply,
     socket
     |> assign(:expanded_paths, all_tree_keys(socket.assigns.display_tree))
     |> keep_panel_open()}
  end

  @impl true
  def render(assigns) do
    bare? = Map.get(assigns, :bare, false)

    assigns =
      assigns
      |> assign(:bare, bare?)
      |> assign(:search_input_id, "#{assigns.id}-search-input")
      |> assign(:field_label, if(bare?, do: assigns[:label], else: nil))
      |> assign(:combobox_label, if(bare?, do: nil, else: assigns[:label]))
      |> assign(:panel_empty?, panel_empty?(assigns))
      |> assign(:empty_message, empty_message(assigns))

    ~H"""
    <div
      class={[
        "bt-project-picker",
        @bare && "bt-project-picker--bare",
        @tree_mode? && "bt-project-picker--tree",
        @class
      ]}
      id={@id}
    >
      <%= if @bare do %>
        <div class="bt-field">
          <label :if={@field_label && is_nil(@selected_project)} for={@search_input_id}>
            {@field_label}
          </label>
          <span :if={@field_label && @selected_project} class="bt-label">{@field_label}</span>
          <.project_picker_body {assigns} />
        </div>
      <% else %>
        <.bt_card variant="filled">
          <div :if={@title != "" or @description} class="bt-project-picker__header">
            <div>
              <h3 :if={@title != ""} class="bt-project-picker__title">{@title}</h3>
              <p :if={@description} class="bt-project-picker__description">{@description}</p>
            </div>
          </div>

          <.project_picker_body {assigns} />
        </.bt_card>
      <% end %>
    </div>
    """
  end

  defp project_picker_body(assigns) do
    assigns = assign_new(assigns, :form, fn -> nil end)

    ~H"""
    <div class="bt-project-picker__body">
      <input type="hidden" name={@field_name} value={@value || ""} form={@form} />

      <.bt_combobox
        :if={is_nil(@selected_project)}
        input_id={@search_input_id}
        name={@search_name}
        label={@combobox_label}
        value={@search_query}
        placeholder={@placeholder}
        open={@show_panel}
        loading={@loading}
        target={@myself}
        phx-change="project_picker_search"
        phx-debounce="300"
        phx-focus="project_picker_focus"
        phx-blur="project_picker_blur"
        autocomplete="off"
        errors={Map.get(assigns, :errors, [])}
      >
        <:panel_footer :if={@show_panel}>
          <div class="bt-project-picker__toolbar">
            <div :if={@tree_mode?} class="bt-project-picker__toolbar-group">
              <button
                type="button"
                class="bt-project-picker__toolbar-btn"
                phx-click="project_picker_collapse_all"
                phx-target={@myself}
              >
                {@collapse_all_label}
              </button>
              <button
                type="button"
                class="bt-project-picker__toolbar-btn"
                phx-click="project_picker_expand_all"
                phx-target={@myself}
              >
                {@expand_all_label}
              </button>
            </div>
            <button
              type="button"
              class={[
                "bt-project-picker__config-toggle",
                @show_config && "bt-project-picker__config-toggle--active"
              ]}
              aria-label={@settings_label}
              aria-expanded={to_string(@show_config)}
              phx-click="project_picker_toggle_config"
              phx-target={@myself}
            >
              <span class="bt-icon" aria-hidden="true">⚙</span>
            </button>
          </div>
          <div :if={@show_config} class="bt-project-picker__config">
            <label class="bt-checkbox">
              <input
                type="checkbox"
                name="include_ended"
                value="true"
                checked={@include_ended}
                phx-click="project_picker_toggle_ended"
                phx-target={@myself}
              />
              <span>{@include_inactive_label}</span>
            </label>
            <label class="bt-checkbox">
              <input
                type="checkbox"
                name="show_clients_without_group"
                value="true"
                checked={@show_clients_without_group}
                phx-click="project_picker_toggle_clients_without_group"
                phx-target={@myself}
              />
              <span>{@show_clients_without_group_label}</span>
            </label>
            <label class="bt-checkbox">
              <input
                type="checkbox"
                name="show_projects_without_client"
                value="true"
                checked={@show_projects_without_client}
                phx-click="project_picker_toggle_projects_without_client"
                phx-target={@myself}
              />
              <span>{@show_projects_without_client_label}</span>
            </label>
          </div>
        </:panel_footer>
        <:options :if={@tree_mode? and @display_tree != []}>
          <.bt_tree
            id={"#{@id}-tree"}
            nodes={@display_tree}
            expanded={@expanded_paths}
            toggle_event="project_picker_toggle_branch"
            toggle_target={@myself}
            select_event="project_picker_select"
            select_target={@myself}
            class="bt-project-picker__tree"
          />
        </:options>
        <:options :if={not @tree_mode?}>
          <.bt_combobox_option
            :for={project <- @projects}
            selected={selected?(project, @selected_project)}
            variant={if(project_inactive?(project), do: "warning", else: "default")}
            phx-click="project_picker_select"
            phx-target={@myself}
            phx-value-project_id={project_id(project)}
          >
            <span class="bt-combobox__option-title">{project_doc_num(project) || "—"}</span>
            <span> — {project_name(project)}</span>
            <span :if={project_end_date(project)} class="bt-combobox__option-sub">
              {inactive_label(project)}
            </span>
          </.bt_combobox_option>
        </:options>
        <:empty>{@empty_message}</:empty>
        <:loading_content>{@searching_label}</:loading_content>
      </.bt_combobox>

      <div :if={@selected_project} class="bt-project-picker__selected">
        <p class="bt-project-picker__selected-text">
          <strong>{project_doc_num(@selected_project) || "—"}</strong>
          — {project_name(@selected_project)}
          <span :if={project_end_date(@selected_project)} class="bt-project-picker__selected-meta">
            {inactive_label(@selected_project)}
          </span>
        </p>
        <button
          type="button"
          class="bt-project-picker__clear"
          aria-label={assigns[:clear_aria_label] || "Clear selection"}
          phx-click="project_picker_clear"
          phx-target={@myself}
        >
          ×
        </button>
      </div>
    </div>
    """
  end

  defp load_tree(socket, query) do
    picker_opts = [
      include_ended: socket.assigns.include_ended,
      show_clients_without_group: socket.assigns.show_clients_without_group,
      show_projects_without_client: socket.assigns.show_projects_without_client
    ]

    %{display_tree: display_tree, expanded_paths: expanded_paths, projects: projects} =
      socket.assigns.tree_fn.(query, picker_opts)

    socket
    |> assign(:display_tree, display_tree)
    |> assign(:expanded_paths, expanded_paths)
    |> assign(:projects, projects)
    |> assign(:loading, false)
    |> assign(:show_panel, true)
  end

  defp load_flat_search(socket, query) do
    cond do
      not is_function(socket.assigns[:search_fn]) ->
        assign(socket, :projects, [])

      String.length(query) >= @min_query_length ->
        projects =
          socket.assigns.search_fn.(query,
            include_ended: socket.assigns.include_ended,
            show_clients_without_group: socket.assigns.show_clients_without_group,
            show_projects_without_client: socket.assigns.show_projects_without_client
          )

        socket
        |> assign(:projects, projects)
        |> assign(:loading, false)

      true ->
        assign(socket, :projects, [])
    end
  end

  defp keep_panel_open(socket) do
    socket
    |> assign(:blur_pending, false)
    |> assign(:show_panel, true)
  end

  defp reload_for_filter_change(socket) do
    query = socket.assigns.search_query

    socket
    |> keep_panel_open()
    |> then(fn s ->
      cond do
        tree_mode?(s) ->
          load_tree(s, query)

        String.length(query) >= @min_query_length ->
          load_flat_search(s, query)

        true ->
          s
      end
    end)
  end

  defp tree_mode?(socket), do: is_function(socket.assigns[:tree_fn])

  defp all_tree_keys(nodes) when is_list(nodes) do
    Enum.reduce(nodes, MapSet.new(), fn node, acc ->
      children = Map.get(node, :children, [])

      acc = if children != [], do: MapSet.put(acc, node.key), else: acc

      MapSet.union(acc, all_tree_keys(children))
    end)
  end

  defp panel_empty?(assigns) do
    cond do
      assigns.tree_mode? -> assigns.display_tree == []
      true -> assigns.projects == []
    end
  end

  defp empty_message(assigns) do
    if assigns.tree_mode? and String.trim(assigns.search_query || "") == "" do
      assigns.empty_browse_label
    else
      assigns.empty_label
    end
  end

  defp sync_from_value(socket, %{value: value} = assigns) when is_binary(value) and value != "" do
    if socket.assigns[:value] == value and socket.assigns[:selected_project] do
      socket
    else
      selected = Map.get(assigns, :selected_project)

      socket
      |> assign(:value, value)
      |> assign(:selected_project, selected)
      |> assign(:search_query, "")
    end
  end

  defp sync_from_value(socket, %{value: nil}), do: assign(socket, :value, nil)

  defp sync_from_value(socket, %{value: ""}), do:
    socket
    |> assign(:value, nil)
    |> assign(:selected_project, nil)
    |> assign(:search_query, "")

  defp sync_from_value(socket, assigns) do
    if Map.has_key?(assigns, :selected_project) do
      selected = assigns.selected_project

      socket
      |> assign(:selected_project, selected)
      |> assign(:value, if(selected, do: project_id(selected), else: nil))
      |> assign(:search_query, "")
    else
      socket
    end
  end

  defp notify_parent(socket, project) do
    send(
      self(),
      {:project_picker_change, socket.assigns.id, project && project_id(project), project}
    )
  end

  defp search_query_from_params(params, search_name) do
    cond do
      is_map(params[search_name]) ->
        params[search_name] |> Map.values() |> List.first() |> to_string() |> String.trim()

      is_binary(params[search_name]) ->
        String.trim(params[search_name])

      true ->
        params
        |> Map.values()
        |> Enum.find_value("", fn
          v when is_binary(v) -> String.trim(v)
          _ -> ""
        end)
    end
  end

  defp selected?(project, selected) do
    selected && project_id(project) == project_id(selected)
  end

  defp project_id(%{id: id}), do: to_string(id)
  defp project_id(id) when is_binary(id), do: id

  defp project_name(%{name: name}), do: name
  defp project_name(_), do: "—"

  defp project_doc_num(%{doc_num: num}) when not is_nil(num), do: to_string(num)
  defp project_doc_num(_), do: nil

  defp project_end_date(%{end_date: date}), do: date
  defp project_end_date(_), do: nil

  defp project_inactive?(project), do: not is_nil(project_end_date(project))

  defp inactive_label(project) do
    date = project_end_date(project)

    if date do
      ended = Calendar.strftime(date, "%Y-%m-%d")
      "Ended #{ended}"
    else
      ""
    end
  end
end
