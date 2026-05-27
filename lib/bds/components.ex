defmodule Bds.Components do
  @moduledoc """
  Phoenix function components for the Bluetab Design System (`bt-*` classes).

  Import in templates:

      import Bds.Components

  Form field errors are translated when `config :bds, gettext_backend: MyApp.Gettext`
  is set; otherwise messages are interpolated without Gettext.
  """
  use Phoenix.Component

  alias Phoenix.LiveView.JS

  @variants %{
    "primary" => "bt-button",
    "secondary" => "bt-button bt-button--secondary",
    "tertiary" => "bt-button bt-button--tertiary",
    "outline" => "bt-button bt-button--outline",
    "ghost" => "bt-button bt-button--ghost",
    "danger" => "bt-button bt-button--danger"
  }

  @doc """
  Renders a design-system button (`bt-button` variants).

  ## Examples

      <.bt_button>Save</.bt_button>
      <.bt_button variant="primary" phx-click="save">Save</.bt_button>
      <.bt_button navigate={~p"/"}>Home</.bt_button>
  """
  attr :rest, :global
  attr :class, :any
  attr :variant, :string, default: "primary", values: ~w(primary secondary tertiary outline ghost danger)
  attr :type, :string, default: "button"
  attr :href, :string, default: nil
  attr :navigate, :any, default: nil
  attr :patch, :any, default: nil
  slot :inner_block, required: true

  def bt_button(assigns) do
    assigns = assign(assigns, :class, button_class(assigns))

    if assigns.href || assigns.navigate || assigns.patch do
      ~H"""
      <.link class={@class} href={@href} navigate={@navigate} patch={@patch} {@rest}>
        {render_slot(@inner_block)}
      </.link>
      """
    else
      ~H"""
      <button type={@type} class={@class} {@rest}>
        {render_slot(@inner_block)}
      </button>
      """
    end
  end

  @doc """
  Renders flash notices with `bt-surface` styling.

  Icon slots are optional — pass `icon` slot content from your app (e.g. Heroicons).
  """
  attr :id, :string, doc: "the optional id of flash container"
  attr :flash, :map, default: %{}, doc: "the map of flash messages to display"
  attr :title, :string, default: nil
  attr :kind, :atom, values: [:info, :error], doc: "used for styling and flash lookup"
  attr :rest, :global, doc: "the arbitrary HTML attributes to add to the flash container"

  slot :inner_block, doc: "the optional inner block that renders the flash message"
  slot :icon

  def bt_flash(assigns) do
    assigns = assign_new(assigns, :id, fn -> "flash-#{assigns.kind}" end)

    ~H"""
    <div
      :if={
        case {render_slot(@inner_block), Phoenix.Flash.get(@flash, @kind)} do
          {nil, nil} -> false
          {"", nil} -> false
          {nil, ""} -> false
          _ -> true
        end
      }
      id={@id}
      phx-click={JS.push("lv:clear-flash", value: %{key: @kind}) |> JS.hide(to: "##{@id}")}
      role="alert"
      class={[
        "bt-surface bt-row",
        @kind == :info && "bt-status--info",
        @kind == :error && "bt-status--error"
      ]}
      style="padding:var(--bt-space-3);box-shadow:var(--bt-shadow-md);cursor:pointer;"
      {@rest}
    >
      <span :if={@icon != []}>{render_slot(@icon)}</span>
      <div class="bt-stack" style="gap:var(--bt-space-1);flex:1;">
        <p :if={@title} style="font-weight:700;margin:0;">{@title}</p>
        <p style="margin:0;">
          {case render_slot(@inner_block) do
            nil -> Phoenix.Flash.get(@flash, @kind)
            "" -> Phoenix.Flash.get(@flash, @kind)
            content -> content
          end}
        </p>
      </div>
    </div>
    """
  end

  attr :id, :any, default: nil
  attr :name, :any
  attr :label, :string, default: nil
  attr :value, :any, default: nil

  attr :type, :string,
    default: "text",
    values: ~w(checkbox color date datetime-local email file month number password
               search select tel text textarea time url week hidden)

  attr :field, Phoenix.HTML.FormField,
    doc: "a form field struct retrieved from the form, for example: @form[:email]"

  attr :errors, :list, default: []
  attr :checked, :boolean, doc: "the checked flag for checkbox inputs"
  attr :prompt, :string, default: nil, doc: "the prompt for select inputs"
  attr :options, :list, doc: "the options to pass to Phoenix.HTML.Form.options_for_select/2"
  attr :multiple, :boolean, default: false, doc: "the multiple flag for select inputs"
  attr :class, :any, default: nil, doc: "the input class to use over defaults"
  attr :error_class, :any, default: nil, doc: "the input error class to use over defaults"
  attr :help, :string, default: nil, doc: "optional help text below the control"

  attr :rest, :global,
    include: ~w(accept autocomplete capture cols disabled form list max maxlength min minlength
                multiple pattern placeholder readonly required rows size step)

  @doc """
  Renders a form control with `bt-field`, `bt-input`, `bt-select`, etc.
  """
  def bt_input(%{field: %Phoenix.HTML.FormField{} = field} = assigns) do
    errors = if Phoenix.Component.used_input?(field), do: field.errors, else: []

    assigns
    |> assign(field: nil, id: assigns.id || field.id)
    |> assign(:errors, Enum.map(errors, &translate_error/1))
    |> assign_new(:name, fn -> if assigns.multiple, do: field.name <> "[]", else: field.name end)
    |> assign_new(:value, fn -> field.value end)
    |> bt_input()
  end

  def bt_input(%{type: "hidden"} = assigns) do
    ~H"""
    <input type="hidden" id={@id} name={@name} value={@value} {@rest} />
    """
  end

  def bt_input(%{type: "checkbox"} = assigns) do
    assigns =
      assign_new(assigns, :checked, fn ->
        Phoenix.HTML.Form.normalize_value("checkbox", assigns[:value])
      end)

    ~H"""
    <div class={["bt-field", @errors != [] && "bt-field--error"]}>
      <input
        type="hidden"
        name={@name}
        value="false"
        disabled={@rest[:disabled]}
        form={@rest[:form]}
      />
      <label class="bt-checkbox" for={@id}>
        <input
          type="checkbox"
          id={@id}
          name={@name}
          value="true"
          checked={@checked}
          class={@class}
          {@rest}
        />
        {@label}
      </label>
      <.bt_field_help :if={@help}>{@help}</.bt_field_help>
      <.bt_field_error :for={msg <- @errors}>{msg}</.bt_field_error>
    </div>
    """
  end

  def bt_input(%{type: "select"} = assigns) do
    ~H"""
    <div class={["bt-field", @errors != [] && "bt-field--error"]}>
      <label :if={@label} for={@id}>{@label}</label>
      <select
        id={@id}
        name={@name}
        class={@class || "bt-select"}
        multiple={@multiple}
        {@rest}
      >
        <option :if={@prompt} value="">{@prompt}</option>
        {Phoenix.HTML.Form.options_for_select(@options, @value)}
      </select>
      <.bt_field_help :if={@help}>{@help}</.bt_field_help>
      <.bt_field_error :for={msg <- @errors}>{msg}</.bt_field_error>
    </div>
    """
  end

  def bt_input(%{type: "textarea"} = assigns) do
    ~H"""
    <div class={["bt-field", @errors != [] && "bt-field--error"]}>
      <label :if={@label} for={@id}>{@label}</label>
      <textarea id={@id} name={@name} class={@class || "bt-textarea"} {@rest}>
        {Phoenix.HTML.Form.normalize_value("textarea", @value)}
      </textarea>
      <.bt_field_help :if={@help}>{@help}</.bt_field_help>
      <.bt_field_error :for={msg <- @errors}>{msg}</.bt_field_error>
    </div>
    """
  end

  def bt_input(assigns) do
    ~H"""
    <div class={["bt-field", @errors != [] && "bt-field--error"]}>
      <label :if={@label} for={@id}>{@label}</label>
      <input
        type={@type}
        name={@name}
        id={@id}
        value={Phoenix.HTML.Form.normalize_value(@type, @value || "")}
        class={@class || "bt-input"}
        {@rest}
      />
      <.bt_field_help :if={@help}>{@help}</.bt_field_help>
      <.bt_field_error :for={msg <- @errors}>{msg}</.bt_field_error>
    </div>
    """
  end

  slot :inner_block, required: true

  defp bt_field_help(assigns) do
    ~H"""
    <span class="bt-help">{render_slot(@inner_block)}</span>
    """
  end

  defp bt_field_error(assigns) do
    ~H"""
    <p class="bt-help bt-row" style="color:var(--bt-color-error);">
      {render_slot(@inner_block)}
    </p>
    """
  end

  @doc "Section header with `bt-section__title`."
  attr :level, :atom, default: :page, values: [:page, :section]
  slot :inner_block, required: true
  slot :subtitle
  slot :actions

  def bt_header(assigns) do
    ~H"""
    <header class={["bt-section__header", @actions != [] && "bt-row"]}>
      <div>
        <h1 :if={@level == :page} class="bt-section__title">{render_slot(@inner_block)}</h1>
        <h2 :if={@level == :section} class="bt-section__title">{render_slot(@inner_block)}</h2>
        <p :if={@subtitle != []} class="bt-section__description">
          {render_slot(@subtitle)}
        </p>
      </div>
      <div :if={@actions != []} class="bt-row">{render_slot(@actions)}</div>
    </header>
    """
  end

  @doc """
  Top navbar (`bt-topbar`): Bluetab gradient bar with logo, actions, theme toggle, and user menu.

  Pair with `<.bt_navbar_logo_link>`, `<.bt_navbar_theme_toggle>`, and `<.bt_navbar_user_menu>`.

  ## Examples

      <.bt_topbar>
        <:brand>
          <.bt_navbar_logo_link navigate={~p"/"} logo_src={~p"/images/slash_logo_white.png"}>
            My App
          </.bt_navbar_logo_link>
        </:brand>
        <:actions>
          <.bt_navbar_theme_toggle />
        </:actions>
      </.bt_topbar>
  """
  attr :class, :any, default: nil
  attr :contained, :boolean, default: false, doc: "constrain inner bar to --bt-content-max-width"
  attr :rest, :global
  slot :start
  slot :brand
  slot :actions

  def bt_topbar(assigns) do
    ~H"""
    <header class={["bt-topbar", @class]} {@rest}>
      <div class={[
        "bt-topbar__inner",
        @contained && "bt-topbar__inner--contained"
      ]}>
        <div class="bt-topbar__start">
          {render_slot(@start)}
          {render_slot(@brand)}
        </div>
        <div :if={@actions != []} class="bt-topbar__actions">
          {render_slot(@actions)}
        </div>
      </div>
    </header>
    """
  end

  @doc """
  Logo link for the brand topbar (`bt-navbar-logo-link`).

  Pass `navigate` for LiveView navigation or `href` for a plain link.
  """
  attr :class, :any, default: nil
  attr :rest, :global
  attr :href, :string, default: nil
  attr :navigate, :any, default: nil
  attr :patch, :any, default: nil
  attr :logo_src, :string, required: true
  attr :logo_alt, :string, default: ""
  slot :inner_block, required: true

  def bt_navbar_logo_link(%{navigate: navigate} = assigns) when not is_nil(navigate) do
    ~H"""
    <.link navigate={@navigate} class={["bt-navbar-logo-link", @class]} {@rest}>
      <img src={@logo_src} alt={@logo_alt} class="bt-navbar-logo-img" fetchpriority="high" />
      {render_slot(@inner_block)}
    </.link>
    """
  end

  def bt_navbar_logo_link(%{patch: patch} = assigns) when not is_nil(patch) do
    ~H"""
    <.link patch={@patch} class={["bt-navbar-logo-link", @class]} {@rest}>
      <img src={@logo_src} alt={@logo_alt} class="bt-navbar-logo-img" fetchpriority="high" />
      {render_slot(@inner_block)}
    </.link>
    """
  end

  def bt_navbar_logo_link(assigns) do
    ~H"""
    <a href={@href || "#"} class={["bt-navbar-logo-link", @class]} {@rest}>
      <img src={@logo_src} alt={@logo_alt} class="bt-navbar-logo-img" fetchpriority="high" />
      {render_slot(@inner_block)}
    </a>
    """
  end

  @doc """
  Theme toggle styled for the brand topbar. Uses `data-theme-toggle` (see package interactions).
  """
  attr :class, :any, default: nil
  attr :rest, :global
  attr :label, :string, default: "Toggle theme"

  def bt_navbar_theme_toggle(assigns) do
    ~H"""
    <div class={["bt-navbar-theme-toggle", @class]}>
      <button
        type="button"
        class="bt-theme-toggle-button"
        data-theme-toggle
        aria-label={@label}
        title={@label}
        {@rest}
      >
        <span class="bt-icon" data-theme-icon aria-hidden="true">◐</span>
      </button>
    </div>
    """
  end

  @doc """
  User menu trigger + hover/focus dropdown for the brand topbar.
  """
  attr :class, :any, default: nil
  attr :id, :string, default: nil
  attr :name, :string, required: true
  attr :role, :string, default: "User"
  attr :initials, :string, default: "?"
  attr :avatar_src, :string, default: nil
  slot :inner_block, required: true

  def bt_navbar_user_menu(assigns) do
    assigns = assign_new(assigns, :id, fn -> "bt-navbar-user-#{System.unique_integer([:positive])}" end)

    ~H"""
    <div id={@id} class={["bt-navbar-user", @class]} tabindex="-1">
      <div
        class="bt-navbar-user__trigger bt-navbar-user__trigger--compact"
        role="button"
        aria-haspopup="menu"
        tabindex="0"
      >
        <div class="bt-navbar-user__meta">
          <div class="bt-navbar-user__role">{@role}</div>
          <div class="bt-navbar-user__name">{@name}</div>
        </div>

        <div class="bt-navbar-user__avatar-wrap">
          <%= if @avatar_src do %>
            <img src={@avatar_src} alt={@name} class="bt-navbar-user__avatar" />
          <% else %>
            <div class="bt-navbar-user__avatar bt-navbar-user__avatar--initials" aria-hidden="true">
              {@initials}
            </div>
          <% end %>
          <span class="bt-navbar-user__status" aria-hidden="true"></span>
        </div>

        <span class="bt-navbar-user__chevron" aria-hidden="true">▾</span>
      </div>

      <div class="bt-navbar-user__dropdown" role="menu">
        <div class="bt-navbar-user__dropdown-header">
          <p class="bt-navbar-user__name">{@name}</p>
          <p class="bt-navbar-user__role">{@role}</p>
        </div>
        {render_slot(@inner_block)}
      </div>
    </div>
    """
  end

  attr :id, :string, required: true
  attr :rows, :list, required: true
  attr :row_id, :any, default: nil, doc: "the function for generating the row id"
  attr :row_click, :any, default: nil, doc: "the function for handling phx-click on each row"

  attr :row_item, :any,
    default: &Function.identity/1,
    doc: "the function for mapping each row before calling the :col and :action slots"

  slot :col, required: true do
    attr :label, :string
  end

  slot :action, doc: "the slot for showing user actions in the last table column"

  @doc "Data table with `bt-table` styling."
  def bt_table(assigns) do
    assigns =
      with %{rows: %Phoenix.LiveView.LiveStream{}} <- assigns do
        assign(assigns, row_id: assigns.row_id || fn {id, _item} -> id end)
      end

    ~H"""
    <div class="bt-table-wrap">
      <table class="bt-table">
        <thead>
          <tr>
            <th :for={col <- @col}>{col[:label]}</th>
            <th :if={@action != []}>
              <span class="sr-only">Actions</span>
            </th>
          </tr>
        </thead>
        <tbody id={@id} phx-update={is_struct(@rows, Phoenix.LiveView.LiveStream) && "stream"}>
          <tr :for={row <- @rows} id={@row_id && @row_id.(row)}>
            <td
              :for={col <- @col}
              phx-click={@row_click && @row_click.(row)}
              class={@row_click && "hover:cursor-pointer"}
            >
              {render_slot(col, @row_item.(row))}
            </td>
            <td :if={@action != []} class="w-0 font-semibold">
              <div class="flex gap-4">
                <%= for action <- @action do %>
                  {render_slot(action, @row_item.(row))}
                <% end %>
              </div>
            </td>
          </tr>
        </tbody>
      </table>
    </div>
    """
  end

  slot :item, required: true do
    attr :title, :string, required: true
  end

  @doc "Description list with `bt-list` styling."
  def bt_list(assigns) do
    ~H"""
    <ul class="bt-list">
      <li :for={item <- @item} class="bt-list-item">
        <div class="bt-list-item__content">
          <span class="bt-list-item__title">{item.title}</span>
          <span class="bt-list-item__subtitle">{render_slot(item)}</span>
        </div>
      </li>
    </ul>
    """
  end

  attr :class, :any, default: nil
  slot :inner_block, required: true

  @doc "Inline code (`bt-code-inline`)."
  def bt_code(assigns) do
    ~H"""
    <code class={["bt-code-inline", @class]}>{render_slot(@inner_block)}</code>
    """
  end

  attr :class, :any, default: nil
  slot :inner_block, required: true

  @doc "Multiline code block (`bt-code-block`)."
  def bt_code_block(assigns) do
    ~H"""
    <div class="bt-code-block">
      <pre class={["bt-code", @class]} phx-no-curly-interpolation>
        <code phx-no-curly-interpolation>{render_slot(@inner_block)}</code>
      </pre>
    </div>
    """
  end

  @doc """
  Translates a changeset or form error tuple.

  Configure `config :bds, gettext_backend: MyApp.Gettext` for Gettext support.
  """
  defp button_class(%{variant: variant} = assigns) do
    variant_class = Map.fetch!(@variants, variant)
    extra = Map.get(assigns, :class)

    case extra do
      nil -> variant_class
      extra when is_binary(extra) -> "#{variant_class} #{extra}"
      extra when is_list(extra) -> [variant_class | extra]
      extra -> [variant_class, extra]
    end
  end

  def translate_error({msg, opts}) do
    if backend = Application.get_env(:bds, :gettext_backend) do
      if count = opts[:count] do
        Gettext.dngettext(backend, "errors", msg, msg, count, opts)
      else
        Gettext.dgettext(backend, "errors", msg, opts)
      end
    else
      Enum.reduce(opts, msg, fn {key, value}, acc ->
        String.replace(acc, "%{#{key}}", to_string(value))
      end)
    end
  end

  def translate_errors(errors, field) when is_list(errors) do
    for {^field, {msg, opts}} <- errors, do: translate_error({msg, opts})
  end
end
