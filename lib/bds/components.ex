defmodule Bds.Components do
  @moduledoc """
  Phoenix function components for the Bluetab Design System (`bt-*` classes).

  Import in templates:

      import Bds.Components

  Form field errors are translated when `config :bds, gettext_backend: MyApp.Gettext`
  is set; otherwise messages are interpolated without Gettext.
  """
  use Phoenix.Component
  use Gettext, backend: Bds.Gettext

  import Bds.Components.CatalogUi, only: [bt_avatar: 1]

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
  attr :size, :string, default: nil, values: [nil, "xs", "sm", "lg"]
  attr :type, :string, default: "button"
  attr :disabled, :boolean, default: false
  attr :href, :string, default: nil
  attr :navigate, :any, default: nil
  attr :patch, :any, default: nil
  slot :inner_block, required: true

  def bt_button(assigns) do
    assigns = assign(assigns, :class, button_class(assigns))

    if assigns.href || assigns.navigate || assigns.patch do
      ~H"""
      <.link
        class={@class}
        href={@href}
        navigate={@navigate}
        patch={@patch}
        aria-disabled={@disabled && "true"}
        {@rest}
      >
        {render_slot(@inner_block)}
      </.link>
      """
    else
      ~H"""
      <button type={@type} class={@class} disabled={@disabled} {@rest}>
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
  attr :auto_dismiss, :any, default: :unspecified, doc: "auto-dismiss delay in ms; nil disables"
  attr :rest, :global, doc: "the arbitrary HTML attributes to add to the flash container"

  slot :inner_block, doc: "the optional inner block that renders the flash message"
  slot :icon
  slot :close

  def bt_flash(assigns) do
    assigns = assign_new(assigns, :id, fn -> "flash-#{assigns.kind}" end)

    assigns =
      assigns
      |> assign(:flash_message, Phoenix.Flash.get(assigns.flash, assigns.kind))
      |> then(fn assigns ->
        assigns
        |> assign(:auto_dismiss_ms, bt_flash_auto_dismiss(assigns))
        |> assign(:show?, bt_flash_show?(assigns))
      end)

    ~H"""
    <div
      :if={@show?}
      id={@id}
      phx-click={JS.push("lv:clear-flash", value: %{key: @kind}) |> JS.hide(to: "##{@id}")}
      phx-hook={@auto_dismiss_ms && "BtFlash"}
      data-auto-dismiss={@auto_dismiss_ms}
      role="alert"
      class={bt_flash_class(@kind)}
      {@rest}
    >
      <span :if={@icon != []}>{render_slot(@icon)}</span>
      <div class="bt-stack" style="gap:var(--bt-space-1);flex:1;">
        <p :if={@title} style="font-weight:700;margin:0;">{@title}</p>
        <p :if={@title} style="margin:0;">{render_slot(@inner_block)}</p>
        <p :if={!@title} style="margin:0;">{@flash_message}</p>
      </div>
      <button type="button" class="bt-icon-button bt-flash__close" aria-label={gettext("Close")}>
        <%= if @close != [] do %>
          {render_slot(@close)}
        <% else %>
          <span class="bt-icon">×</span>
        <% end %>
      </button>
    </div>
    """
  end

  defp bt_flash_show?(%{title: title}) when not is_nil(title), do: true
  defp bt_flash_show?(%{flash_message: msg}), do: bt_flash_visible?(msg)

  defp bt_flash_auto_dismiss(%{auto_dismiss: ms}) when is_integer(ms), do: ms
  defp bt_flash_auto_dismiss(%{auto_dismiss: nil}), do: nil

  defp bt_flash_auto_dismiss(%{auto_dismiss: :unspecified, title: title}) when not is_nil(title),
    do: nil

  defp bt_flash_auto_dismiss(%{auto_dismiss: :unspecified}), do: 5_000

  defp bt_flash_class(kind) do
    [
      "bt-flash bt-row",
      kind == :info && "bt-status--info",
      kind == :error && "bt-status--error"
    ]
  end

  defp bt_flash_visible?(nil), do: false
  defp bt_flash_visible?(""), do: false

  defp bt_flash_visible?(message) when is_binary(message),
    do: String.trim(message) != ""

  defp bt_flash_visible?(_), do: false

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

    rest = assigns |> Map.get(:rest, %{}) |> Map.drop([:value, "value"])

    assigns
    |> assign(field: nil, id: assigns.id || field.id, rest: rest, value: field.value)
    |> assign(:errors, Enum.map(errors, &translate_error/1))
    |> assign_new(:name, fn -> if assigns.multiple, do: field.name <> "[]", else: field.name end)
    |> bt_input()
  end

  def bt_input(%{type: "hidden"} = assigns) do
    ~H"""
    <input type="hidden" id={@id} name={@name} {@rest} value={@value} />
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
        class={@class || "bt-input"}
        {@rest}
        value={Phoenix.HTML.Form.normalize_value(@type, @value || "")}
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

  Pair with `<.bt_navbar_logo_link>`, `<.bt_navbar_theme_toggle>`, `<.bt_navbar_locale_toggle>`,
  and `<.bt_navbar_user_menu>` (with optional `<.bt_navbar_user_menu_prefs>` for language/theme rows).

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
  attr :label, :string, default: nil

  def bt_navbar_theme_toggle(assigns) do
    assigns = assign_string_default(assigns, :label, fn -> gettext("Toggle theme") end)

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
  Language toggle for the brand topbar — single control like `bt_navbar_theme_toggle`.

  Click fires `phx-click` with `phx-value-locale` set to the next locale (cycles the `locales` list).
  """
  attr :class, :any, default: nil
  attr :locale, :string, required: true
  attr :locales, :list, required: true
  attr :label, :string, default: nil
  attr :event, :string, default: "set_locale"
  attr :rest, :global

  def bt_navbar_locale_toggle(assigns) do
    assigns =
      assigns
      |> assign_string_default(:label, fn -> gettext("Toggle language") end)
      |> assign_string_default(:event, fn -> "set_locale" end)
      |> assign(:next_locale, next_locale(assigns.locale, assigns.locales))
      |> assign(:locale_display, locale_display(assigns.locale))

    ~H"""
    <div class={["bt-navbar-theme-toggle", "bt-navbar-locale-toggle", @class]} {@rest}>
      <button
        type="button"
        class="bt-theme-toggle-button"
        phx-click={@event}
        phx-value-locale={@next_locale}
        aria-label={@label}
        title={@label}
      >
        <span class="bt-icon" data-locale-icon aria-hidden="true">{@locale_display}</span>
      </button>
    </div>
    """
  end

  defp next_locale(current, locales) do
    codes = Enum.map(locales, & &1.code)

    case Enum.find_index(codes, &(&1 == current)) do
      nil -> List.first(codes) || "en"
      index -> Enum.at(codes, rem(index + 1, length(codes)))
    end
  end

  defp locale_display("es"), do: "ES"
  defp locale_display("en"), do: "EN"
  defp locale_display(code) when is_binary(code), do: String.upcase(code)
  defp locale_display(_), do: "ES"

  defp assign_string_default(assigns, key, value) when is_function(value, 0) do
    case Map.get(assigns, key) do
      nil -> assign(assigns, key, value.())
      "" -> assign(assigns, key, value.())
      existing -> assign(assigns, key, existing)
    end
  end

  @doc """
  User menu trigger + hover/focus dropdown for the brand topbar.

  For signed-in apps, nest `<.bt_navbar_user_menu_prefs>` with locale/theme toggles
  instead of standalone `<.bt_navbar_locale_toggle>` / `<.bt_navbar_theme_toggle>` in `:actions`.
  """
  attr :class, :any, default: nil
  attr :id, :string, default: nil
  attr :name, :string, required: true
  attr :role, :string, default: nil
  attr :email, :string, default: nil
  attr :initials, :string, default: "?"
  attr :avatar_src, :string, default: nil
  slot :inner_block, required: true

  def bt_navbar_user_menu(assigns) do
    assigns =
      assigns
      |> assign_new(:id, fn -> "bt-navbar-user-#{System.unique_integer([:positive])}" end)
      |> assign_string_default(:role, fn -> gettext("User") end)

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

        <.navbar_user_avatar
          name={@name}
          initials={@initials}
          avatar_src={@avatar_src}
          class="bt-navbar-user__avatar-wrap"
        />

        <span class="bt-navbar-user__chevron" aria-hidden="true">▾</span>
      </div>

      <div class="bt-navbar-user__dropdown" role="menu">
        <div class="bt-navbar-user__dropdown-header">
          <.bt_avatar
            name={@name}
            email={@email || @role}
            src={@avatar_src}
            initials={@initials}
            compactness="expanded"
          />
        </div>
        {render_slot(@inner_block)}
      </div>
    </div>
    """
  end

  attr :name, :string, required: true
  attr :initials, :string, required: true
  attr :avatar_src, :string, default: nil
  attr :class, :any, default: nil
  attr :show_status, :boolean, default: true

  defp navbar_user_avatar(assigns) do
    ~H"""
    <div class={@class}>
      <%= if @avatar_src do %>
        <img src={@avatar_src} alt={@name} class="bt-navbar-user__avatar" />
      <% else %>
        <div class="bt-navbar-user__avatar bt-navbar-user__avatar--initials" aria-hidden="true">
          {@initials}
        </div>
      <% end %>
      <span :if={@show_status} class="bt-navbar-user__status" aria-hidden="true"></span>
    </div>
    """
  end

  @doc """
  Preferences group inside `bt_navbar_user_menu` — language and theme rows.

  ## Examples

      <.bt_navbar_user_menu_prefs>
        <.bt_navbar_user_menu_locale_toggle locale="es" locales={@locales} />
        <.bt_navbar_user_menu_theme_toggle />
      </.bt_navbar_user_menu_prefs>
  """
  attr :label, :string, default: nil
  slot :inner_block, required: true

  def bt_navbar_user_menu_prefs(assigns) do
    assigns = assign_string_default(assigns, :label, fn -> gettext("Preferences") end)

    ~H"""
    <div class="bt-navbar-user__dropdown-prefs" role="group" aria-label={@label}>
      {render_slot(@inner_block)}
    </div>
    """
  end

  @doc """
  Language row for the user menu dropdown. Cycles `locales` on click (`phx-click` / `phx-value-locale`).
  """
  attr :class, :any, default: nil
  attr :locale, :string, required: true
  attr :locales, :list, required: true
  attr :label, :string, default: nil
  attr :event, :string, default: "set_locale"
  attr :rest, :global

  def bt_navbar_user_menu_locale_toggle(assigns) do
    assigns =
      assigns
      |> assign_string_default(:label, fn -> gettext("Language") end)
      |> assign(:next_locale, next_locale(assigns.locale, assigns.locales))
      |> assign(:current_label, locale_label(assigns.locale, assigns.locales))

    ~H"""
    <button
      type="button"
      class={["bt-navbar-menu-item", "bt-navbar-menu-item--toggle", @class]}
      phx-click={@event}
      phx-value-locale={@next_locale}
      aria-label={gettext("Toggle language")}
      {@rest}
    >
      <span class="bt-navbar-menu-item__label">{@label}</span>
      <span class="bt-navbar-menu-item__value">{@current_label}</span>
    </button>
    """
  end

  @doc """
  Theme row for the user menu dropdown. Uses `data-theme-toggle` (see package interactions).
  """
  attr :class, :any, default: nil
  attr :id, :string, default: nil
  attr :label, :string, default: nil
  attr :light_label, :string, default: nil
  attr :dark_label, :string, default: nil
  attr :rest, :global

  def bt_navbar_user_menu_theme_toggle(assigns) do
    assigns =
      assigns
      |> assign_new(:id, fn -> "bt-navbar-user-theme-#{System.unique_integer([:positive])}" end)
      |> assign_string_default(:label, fn -> gettext("Theme") end)
      |> assign_string_default(:light_label, fn -> gettext("Light") end)
      |> assign_string_default(:dark_label, fn -> gettext("Dark") end)

    ~H"""
    <button
      type="button"
      id={@id}
      class={["bt-navbar-menu-item", "bt-navbar-menu-item--toggle", @class]}
      data-theme-toggle
      aria-label={gettext("Toggle theme")}
      {@rest}
    >
      <span class="bt-navbar-menu-item__label">{@label}</span>
      <span
        data-theme-value
        data-light={@light_label}
        data-dark={@dark_label}
        class="bt-navbar-menu-item__value"
      >{@light_label}</span>
    </button>
    """
  end

  defp locale_label(locale, locales) do
    case Enum.find(locales, &(&1.code == locale)) do
      %{label: label} -> label
      _ -> locale_display(locale)
    end
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
            <td :if={@action != []} class="w-0 whitespace-nowrap">
              <div class="flex flex-wrap items-center gap-1.5">
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

  defp button_class(%{variant: variant} = assigns) do
    variant_class = Map.fetch!(@variants, variant)

    size_class =
      case Map.get(assigns, :size) do
        "xs" -> "bt-button--xs"
        "sm" -> "bt-button--sm"
        "lg" -> "bt-button--lg"
        _ -> nil
      end

    base =
      [variant_class, size_class]
      |> Enum.reject(&is_nil/1)

    extra = Map.get(assigns, :class)

    case extra do
      nil -> base
      extra when is_binary(extra) -> base ++ [extra]
      extra when is_list(extra) -> base ++ extra
      extra -> base ++ [extra]
    end
  end

  @doc """
  Translates a changeset or form error tuple.

  Configure `config :bds, gettext_backend: MyApp.Gettext` for Gettext support.
  """
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
