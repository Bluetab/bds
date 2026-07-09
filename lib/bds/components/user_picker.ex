defmodule Bds.Components.UserPicker do
  @moduledoc """
  Searchable user picker widget for forms.

  Renders a card with a combobox search field and hidden input(s) for the
  selected user id(s). Results are a flat list (no tree). Each option shows an
  expanded avatar; the selected chip(s) use compact avatars.

  Pass a `search_fn` that accepts `(query, options)` and returns a list of user
  maps/structs with at least `id`, `email`, and optional `given_name`,
  `family_name`, `picture`, `hidden_at`, and `search_score` (when scores are
  loaded for `debug_scores`).

  ## Options passed to `search_fn`

    * `:show_inactive` — reflects the config panel toggle
    * `:include_scores` — true when `debug_scores` is enabled on the component

  ## Parent messages

    * Single (`multi: false`): `{:user_picker_change, id, user_id, user}`
    * Multi (`multi: true`): `{:user_picker_change, id, [user_id, ...], [user, ...]}`
  """
  use Phoenix.LiveComponent
  use Gettext, backend: Bds.Gettext

  import Bds.Components.CatalogUi

  attr :class, :any, default: nil
  attr :id, :string, required: true
  attr :value, :any, default: nil
  attr :search_fn, :any, required: true
  attr :field_name, :string, default: "user_id"
  attr :search_name, :string, default: "user_search"
  attr :title, :string, default: "User"
  attr :description, :string, default: nil
  attr :label, :string, default: nil
  attr :placeholder, :string, default: "Search users…"
  attr :selected_user, :any, default: nil
  attr :selected_users, :list, default: []
  attr :bare, :boolean, default: false, doc: "Form field layout without card chrome"
  attr :multi, :boolean, default: false, doc: "Allow selecting multiple users"
  attr :debug_scores, :boolean, default: false, doc: "Show search similarity score on each option"

  attr :form, :string,
    default: nil,
    doc: "Parent form id when the picker is rendered inside a LiveView form"

  @impl true
  def mount(socket) do
    {:ok,
     socket
     |> assign(:search_query, "")
     |> assign(:users, [])
     |> assign(:show_inactive, false)
     |> assign(:show_panel, false)
     |> assign(:show_config, false)
     |> assign(:loading, false)
     |> assign(:selected_user, nil)
     |> assign(:selected_users, [])
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
      |> assign_new(:field_name, fn -> "user_id" end)
      |> assign_new(:search_name, fn -> "user_search" end)
      |> assign_new(:title, fn -> gettext("User") end)
      |> assign_new(:description, fn -> nil end)
      |> assign_new(:placeholder, fn -> gettext("Search users…") end)
      |> assign_new(:show_inactive_label, fn -> gettext("Show inactive users") end)
      |> assign_new(:settings_label, fn -> gettext("Settings") end)
      |> assign_new(:empty_label, fn -> gettext("No users match your search.") end)
      |> assign_new(:empty_browse_label, fn -> gettext("No users available.") end)
      |> assign_new(:searching_label, fn -> gettext("Searching…") end)
      |> assign_new(:inactive_label, fn -> gettext("Inactive") end)
      |> assign_new(:score_label, fn -> gettext("Score") end)
      |> assign_new(:class, fn -> nil end)
      |> assign_new(:form, fn -> nil end)
      |> assign_new(:show_config, fn -> false end)
      |> assign_new(:blur_pending, fn -> false end)
      |> assign_new(:multi, fn -> false end)
      |> assign_new(:debug_scores, fn -> false end)
      |> assign_new(:selected_users, fn -> [] end)
      |> then(fn s -> assign(s, :multi?, Map.get(s.assigns, :multi, false)) end)
      |> then(fn s -> assign(s, :show_combobox?, show_combobox?(s)) end)
      |> sync_from_value(assigns)

    {:ok, socket}
  end

  @impl true
  def handle_event("user_picker_search", params, socket) do
    query = search_query_from_params(params, socket.assigns.search_name)

    socket =
      socket
      |> assign(:search_query, query)
      |> assign(:loading, true)
      |> assign(:show_panel, true)
      |> load_users(query)

    {:noreply, socket}
  end

  def handle_event("user_picker_toggle_inactive", _params, socket) do
    show_inactive = not socket.assigns.show_inactive

    socket =
      socket
      |> assign(:show_inactive, show_inactive)
      |> keep_panel_open()
      |> load_users(socket.assigns.search_query)

    {:noreply, socket}
  end

  def handle_event("user_picker_select", %{"user_id" => user_id}, socket) do
    user =
      Enum.find(socket.assigns.users, fn entry ->
        user_id(entry) == user_id
      end)

    socket =
      if socket.assigns.multi? do
        socket
        |> toggle_multi_selection(user)
        |> assign(:blur_pending, false)
      else
        select_single_user(socket, user)
      end

    {:noreply, socket}
  end

  def handle_event("user_picker_clear", _params, socket) do
    socket =
      socket
      |> assign(:selected_user, nil)
      |> assign(:selected_users, [])
      |> assign(:value, nil)
      |> assign(:search_query, "")
      |> assign(:users, [])
      |> assign(:show_panel, false)
      |> assign(:show_combobox?, true)

    notify_parent(socket, nil)

    {:noreply, socket}
  end

  def handle_event("user_picker_remove", %{"user_id" => user_id}, socket) do
    selected_users =
      Enum.reject(socket.assigns.selected_users, &(user_id(&1) == user_id))

    socket =
      socket
      |> assign(:selected_users, selected_users)
      |> assign(:value, encode_value(selected_users, true))
      |> assign(:show_combobox?, true)

    notify_parent(socket, selected_users)

    {:noreply, socket}
  end

  def handle_event("user_picker_focus", _params, socket) do
    socket =
      socket
      |> assign(:show_panel, true)
      |> assign(:blur_pending, false)
      |> load_users(socket.assigns.search_query)

    {:noreply, socket}
  end

  def handle_event("user_picker_blur", _params, socket) do
    send_update_after(socket.assigns.myself, %{close_panel: true}, 200)
    {:noreply, assign(socket, :blur_pending, true)}
  end

  def handle_event("user_picker_toggle_config", _params, socket) do
    {:noreply,
     socket
     |> assign(:show_config, not socket.assigns.show_config)
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
      |> assign(:panel_empty?, assigns.users == [])
      |> assign(:empty_message, empty_message(assigns))
      |> assign(:has_selection?, has_selection?(assigns))

    ~H"""
    <div
      class={[
        "bt-user-picker",
        @bare && "bt-user-picker--bare",
        @multi? && "bt-user-picker--multi",
        @debug_scores && "bt-user-picker--debug-scores",
        @class
      ]}
      id={@id}
    >
      <%= if @bare do %>
        <div class="bt-field">
          <label :if={@field_label && !@has_selection?} for={@search_input_id}>
            {@field_label}
          </label>
          <span :if={@field_label && @has_selection?} class="bt-label">{@field_label}</span>
          <.user_picker_body {assigns} />
        </div>
      <% else %>
        <.bt_card variant="filled">
          <div :if={@title != "" or @description} class="bt-user-picker__header">
            <div>
              <h3 :if={@title != ""} class="bt-user-picker__title">{@title}</h3>
              <p :if={@description} class="bt-user-picker__description">{@description}</p>
            </div>
          </div>

          <.user_picker_body {assigns} />
        </.bt_card>
      <% end %>
    </div>
    """
  end

  defp user_picker_body(assigns) do
    assigns = assign_new(assigns, :form, fn -> nil end)

    ~H"""
    <div class="bt-user-picker__body">
      <input
        :if={!@multi?}
        type="hidden"
        name={@field_name}
        value={@value || ""}
        form={@form}
      />
      <input
        :for={user <- @selected_users}
        :if={@multi?}
        type="hidden"
        name={@field_name}
        value={user_id(user)}
        form={@form}
      />

      <.bt_combobox
        :if={@show_combobox?}
        input_id={@search_input_id}
        name={@search_name}
        label={@combobox_label}
        value={@search_query}
        placeholder={@placeholder}
        open={@show_panel}
        loading={@loading}
        target={@myself}
        phx-change="user_picker_search"
        phx-debounce="300"
        phx-focus="user_picker_focus"
        phx-blur="user_picker_blur"
        autocomplete="off"
        errors={Map.get(assigns, :errors, [])}
      >
        <:panel_footer :if={@show_panel}>
          <div class="bt-user-picker__toolbar">
            <button
              type="button"
              class={[
                "bt-user-picker__config-toggle",
                @show_config && "bt-user-picker__config-toggle--active"
              ]}
              aria-label={@settings_label}
              aria-expanded={to_string(@show_config)}
              phx-click="user_picker_toggle_config"
              phx-target={@myself}
            >
              <span class="bt-icon" aria-hidden="true">⚙</span>
            </button>
          </div>
          <div :if={@show_config} class="bt-user-picker__config">
            <label class="bt-checkbox">
              <input
                type="checkbox"
                name="show_inactive"
                value="true"
                checked={@show_inactive}
                phx-click="user_picker_toggle_inactive"
                phx-target={@myself}
              />
              <span>{@show_inactive_label}</span>
            </label>
          </div>
        </:panel_footer>
        <:options>
          <.bt_combobox_option
            :for={user <- @users}
            selected={selected?(user, assigns)}
            variant={if(user_inactive?(user), do: "warning", else: "default")}
            phx-click="user_picker_select"
            phx-target={@myself}
            phx-value-user_id={user_id(user)}
          >
            <div class="bt-user-picker__option-content">
              <.bt_avatar
                name={user_display_name(user)}
                email={user_email(user)}
                src={user_picture(user)}
                compactness="expanded"
                badges={user_badges(user, @inactive_label)}
              />
              <span :if={@debug_scores} class="bt-user-picker__score" title={@score_label}>
                {format_search_score(user)}
              </span>
            </div>
          </.bt_combobox_option>
        </:options>
        <:empty>{@empty_message}</:empty>
        <:loading_content>{@searching_label}</:loading_content>
      </.bt_combobox>

      <div :if={@multi? && @selected_users != []} class="bt-user-picker__selected-list">
        <div :for={user <- @selected_users} class="bt-user-picker__selected">
          <.bt_avatar
            name={user_display_name(user)}
            email={user_email(user)}
            src={user_picture(user)}
            compactness="compact"
            badges={user_badges(user, @inactive_label)}
          />
          <button
            type="button"
            class="bt-user-picker__clear"
            aria-label={assigns[:clear_aria_label] || "Remove selection"}
            phx-click="user_picker_remove"
            phx-target={@myself}
            phx-value-user_id={user_id(user)}
          >
            ×
          </button>
        </div>
      </div>

      <div :if={!@multi? && @selected_user} class="bt-user-picker__selected">
        <.bt_avatar
          name={user_display_name(@selected_user)}
          email={user_email(@selected_user)}
          src={user_picture(@selected_user)}
          compactness="compact"
          badges={user_badges(@selected_user, @inactive_label)}
        />
        <button
          type="button"
          class="bt-user-picker__clear"
          aria-label={assigns[:clear_aria_label] || "Clear selection"}
          phx-click="user_picker_clear"
          phx-target={@myself}
        >
          ×
        </button>
      </div>
    </div>
    """
  end

  defp select_single_user(socket, user) do
    socket
    |> assign(:selected_user, user)
    |> assign(:selected_users, [])
    |> assign(:value, if(user, do: user_id(user), else: nil))
    |> assign(:search_query, "")
    |> assign(:show_panel, false)
    |> assign(:users, [])
    |> assign(:show_combobox?, false)
    |> tap(&notify_parent(&1, user))
  end

  defp toggle_multi_selection(socket, nil), do: socket

  defp toggle_multi_selection(socket, user) do
    id = user_id(user)

    selected_users =
      if Enum.any?(socket.assigns.selected_users, &(user_id(&1) == id)) do
        Enum.reject(socket.assigns.selected_users, &(user_id(&1) == id))
      else
        socket.assigns.selected_users ++ [user]
      end

    socket
    |> assign(:selected_users, selected_users)
    |> assign(:selected_user, nil)
    |> assign(:value, encode_value(selected_users, true))
    |> assign(:search_query, socket.assigns.search_query)
    |> assign(:show_panel, true)
    |> assign(:show_combobox?, true)
    |> tap(&notify_parent(&1, selected_users))
  end

  defp load_users(socket, query) do
    users =
      if is_function(socket.assigns[:search_fn]) do
        socket.assigns.search_fn.(query,
          show_inactive: socket.assigns.show_inactive,
          include_scores: socket.assigns.debug_scores
        )
      else
        []
      end

    socket
    |> assign(:users, users)
    |> assign(:loading, false)
    |> assign(:show_panel, true)
  end

  defp keep_panel_open(socket) do
    socket
    |> assign(:blur_pending, false)
    |> assign(:show_panel, true)
  end

  defp show_combobox?(socket) do
    if socket.assigns.multi? do
      true
    else
      is_nil(socket.assigns.selected_user)
    end
  end

  defp has_selection?(assigns) do
    if assigns.multi? do
      assigns.selected_users != []
    else
      not is_nil(assigns.selected_user)
    end
  end

  defp empty_message(assigns) do
    if String.trim(assigns.search_query || "") == "" do
      assigns.empty_browse_label
    else
      assigns.empty_label
    end
  end

  defp sync_from_value(socket, %{value: value} = assigns) when is_binary(value) and value != "" do
    if socket.assigns.multi? do
      sync_multi_value(socket, value, assigns)
    else
      sync_single_value(socket, value, assigns)
    end
  end

  defp sync_from_value(socket, %{value: nil}) do
    socket
    |> assign(:value, nil)
    |> assign(:show_combobox?, show_combobox?(assign(socket, :selected_user, nil)))
  end

  defp sync_from_value(socket, %{value: ""}) do
    if socket.assigns.multi? do
      socket
      |> assign(:value, nil)
      |> assign(:show_combobox?, true)
    else
      socket
      |> assign(:value, nil)
      |> assign(:selected_user, nil)
      |> assign(:selected_users, [])
      |> assign(:search_query, "")
      |> assign(:show_combobox?, true)
    end
  end

  defp sync_from_value(socket, assigns) do
    cond do
      socket.assigns.multi? && populated_list?(Map.get(assigns, :selected_users)) ->
        selected_users = List.wrap(assigns.selected_users)

        socket
        |> assign(:selected_users, selected_users)
        |> assign(:selected_user, nil)
        |> assign(:value, encode_value(selected_users, true))
        |> assign(:show_combobox?, true)

      Map.has_key?(assigns, :selected_user) ->
        selected = assigns.selected_user

        socket
        |> assign(:selected_user, selected)
        |> assign(:selected_users, [])
        |> assign(:value, if(selected, do: user_id(selected), else: nil))
        |> assign(:search_query, "")
        |> assign(:show_combobox?, is_nil(selected))

      true ->
        socket
    end
  end

  defp sync_single_value(socket, value, assigns) do
    if socket.assigns[:value] == value and socket.assigns[:selected_user] do
      socket
    else
      selected =
        case Map.get(assigns, :selected_user) do
          nil -> socket.assigns[:selected_user]
          user -> user
        end

      socket
      |> assign(:value, value)
      |> assign(:selected_user, selected)
      |> assign(:search_query, "")
      |> assign(:show_combobox?, is_nil(selected))
    end
  end

  defp sync_multi_value(socket, value, assigns) do
    if socket.assigns[:value] == value and socket.assigns[:selected_users] != [] do
      socket
      |> assign(:show_combobox?, true)
    else
      selected_users =
        case Map.get(assigns, :selected_users) do
          users when is_list(users) and users != [] ->
            users

          _ ->
            reconcile_selected_users(socket.assigns[:selected_users] || [], value)
        end

      socket
      |> assign(:value, value)
      |> assign(:selected_users, selected_users)
      |> assign(:selected_user, nil)
      |> assign(:show_combobox?, true)
    end
  end

  defp reconcile_selected_users(selected_users, value) when is_binary(value) do
    ids = value |> String.split(",", trim: true) |> MapSet.new()

    Enum.filter(selected_users, &(user_id(&1) in ids))
  end

  defp reconcile_selected_users(_selected_users, _value), do: []

  defp populated_list?(users) when is_list(users), do: users != []
  defp populated_list?(_), do: false

  defp notify_parent(socket, nil) do
    if socket.assigns.multi? do
      send(self(), {:user_picker_change, socket.assigns.id, [], []})
    else
      send(self(), {:user_picker_change, socket.assigns.id, nil, nil})
    end
  end

  defp notify_parent(socket, users) when is_list(users) do
    ids = Enum.map(users, &user_id/1)
    send(self(), {:user_picker_change, socket.assigns.id, ids, users})
  end

  defp notify_parent(socket, user) do
    send(self(), {:user_picker_change, socket.assigns.id, user && user_id(user), user})
  end

  defp encode_value(users, true) when is_list(users) do
    users
    |> Enum.map(&user_id/1)
    |> Enum.reject(&(&1 == ""))
    |> Enum.join(",")
  end

  defp encode_value(user, false), do: user && user_id(user)

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

  defp selected?(user, %{multi?: true, selected_users: selected_users}) do
    Enum.any?(selected_users, &(user_id(&1) == user_id(user)))
  end

  defp selected?(user, %{selected_user: selected}) do
    selected && user_id(user) == user_id(selected)
  end

  defp user_id(%{id: id}), do: to_string(id)
  defp user_id(id) when is_binary(id), do: id

  defp user_email(%{email: email}) when is_binary(email), do: email
  defp user_email(_), do: nil

  defp user_picture(%{picture: picture}) when is_binary(picture) and picture != "", do: picture
  defp user_picture(_), do: nil

  defp user_display_name(user) do
    given = Map.get(user, :given_name)
    family = Map.get(user, :family_name)

    name =
      [given, family]
      |> Enum.reject(&(is_nil(&1) or &1 == ""))
      |> Enum.join(" ")
      |> String.trim()

    if name == "" do
      user_email(user) || "—"
    else
      name
    end
  end

  defp user_inactive?(user), do: not is_nil(Map.get(user, :hidden_at))

  defp user_badges(user, inactive_label) do
    if user_inactive?(user) do
      [%{label: inactive_label, variant: "warning"}]
    else
      []
    end
  end

  defp user_search_score(user) do
    cond do
      match?(%{search_score: score}, user) and not is_nil(user.search_score) -> user.search_score
      is_map(user) -> Map.get(user, :search_score)
      true -> nil
    end
  end

  defp format_search_score(user) do
    case user_search_score(user) do
      score when is_number(score) -> :erlang.float_to_binary(score * 1.0, decimals: 2)
      _ -> "—"
    end
  end
end
