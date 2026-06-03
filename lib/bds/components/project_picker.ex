defmodule Bds.Components.ProjectPicker do
  @moduledoc """
  Searchable project picker widget for forms.

  Renders a card with a combobox search field and a hidden input for the selected
  project id. Pass a `search_fn` that accepts `(query, include_ended: boolean)` and
  returns a list of projects with at least `id`, `name`, `doc_num`, and optional `end_date`.

  On selection, sends `{:project_picker_change, component_id, project_id, project}` to the
  parent LiveView when `project` is the selected struct/map, or `nil` when cleared.
  """
  use Phoenix.LiveComponent
  use Gettext, backend: Bds.Gettext

  import Bds.Components
  import Bds.Components.CatalogUi

  attr :class, :any, default: nil
  attr :id, :string, required: true
  attr :value, :string, default: nil
  attr :search_fn, :any, required: true
  attr :field_name, :string, default: "project_id"
  attr :search_name, :string, default: "project_search"
  attr :title, :string, default: "Project"
  attr :description, :string, default: nil
  attr :label, :string, default: nil
  attr :placeholder, :string, default: "Search projects…"
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
     |> assign(:include_ended, false)
     |> assign(:show_panel, false)
     |> assign(:loading, false)
     |> assign(:selected_project, nil)}
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
      |> assign_new(:empty_label, fn -> gettext("No projects match your search.") end)
      |> assign_new(:searching_label, fn -> gettext("Searching…") end)
      |> assign_new(:selected_label, fn -> gettext("Selected") end)
      |> assign_new(:clear_event, fn -> "project_picker_clear" end)
      |> assign_new(:class, fn -> nil end)
      |> assign_new(:form, fn -> nil end)
      |> sync_from_value(assigns)

    {:ok, socket}
  end

  @impl true
  def handle_event("project_picker_search", params, socket) do
    query = search_query_from_params(params, socket.assigns.search_name)

    socket =
      socket
      |> assign(:search_query, query)
      |> assign(:loading, String.length(query) >= @min_query_length)
      |> assign(:show_panel, String.length(query) >= @min_query_length)

    if String.length(query) >= @min_query_length do
      projects =
        socket.assigns.search_fn.(query, include_ended: socket.assigns.include_ended)

      {:noreply,
       socket
       |> assign(:projects, projects)
       |> assign(:loading, false)}
    else
      {:noreply, assign(socket, :projects, [])}
    end
  end

  def handle_event("project_picker_toggle_ended", _params, socket) do
    include_ended = not socket.assigns.include_ended

    socket = assign(socket, :include_ended, include_ended)

    if String.length(socket.assigns.search_query) >= @min_query_length do
      projects =
        socket.assigns.search_fn.(socket.assigns.search_query, include_ended: include_ended)

      {:noreply, assign(socket, :projects, projects)}
    else
      {:noreply, socket}
    end
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
      |> assign(:show_panel, false)

    notify_parent(socket, nil)

    {:noreply, socket}
  end

  def handle_event("project_picker_focus", _params, socket) do
    show_panel =
      String.length(socket.assigns.search_query) >= @min_query_length and
        (socket.assigns.loading or socket.assigns.projects != [])

    {:noreply, assign(socket, :show_panel, show_panel)}
  end

  def handle_event("project_picker_blur", _params, socket) do
    send_update_after(socket.assigns.myself, [show_panel: false], 200)
    {:noreply, socket}
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

    ~H"""
    <div
      class={["bt-project-picker", @bare && "bt-project-picker--bare", @class]}
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
        </:panel_footer>
        <:options>
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
        <:empty>{@empty_label}</:empty>
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
