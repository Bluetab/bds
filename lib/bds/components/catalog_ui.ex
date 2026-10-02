defmodule Bds.Components.CatalogUi do
  @moduledoc false
  use Phoenix.Component
  use Gettext, backend: Bds.Gettext

  @button_variants %{
    "primary" => "bt-button",
    "secondary" => "bt-button bt-button--secondary",
    "tertiary" => "bt-button bt-button--tertiary",
    "outline" => "bt-button bt-button--outline",
    "ghost" => "bt-button bt-button--ghost",
    "danger" => "bt-button bt-button--danger",
    "sm" => "bt-button bt-button--sm",
    "lg" => "bt-button bt-button--lg"
  }

  # Shared size scale for every sized component. "md" is the default and adds no
  # modifier class; other sizes add `<base>--<size>`. Heights come from the
  # --bt-control-height-* tokens so products rescale every control at once.
  @sizes ~w(xs sm md lg)

  @doc false
  def size_class(_base, "md"), do: nil
  def size_class(_base, nil), do: nil
  def size_class(base, size) when size in @sizes, do: "#{base}--#{size}"

  attr :class, :any, default: nil
  attr :size, :string, default: nil, values: [nil | @sizes], doc: "Font size step; nil inherits."

  attr :label, :string,
    default: nil,
    doc: "Set only when the icon conveys meaning on its own; it becomes role=img + aria-label."

  attr :rest, :global
  slot :inner_block, required: true

  def bt_icon(assigns) do
    ~H"""
    <span
      class={["bt-icon", size_class("bt-icon", @size), @class]}
      aria-hidden={if(@label, do: nil, else: "true")}
      role={@label && "img"}
      aria-label={@label}
      {@rest}
    >{render_slot(@inner_block)}</span>
    """
  end

  attr :class, :any, default: nil
  attr :variant, :string, default: "default", values: ~w(default primary)
  attr :size, :string, default: "md", values: @sizes
  attr :label, :string, required: true, doc: "Accessible name (also shown as tooltip via title)."
  attr :icon, :string, default: nil
  attr :rest, :global, include: ~w(disabled type form name value)
  slot :inner_block, required: false

  def bt_icon_button(assigns) do
    variant_class =
      if assigns.variant == "primary",
        do: "bt-icon-button bt-icon-button--primary",
        else: "bt-icon-button"

    assigns =
      assign(assigns, :class, [variant_class, size_class("bt-icon-button", assigns.size), assigns.class])

    ~H"""
    <button type="button" class={@class} aria-label={@label} title={@label} {@rest}>
      <span :if={@icon} class="bt-icon" aria-hidden="true">{@icon}</span>
      {render_slot(@inner_block)}
    </button>
    """
  end

  attr :class, :any, default: nil
  attr :extended, :boolean, default: false
  attr :label, :string, required: true
  attr :rest, :global, include: ~w(disabled type form name value)
  slot :inner_block, required: true

  def bt_fab(assigns) do
    ~H"""
    <button
      type="button"
      class={["bt-fab", @extended && "bt-fab--extended", @class]}
      aria-label={if(@extended, do: nil, else: @label)}
      {@rest}
    >
      {render_slot(@inner_block)}
    </button>
    """
  end

  attr :class, :any, default: nil
  attr :variant, :string, default: "default", values: ~w(default elevated filled primary third half)
  attr :span, :string, default: nil

  attr :title_tag, :string,
    default: "h3",
    values: ~w(h2 h3 h4 h5 h6 p),
    doc: "Heading level for the title, so cards fit the page outline."

  attr :rest, :global
  slot :inner_block
  slot :title
  slot :actions

  def bt_card(assigns) do
    variant_class =
      case assigns.variant do
        "elevated" -> "bt-card bt-card--elevated"
        "filled" -> "bt-card bt-card--filled"
        "primary" -> "bt-card bt-card--primary"
        "third" -> "bt-card bt-card--third"
        "half" -> "bt-card bt-card--half"
        _ -> "bt-card"
      end

    assigns = assign(assigns, :class, [variant_class, assigns.class])

    ~H"""
    <article class={@class} {@rest}>
      <div :if={@span} class="bt-card__media" aria-hidden="true"></div>
      <.dynamic_tag :if={@title != []} tag_name={@title_tag} class="bt-card__title">
        {render_slot(@title)}
      </.dynamic_tag>
      <div :if={@inner_block != []}>{render_slot(@inner_block)}</div>
      <div :if={@actions != []} class="bt-card__actions">{render_slot(@actions)}</div>
    </article>
    """
  end

  attr :class, :any, default: nil

  attr :variant, :string,
    default: "default",
    values: ~w(default dot inline inline-success success warning primary secondary)

  attr :size, :string, default: "md", values: ~w(sm md lg)

  attr :label, :string,
    default: nil,
    doc: "Screen-reader text. Required for `dot` badges and bare counts (\"3\" → \"3 unread\")."

  attr :rest, :global
  slot :inner_block

  def bt_badge(assigns) do
    variant_class =
      case assigns.variant do
        "dot" -> "bt-badge bt-badge--dot"
        "inline" -> "bt-badge bt-badge--inline"
        "inline-success" -> "bt-badge bt-badge--inline bt-badge--success"
        "success" -> "bt-badge bt-badge--success"
        "warning" -> "bt-badge bt-badge--warning"
        "primary" -> "bt-badge bt-badge--primary"
        "secondary" -> "bt-badge bt-badge--secondary"
        _ -> "bt-badge"
      end

    assigns =
      assign(assigns, :class, [variant_class, size_class("bt-badge", assigns.size), assigns.class])

    ~H"""
    <span class={@class} {@rest}>
      <span aria-hidden={@label && "true"}>{render_slot(@inner_block)}</span><span
        :if={@label}
        class="bt-sr-only"
      >{@label}</span>
    </span>
    """
  end

  attr :class, :any, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def bt_badge_wrap(assigns) do
    ~H"""
    <span class={["bt-badge-wrap", @class]} {@rest}>{render_slot(@inner_block)}</span>
    """
  end

  attr :class, :any, default: nil
  attr :variant, :string, default: "default", values: ~w(default selected outline)
  attr :size, :string, default: "md", values: ~w(sm md lg)
  attr :tag, :string, default: "span", values: ~w(span button)
  attr :rest, :global, include: ~w(disabled type name value)
  slot :inner_block, required: true

  def bt_chip(assigns) do
    variant_class =
      case assigns.variant do
        "selected" -> "bt-chip bt-chip--selected"
        "outline" -> "bt-chip bt-chip--outline"
        _ -> "bt-chip"
      end

    assigns =
      assign(assigns, :class, [variant_class, size_class("bt-chip", assigns.size), assigns.class])

    # A button chip is a toggle: expose its selected state (not only its color).
    ~H"""
    <button
      :if={@tag == "button"}
      type="button"
      class={@class}
      aria-pressed={to_string(@variant == "selected")}
      {@rest}
    >
      {render_slot(@inner_block)}
    </button>
    <span :if={@tag == "span"} class={@class} {@rest}>{render_slot(@inner_block)}</span>
    """
  end

  attr :class, :any, default: nil
  attr :variant, :string, default: "default", values: ~w(default success warning error info)
  slot :inner_block, required: true

  def bt_status(assigns) do
    variant_class =
      case assigns.variant do
        "success" -> "bt-status bt-status--success"
        "warning" -> "bt-status bt-status--warning"
        "error" -> "bt-status bt-status--error"
        "info" -> "bt-status bt-status--info"
        _ -> "bt-status"
      end

    assigns = assign(assigns, :class, [variant_class, assigns.class])

    ~H"""
    <span class={@class}>{render_slot(@inner_block)}</span>
    """
  end

  attr :class, :any, default: nil
  attr :variant, :string, default: "default", values: ~w(default primary)
  slot :inner_block, required: true
  slot :actions

  def bt_appbar(assigns) do
    variant_class =
      if assigns.variant == "primary", do: "bt-appbar bt-appbar--primary", else: "bt-appbar"

    assigns = assign(assigns, :class, [variant_class, assigns.class])

    ~H"""
    <header class={@class}>
      {render_slot(@inner_block)}
      <div :if={@actions != []} class="bt-row">{render_slot(@actions)}</div>
    </header>
    """
  end

  def bt_spacer(assigns) do
    ~H"""
    <span class="bt-spacer"></span>
    """
  end

  attr :label, :string, default: nil
  attr :rest, :global
  slot :item, required: true do
    attr :href, :string
    attr :current, :boolean
    attr :icon, :string, required: true
    attr :label, :string, required: true
  end

  def bt_bottom_nav(assigns) do
    assigns = assign_new(assigns, :label, fn -> gettext("Bottom navigation") end)

    ~H"""
    <nav class="bt-bottom-nav" aria-label={@label} {@rest}>
      <a
        :for={item <- @item}
        href={item[:href] || "#"}
        aria-current={if(Map.get(item, :current, false), do: "page", else: false)}
      >
        <span class="bt-icon" aria-hidden="true">{item.icon}</span>
        <span>{item.label}</span>
      </a>
    </nav>
    """
  end

  attr :id, :string, default: nil
  attr :name, :string, required: true
  attr :label, :string, required: true
  attr :hide_label, :boolean, default: false, doc: "Keep the label for screen readers only."
  attr :checked, :boolean, default: false
  attr :disabled, :boolean, default: false
  attr :size, :string, default: "md", values: ~w(sm md lg)
  attr :class, :any, default: nil
  attr :rest, :global

  def bt_switch(assigns) do
    ~H"""
    <label class={["bt-switch", size_class("bt-switch", @size), @class]}>
      <input
        type="checkbox"
        role="switch"
        id={@id}
        name={@name}
        checked={@checked}
        disabled={@disabled}
        {@rest}
      />
      <span class="bt-switch__track" aria-hidden="true"></span>
      <span class={@hide_label && "bt-sr-only"}>{@label}</span>
    </label>
    """
  end

  attr :id, :string, default: nil
  attr :name, :string, required: true
  attr :label, :string, required: true
  attr :checked, :boolean, default: false
  attr :disabled, :boolean, default: false
  attr :class, :any, default: nil
  attr :rest, :global

  def bt_radio(assigns) do
    ~H"""
    <label class={["bt-radio", @class]}>
      <input
        type="radio"
        id={@id}
        name={@name}
        checked={@checked}
        disabled={@disabled}
        {@rest}
      />
      <span>{@label}</span>
    </label>
    """
  end

  @doc """
  Groups radios (or checkboxes) with a `<fieldset>`/`<legend>` so the group
  name is announced (WCAG 1.3.1).
  """
  attr :legend, :string, required: true
  attr :hide_legend, :boolean, default: false
  attr :class, :any, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def bt_fieldset(assigns) do
    ~H"""
    <fieldset class={["bt-fieldset", @class]} {@rest}>
      <legend class={["bt-fieldset__legend", @hide_legend && "bt-sr-only"]}>{@legend}</legend>
      {render_slot(@inner_block)}
    </fieldset>
    """
  end

  attr :id, :string, required: true, doc: "Needed to associate the label and help text."
  attr :name, :string, default: nil
  attr :label, :string, required: true
  attr :hide_label, :boolean, default: false
  attr :value, :integer, default: 50
  attr :min, :integer, default: 0
  attr :max, :integer, default: 100
  attr :step, :integer, default: 1
  attr :help, :string, default: nil
  attr :class, :any, default: nil
  attr :rest, :global

  def bt_slider(assigns) do
    ~H"""
    <div class={["bt-field", @class]}>
      <label for={@id} class={@hide_label && "bt-sr-only"}>{@label}</label>
      <input
        type="range"
        id={@id}
        name={@name}
        class="bt-slider"
        min={@min}
        max={@max}
        step={@step}
        value={@value}
        aria-describedby={@help && "#{@id}-help"}
        {@rest}
      />
      <small :if={@help} id={"#{@id}-help"} class="bt-help">{@help}</small>
    </div>
    """
  end

  attr :id, :string, required: true
  attr :title, :string, default: nil

  attr :label, :string,
    default: nil,
    doc: "Accessible name when there is no visible `title`."

  attr :role, :string, default: "dialog", values: ~w(dialog alertdialog)
  attr :open, :boolean, default: false
  attr :class, :any, default: nil
  attr :rest, :global
  slot :inner_block, required: true
  slot :actions

  def bt_dialog(assigns) do
    ~H"""
    <div
      class={["bt-dialog", @class]}
      id={@id}
      role={@role}
      aria-modal="true"
      aria-labelledby={@title && "#{@id}-title"}
      aria-label={!@title && @label}
      data-focus-trap
      open={@open}
      {@rest}
    >
      <div class="bt-dialog__surface">
        <h2 :if={@title} id={"#{@id}-title"} class="bt-dialog__title">{@title}</h2>
        {render_slot(@inner_block)}
        <div :if={@actions != []} class="bt-dialog__actions">{render_slot(@actions)}</div>
      </div>
    </div>
    """
  end

  attr :id, :string, required: true
  attr :label, :string, required: true, doc: "Accessible name of the overlay."
  attr :open, :boolean, default: false
  attr :class, :any, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def bt_overlay(assigns) do
    ~H"""
    <div
      class={["bt-overlay", @class]}
      id={@id}
      role="dialog"
      aria-modal="true"
      aria-label={@label}
      data-focus-trap
      open={@open}
      {@rest}
    >
      <div class="bt-overlay__surface">{render_slot(@inner_block)}</div>
    </div>
    """
  end

  @doc """
  Menu button (APG "menu button" pattern). Keyboard: Enter/Space/↓ open and
  focus the first item, ↑/↓/Home/End move, Escape closes and returns focus,
  Tab closes. Wired by `initBtInteractions()`.
  """
  attr :id, :string, required: true
  attr :toggle_label, :string, default: nil
  attr :class, :any, default: nil
  attr :rest, :global

  slot :item, required: true do
    attr :label, :string, required: true
    attr :icon, :string
  end

  def bt_menu_wrap(assigns) do
    assigns = assign_new(assigns, :toggle_label, fn -> gettext("Open menu") end)

    ~H"""
    <div class={["bt-menu-wrap", @class]} {@rest}>
      <button
        type="button"
        id={"#{@id}-toggle"}
        class="bt-button bt-button--secondary"
        data-menu-toggle={@id}
        aria-haspopup="menu"
        aria-expanded="false"
        aria-controls={@id}
      >
        {@toggle_label}
        <span class="bt-icon" aria-hidden="true">expand_more</span>
      </button>
      <div class="bt-menu" id={@id} role="menu" aria-labelledby={"#{@id}-toggle"}>
        <button :for={item <- @item} type="button" role="menuitem" tabindex="-1">
          <span :if={item[:icon]} class="bt-icon" aria-hidden="true">{item.icon}</span>
          {item.label}
        </button>
      </div>
    </div>
    """
  end

  @doc """
  Tabs (APG "tabs" pattern, automatic activation). Only the selected tab is in
  the Tab sequence; ←/→/Home/End move between tabs. Wired by `initBtInteractions()`.
  """
  attr :id, :string, required: true
  attr :label, :string, default: nil, doc: "Accessible name of the tab list."
  attr :class, :any, default: nil
  attr :rest, :global

  slot :tab, required: true do
    attr :id, :string, required: true
    attr :label, :string, required: true
    attr :selected, :boolean
  end

  slot :panel, required: true do
    attr :id, :string, required: true
    attr :tab_id, :string, required: true
  end

  def bt_tabs(assigns) do
    assigns = assign(assigns, :tab_panels, Map.new(assigns.panel, &{&1.tab_id, &1.id}))

    ~H"""
    <div data-tabs id={@id} class={@class} {@rest}>
      <div class="bt-tabs" role="tablist" aria-label={@label}>
        <button
          :for={tab <- @tab}
          type="button"
          class="bt-tab"
          role="tab"
          id={tab.id}
          data-tab={@tab_panels[tab.id]}
          aria-selected={to_string(Map.get(tab, :selected, false))}
          aria-controls={@tab_panels[tab.id]}
          tabindex={if(Map.get(tab, :selected, false), do: "0", else: "-1")}
        >
          {tab.label}
        </button>
      </div>
      <div
        :for={panel <- @panel}
        class="bt-tab-panel"
        id={panel.id}
        role="tabpanel"
        tabindex="0"
        aria-labelledby={panel.tab_id}
        aria-hidden={to_string(!panel_selected?(@tab, panel.tab_id))}
      >
        {render_slot(panel)}
      </div>
    </div>
    """
  end

  defp panel_selected?(tabs, tab_id) do
    Enum.any?(tabs, &( &1.id == tab_id && Map.get(&1, :selected, false)))
  end

  @doc "Disclosure (APG pattern): `aria-expanded` and `aria-controls` on the button."
  attr :id, :string, default: nil
  attr :title, :string, required: true
  attr :open, :boolean, default: false
  attr :class, :any, default: nil
  attr :rest, :global
  slot :inner_block

  def bt_expansion(assigns) do
    assigns =
      assign_new(assigns, :content_id, fn ->
        "#{assigns.id || "bt-expansion-#{:erlang.phash2(assigns.title)}"}-content"
      end)

    ~H"""
    <div class={["bt-expansion", @class]} id={@id} data-expansion data-open={to_string(@open)} {@rest}>
      <button
        class="bt-expansion__button"
        type="button"
        data-expansion-toggle
        aria-expanded={to_string(@open)}
        aria-controls={@content_id}
      >
        <span>{@title}</span>
        <span class="bt-expansion__icon bt-symbol" aria-hidden="true">expand_more</span>
      </button>
      <%!-- inner/body wrappers let the height animate (motion.css) --%>
      <div class="bt-expansion__content" id={@content_id}>
        <div class="bt-expansion__inner">
          <div class="bt-expansion__body">{render_slot(@inner_block)}</div>
        </div>
      </div>
    </div>
    """
  end

  attr :id, :string, required: true
  attr :open, :boolean, default: false

  attr :urgent, :boolean,
    default: false,
    doc: "Errors that need immediate attention use role=alert instead of status."

  attr :class, :any, default: nil
  attr :rest, :global
  slot :inner_block, required: true
  slot :actions

  def bt_snackbar(assigns) do
    ~H"""
    <div
      class={["bt-snackbar", @class]}
      id={@id}
      data-open={to_string(@open)}
      role={if(@urgent, do: "alert", else: "status")}
      aria-atomic="true"
      {@rest}
    >
      {render_slot(@inner_block)}
      <div :if={@actions != []}>{render_slot(@actions)}</div>
    </div>
    """
  end

  attr :value, :integer, default: 0
  attr :max, :integer, default: 100
  attr :label, :string, default: nil
  attr :value_text, :string, default: nil, doc: "Spoken value, e.g. \"3 of 5 steps\"."
  attr :size, :string, default: "md", values: ~w(sm md lg)
  attr :class, :any, default: nil
  attr :rest, :global

  def bt_progress(assigns) do
    assigns =
      assigns
      |> assign_new(:progress_aria_label, fn -> gettext("Progress") end)
      |> assign(:percent, progress_percent(assigns.value, assigns.max))

    ~H"""
    <div
      class={["bt-progress", size_class("bt-progress", @size), @class]}
      role="progressbar"
      aria-label={@label || @progress_aria_label}
      aria-valuemin="0"
      aria-valuemax={@max}
      aria-valuenow={@value}
      aria-valuetext={@value_text}
      {@rest}
    >
      <div class="bt-progress__bar" style={"--value: #{@percent}%"}></div>
    </div>
    """
  end

  attr :value, :integer, default: 0
  attr :max, :integer, default: 100
  attr :label, :string, default: nil, doc: "Text shown in the center (defaults to the percentage)."
  attr :aria_label, :string, default: nil
  attr :class, :any, default: nil
  attr :rest, :global

  def bt_progress_circle(assigns) do
    assigns =
      assigns
      |> assign(:percent, progress_percent(assigns.value, assigns.max))
      |> assign_new(:progress_aria_label, fn -> gettext("Progress") end)

    ~H"""
    <div
      class={["bt-progress-circle", @class]}
      style={"--value: #{@percent}%"}
      data-label={@label || "#{@percent}%"}
      role="progressbar"
      aria-label={@aria_label || @progress_aria_label}
      aria-valuemin="0"
      aria-valuemax={@max}
      aria-valuenow={@value}
      aria-valuetext={@label}
      {@rest}
    >
    </div>
    """
  end

  defp progress_percent(_value, total) when total <= 0, do: 0
  defp progress_percent(value, total), do: (value * 100) |> div(total) |> min(100) |> max(0)

  @doc """
  Tooltip shown on hover and keyboard focus. The text is linked to the trigger
  with `aria-describedby`, so screen readers read it too. Escape hides it
  (WCAG 1.4.13). Keep it short; never put essential information only here.
  """
  attr :id, :string, default: nil, doc: "Defaults to a stable id derived from the text."
  attr :text, :string, required: true
  attr :class, :any, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def bt_tooltip(assigns) do
    assigns = assign(assigns, :id, assigns.id || "bt-tooltip-#{:erlang.phash2(assigns.text)}")

    ~H"""
    <span
      class={["bt-tooltip", @class]}
      data-tooltip={@text}
      data-tooltip-describes={"#{@id}-text"}
      {@rest}
    >
      {render_slot(@inner_block)}
      <span id={"#{@id}-text"} class="bt-sr-only" role="tooltip">{@text}</span>
    </span>
    """
  end

  attr :class, :any, default: nil
  attr :href, :string, default: "#"
  attr :navigate, :any, default: nil
  attr :patch, :any, default: nil
  attr :current, :boolean, default: false
  attr :icon, :string, default: nil
  slot :inner_block, required: true

  def bt_nav_link(assigns) do
    assigns =
      assign(
        assigns,
        :nav_link_class,
        ["bt-nav-link", assigns.current && "bt-nav-link--current", assigns.class]
      )

    if assigns.navigate do
      ~H"""
      <.link navigate={@navigate} class={@nav_link_class} aria-current={@current && "page"}>
        <span :if={@icon} class="bt-icon" aria-hidden="true">{@icon}</span>
        {render_slot(@inner_block)}
      </.link>
      """
    else
      if assigns.patch do
        ~H"""
        <.link patch={@patch} class={@nav_link_class} aria-current={@current && "page"}>
          <span :if={@icon} class="bt-icon" aria-hidden="true">{@icon}</span>
          {render_slot(@inner_block)}
        </.link>
        """
      else
        ~H"""
        <a href={@href} class={@nav_link_class} aria-current={if(@current, do: "page", else: false)}>
          <span :if={@icon} class="bt-icon" aria-hidden="true">{@icon}</span>
          {render_slot(@inner_block)}
        </a>
        """
      end
    end
  end

  attr :variant, :string, default: "default", values: ~w(default compact)
  attr :tag, :string, default: "div", values: ~w(div section main article aside)
  attr :class, :any, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  # Defaults to <div>: a bare <section> without a name is not a landmark and
  # only adds noise to the outline.
  def bt_container(assigns) do
    ~H"""
    <.dynamic_tag
      tag_name={@tag}
      class={["bt-container", @variant == "compact" && "bt-container--compact", @class]}
      {@rest}
    >
      {render_slot(@inner_block)}
    </.dynamic_tag>
    """
  end

  attr :id, :string, default: nil
  attr :title, :string, required: true
  attr :title_tag, :string, default: "h2", values: ~w(h2 h3 h4)
  attr :description, :string, default: nil
  attr :class, :any, default: nil
  attr :rest, :global
  slot :actions
  slot :inner_block

  def bt_section(assigns) do
    assigns = assign(assigns, :heading_id, assigns.id && "#{assigns.id}-title")

    ~H"""
    <section id={@id} class={["bt-section", @class]} aria-labelledby={@heading_id} {@rest}>
      <div class="bt-section__header">
        <.dynamic_tag tag_name={@title_tag} id={@heading_id} class="bt-section__title">
          {@title}
        </.dynamic_tag>
        <div :if={@actions != []}>{render_slot(@actions)}</div>
      </div>
      <p :if={@description} class="bt-section__description">{@description}</p>
      <div :if={@inner_block != []}>{render_slot(@inner_block)}</div>
    </section>
    """
  end

  attr :vertical, :boolean, default: false
  attr :class, :any, default: nil

  def bt_divider(assigns) do
    assigns =
      assign(
        assigns,
        :divider_class,
        if(assigns.vertical,
          do: ["bt-divider bt-divider--vertical", assigns.class],
          else: ["bt-divider", assigns.class]
        )
      )

    ~H"""
    <span class={@divider_class} aria-hidden="true"></span>
    """
  end

  attr :label, :string, default: nil
  attr :class, :any, default: nil
  attr :rest, :global

  slot :item, required: true do
    attr :label, :string, required: true
    attr :pressed, :boolean
  end

  def bt_segmented(assigns) do
    assigns = assign_new(assigns, :label, fn -> gettext("Segmented control") end)

    ~H"""
    <div class={["bt-segmented", @class]} role="group" aria-label={@label} {@rest}>
      <button
        :for={item <- @item}
        type="button"
        aria-pressed={to_string(Map.get(item, :pressed, false))}
      >
        {item.label}
      </button>
    </div>
    """
  end

  attr :label, :string, required: true
  attr :swatch, :string, required: true
  attr :class, :any, default: nil
  attr :rest, :global

  def bt_color_swatch(assigns) do
    ~H"""
    <div class={["bt-color-swatch", @class]} {@rest}>
      <div class="bt-color-swatch__color" style={"--swatch: #{@swatch}"}></div>
      <div class="bt-color-swatch__text">{@label}</div>
    </div>
    """
  end

  attr :family, :string, required: true, doc: "Color family id, e.g. `bluetab-blue`."
  attr :show_contrast, :boolean,
    default: true,
    doc: "Show the WCAG contrast ratio of the label color on each swatch."

  attr :class, :any, default: nil
  attr :rest, :global

  def bt_color_scale(assigns) do
    assigns = assign(assigns, :color_family, Bds.Catalog.color_family!(assigns.family))

    # The wrapper is a size container: the scale picks 2, 5 or 10 columns from
    # the space it actually has, not from the viewport width.
    ~H"""
    <div class={["bt-color-scale-wrap", @class]} {@rest}>
    <div class="bt-color-scale" role="list" aria-label={@color_family["name"]}>
      <div
        :for={step <- @color_family["steps"]}
        class={[
          "bt-color-scale__step",
          "bt-color-scale__step--on-#{step["tone"]}",
          step["master"] && "bt-color-scale__step--master"
        ]}
        role="listitem"
        style={"--swatch: var(#{step["token"]})"}
      >
        <span class="bt-color-scale__head">
          <span class="bt-color-scale__level">{step["level"]}</span>
          <span :if={step["master"]} class="bt-color-scale__badge">{gettext("Master")}</span>
        </span>
        <span class="bt-color-scale__data">
          <b>{step["hex"]}</b>RGB {step["rgb"]}<br />CMYK {step["cmyk"]}<br />{step["spot"]}
        </span>
        <span :if={@show_contrast} class="bt-color-scale__contrast">
          {swatch_contrast_label(step)}
        </span>
      </div>
    </div>
    </div>
    """
  end

  # Label text colors used by .bt-color-scale__step--on-{tone} (forms.css)
  @swatch_text %{"dark" => "#1f222d", "light" => "#ffffff"}

  defp swatch_contrast_label(%{"hex" => hex, "tone" => tone}) do
    ratio = Bds.Contrast.ratio(Map.get(@swatch_text, tone, "#1f222d"), hex)

    level =
      cond do
        Bds.Contrast.passes?(ratio, :text, :aaa) -> "AAA"
        Bds.Contrast.passes?(ratio, :text, :aa) -> "AA"
        Bds.Contrast.passes?(ratio, :large_text, :aa) -> gettext("AA large")
        true -> gettext("Fails")
      end

    "#{Bds.Contrast.format_ratio(ratio)} · #{level}"
  end

  attr :class, :any, default: nil
  attr :name, :string, required: true
  attr :email, :string, default: nil
  attr :src, :string, default: nil
  attr :initials, :string, default: nil
  attr :compactness, :string, default: "compact", values: ~w(compact expanded)
  attr :size, :string, default: "md", values: ~w(sm md lg)
  attr :badges, :list, default: []
  attr :rest, :global

  def bt_avatar(assigns) do
    initials = assigns.initials || avatar_initials(assigns.name)

    assigns =
      assigns
      |> assign(:initials, initials)
      |> assign(:compactness_class, "bt-avatar--#{assigns.compactness}")
      |> assign(:show_name_badges?, assigns.badges != [])

    # The name is always rendered as text next to the picture, so the picture
    # is decorative (alt="") and must not repeat it to screen readers.
    ~H"""
    <div class={["bt-avatar", @compactness_class, size_class("bt-avatar", @size), @class]} {@rest}>
      <div class="bt-avatar__media" aria-hidden="true">
        <img :if={@src} src={@src} alt="" class="bt-avatar__image" />
        <span :if={is_nil(@src)}>{@initials}</span>
      </div>
      <div class="bt-avatar__text">
        <%= if @show_name_badges? do %>
          <div class="bt-avatar__name-row">
            <p class="bt-avatar__name">{@name}</p>
            <span class="bt-avatar__badges">
              <.bt_badge
                :for={badge <- @badges}
                variant={Map.get(badge, :variant, "secondary")}
              >
                {badge.label}
              </.bt_badge>
            </span>
          </div>
        <% else %>
          <p class="bt-avatar__name">{@name}</p>
        <% end %>
        <p :if={@email} class="bt-avatar__email">{@email}</p>
      </div>
    </div>
    """
  end

  attr :initials, :string, required: true
  attr :title, :string, required: true
  attr :subtitle, :string, default: nil
  attr :class, :any, default: nil
  attr :rest, :global
  slot :actions, doc: "Trailing controls (e.g. an icon button)."

  def bt_list_item(assigns) do
    ~H"""
    <li class={["bt-list-item", @class]} {@rest}>
      <div class="bt-list-item__avatar" aria-hidden="true">{@initials}</div>
      <div class="bt-list-item__content">
        <p class="bt-list-item__title">{@title}</p>
        <p :if={@subtitle} class="bt-list-item__subtitle">{@subtitle}</p>
      </div>
      <div :if={@actions != []} class="bt-list-item__actions">{render_slot(@actions)}</div>
    </li>
    """
  end

  # Real list semantics so screen readers announce "list, N items".
  attr :label, :string, default: nil
  attr :class, :any, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def bt_list_group(assigns) do
    ~H"""
    <ul class={["bt-list", @class]} role="list" aria-label={@label} {@rest}>
      {render_slot(@inner_block)}
    </ul>
    """
  end

  attr :class, :any, default: nil
  slot :inner_block, required: true

  def bt_hero(assigns) do
    ~H"""
    <section class={["bt-hero", @class]}>{render_slot(@inner_block)}</section>
    """
  end

  attr :class, :any, default: nil
  slot :inner_block, required: true

  def bt_eyebrow(assigns) do
    ~H"""
    <p class={["bt-eyebrow", @class]}>{render_slot(@inner_block)}</p>
    """
  end

  attr :class, :any, default: nil
  slot :inner_block, required: true

  def bt_lead(assigns) do
    ~H"""
    <p class={["bt-lead", @class]}>{render_slot(@inner_block)}</p>
    """
  end

  attr :class, :any, default: nil
  slot :inner_block, required: true

  def bt_muted(assigns) do
    ~H"""
    <p class={["bt-muted", @class]}>{render_slot(@inner_block)}</p>
    """
  end

  attr :columns, :integer, default: 3
  slot :inner_block, required: true

  def bt_example_grid(assigns) do
    ~H"""
    <div class="bt-example-grid">{render_slot(@inner_block)}</div>
    """
  end

  attr :title, :string, required: true
  attr :block, :boolean, default: false
  slot :inner_block, required: true

  def bt_example(assigns) do
    assigns =
      assigns
      |> assign(
        :example_class,
        if(assigns.block, do: "bt-example", else: "bt-example bt-example--half")
      )
      |> assign(
        :preview_class,
        if(assigns.block, do: "bt-example__preview--block", else: nil)
      )

    ~H"""
    <article class={@example_class}>
      <header class="bt-example__header">
        <h3 class="bt-example__title">{@title}</h3>
      </header>
      <div class={["bt-example__preview", @preview_class]}>{render_slot(@inner_block)}</div>
    </article>
    """
  end

  def bt_button_variant_class(variant), do: Map.get(@button_variants, variant, "bt-button")

  attr :id, :string, default: nil
  attr :nodes, :list, required: true
  attr :expanded, :any, required: true
  attr :toggle_event, :string, default: "toggle_tree"
  attr :toggle_target, :any, default: nil
  attr :select_event, :string, default: nil
  attr :select_target, :any, default: nil
  attr :depth, :integer, default: 0
  attr :class, :any, default: nil

  # Rendered as nested lists of disclosure buttons rather than role=tree: rows
  # contain their own buttons and links, which the ARIA tree pattern does not
  # allow. Arrow-key navigation between rows is added by initBtInteractions().
  def bt_tree(assigns) do
    ~H"""
    <ul
      class={["bt-tree", @depth > 0 && "bt-tree--nested", @class]}
      id={@id}
      role="list"
      data-bt-tree={@depth == 0 || nil}
    >
      <.bt_tree_node
        :for={node <- @nodes}
        node={node}
        expanded={@expanded}
        toggle_event={@toggle_event}
        toggle_target={@toggle_target}
        select_event={@select_event}
        select_target={@select_target}
        depth={@depth}
      />
    </ul>
    """
  end

  attr :node, :map, required: true
  attr :expanded, :any, required: true
  attr :toggle_event, :string, required: true
  attr :toggle_target, :any, default: nil
  attr :select_event, :string, default: nil
  attr :select_target, :any, default: nil
  attr :depth, :integer, required: true

  def bt_tree_node(assigns) do
    node = assigns.node
    key = tree_node_key(node)
    children = Map.get(node, :children, [])
    has_children? = children != []
    open? = has_children? and MapSet.member?(assigns.expanded, key)
    section? = Map.get(node, :section, false) or Map.get(node, :kind) == :section
    selectable? = Map.get(node, :selectable, false) and not is_nil(assigns[:select_event])
    href = Map.get(node, :href)
    linkable? = is_binary(href) and href != "" and not selectable?

    assigns =
      assigns
      |> assign(:key, key)
      |> assign(:children, children)
      |> assign(:has_children?, has_children?)
      |> assign(:open?, open?)
      |> assign(:section?, section?)
      |> assign(:selectable?, selectable?)
      |> assign(:linkable?, linkable?)
      |> assign(:href, href)
      |> assign(:depth, assigns.depth)
      |> assign(:item_class, tree_item_class(node))
      |> assign(:label_row_class, tree_label_row_class(node, selectable? or linkable?))
      |> assign(:group_id, "bt-tree-group-#{:erlang.phash2(key)}")

    ~H"""
    <li
      class={@item_class}
      data-role={@node[:role]}
      data-tree-key={@key}
      style={"--bt-tree-depth: #{@depth}"}
    >
      <div class="bt-tree__row">
        <div class="bt-tree__toggle-col">
          <button
            :if={@has_children?}
            type="button"
            class="bt-tree__toggle"
            phx-click={@toggle_event}
            phx-target={@toggle_target}
            phx-value-key={@key}
            aria-expanded={to_string(@open?)}
            aria-controls={@open? && @group_id}
            aria-label={gettext("Expand or collapse %{name}", name: @node.name)}
            data-tree-toggle
          >
            <span class={["bt-tree__chevron bt-symbol", @open? && "bt-tree__chevron--open"]} aria-hidden="true">chevron_right</span>
          </button>
          <span :if={not @has_children?} class="bt-tree__toggle-spacer" aria-hidden="true" />
        </div>
        <div class="bt-tree__body">
          <p :if={@section?} class="bt-tree__section-title">{@node.name}</p>
          <button
            :if={not @section? and @selectable?}
            type="button"
            class={@label_row_class}
            phx-click={@select_event}
            phx-target={@select_target}
            phx-value-project_id={@node[:project_id]}
          >
            <.bt_tree_label_content node={@node} />
          </button>
          <.link
            :if={not @section? and not @selectable? and @linkable?}
            navigate={@href}
            class={@label_row_class}
          >
            <.bt_tree_label_content node={@node} />
          </.link>
          <div
            :if={not @section? and not @selectable? and not @linkable? and not @has_children?}
            class={@label_row_class}
          >
            <.bt_tree_label_content node={@node} />
          </div>
          <div
            :if={not @section? and not @selectable? and not @linkable? and @has_children?}
            class={[@label_row_class, "bt-tree__label-row--branch"]}
            phx-click={@toggle_event}
            phx-target={@toggle_target}
            phx-value-key={@key}
          >
            <.bt_tree_label_content node={@node} />
          </div>
        </div>
      </div>
      <.bt_tree
        :if={@has_children? and @open?}
        id={@group_id}
        nodes={@children}
        expanded={@expanded}
        toggle_event={@toggle_event}
        toggle_target={@toggle_target}
        select_event={@select_event}
        select_target={@select_target}
        depth={@depth + 1}
      />
    </li>
    """
  end

  attr :node, :map, required: true

  defp bt_tree_label_content(assigns) do
    avatar = assigns.node[:avatar]

    assigns =
      assigns
      |> assign(:avatar, avatar)
      |> assign(
        :avatar_initials,
        if(avatar, do: Map.get(avatar, :initials) || avatar_initials(avatar.name), else: nil)
      )
      |> assign(:avatar_src, avatar && Map.get(avatar, :src))
      |> assign(:name_badges, (assigns.node[:badges] || []) ++ [])
      |> assign(:trailing_badges, assigns.node[:trailing_badges] || [])
      |> assign(:secondary_label, assigns.node[:secondary_label])

    ~H"""
    <div :if={@avatar} class="bt-tree__person">
      <div class="bt-avatar bt-avatar--compact bt-tree__person-avatar">
        <div class="bt-avatar__media" aria-hidden={is_nil(@avatar_src)}>
          <img :if={@avatar_src} src={@avatar_src} alt={@avatar.name} class="bt-avatar__image" />
          <span :if={is_nil(@avatar_src)}>{@avatar_initials}</span>
        </div>
      </div>
      <div class="bt-tree__person-text">
        <div class="bt-tree__person-name-row">
          <p class="bt-avatar__name">{@avatar.name}</p>
          <span :if={@name_badges != []} class="bt-tree__badges">
            <.bt_badge
              :for={badge <- @name_badges}
              variant={Map.get(badge, :variant, "secondary")}
            >
              {badge.label}
            </.bt_badge>
          </span>
        </div>
        <span
          :if={is_binary(@secondary_label) and @secondary_label != ""}
          class="bt-tree__secondary"
        >
          {@secondary_label}
        </span>
      </div>
      <span :if={@trailing_badges != []} class="bt-tree__badges bt-tree__person-status">
        <.bt_badge
          :for={badge <- @trailing_badges}
          variant={Map.get(badge, :variant, "secondary")}
        >
          {badge.label}
        </.bt_badge>
      </span>
    </div>
    <.bt_badge
      :if={!@avatar && tree_project_doc_badge?(@node)}
      variant="inline"
      class="bt-tree__doc-badge"
    >
      {tree_project_doc_label(@node)}
    </.bt_badge>
    <span :if={!@avatar && @node[:kind_label]} class="bt-tree__kind">{@node.kind_label}</span>
    <span :if={!@avatar} class="bt-tree__name">{@node.name}</span>
    <span :if={!@avatar && @node[:doc_num] && !tree_project_doc_badge?(@node)} class="bt-tree__doc">
      P-{@node.doc_num}
    </span>
    <span :if={!@avatar && @node[:secondary_label]} class="bt-tree__secondary">
      {@node.secondary_label}
    </span>
    <span :if={!@avatar && (@node[:badges] || []) != []} class="bt-tree__badges">
      <.bt_badge
        :for={badge <- @node[:badges] || []}
        variant={Map.get(badge, :variant, "secondary")}
      >
        {badge.label}
      </.bt_badge>
    </span>
    <span
      :if={!@avatar && @node[:meta]}
      class={["bt-tree__meta", @node[:meta_self] && "bt-tree__meta--self"]}
    >
      · {@node.meta}
    </span>
    """
  end

  defp tree_project_doc_badge?(node) do
    Map.get(node, :show_doc_badge, false) or Map.get(node, :selectable, false)
  end

  defp tree_project_doc_label(node) do
    case Map.get(node, :doc_num) do
      num when not is_nil(num) -> "P-#{num}"
      _ -> "P-—"
    end
  end

  defp tree_item_class(node) do
    role = Map.get(node, :role)

    [
      "bt-tree__item",
      role == :ancestor && "bt-tree__item--ancestor",
      role == :self && "bt-tree__item--self",
      role == :descendant && "bt-tree__item--descendant"
    ]
  end

  defp tree_label_row_class(node, selectable?) do
    [
      "bt-tree__label-row",
      Map.get(node, :avatar) && "bt-tree__label-row--with-avatar",
      selectable? && "bt-tree__label-row--selectable"
    ]
  end

  defp tree_node_key(%{key: key}) when is_binary(key), do: key
  defp tree_node_key(%{id: id}), do: to_string(id)

  defp avatar_initials(name) when is_binary(name) do
    name
    |> String.trim()
    |> String.split(~r/\s+/, trim: true)
    |> case do
      [] ->
        "?"

      [single] ->
        single |> String.slice(0, 2) |> String.upcase()

      [first | rest] ->
        [first, List.last(rest)]
        |> Enum.map(fn part -> part |> String.first() |> to_string() end)
        |> Enum.join()
        |> String.upcase()
    end
  end

  defp avatar_initials(_), do: "?"

  attr :id, :string, default: nil
  attr :input_id, :string, default: nil
  attr :class, :any, default: nil
  attr :label, :string, default: nil
  attr :name, :string, required: true
  attr :value, :string, default: ""
  attr :placeholder, :string, default: nil
  attr :open, :boolean, default: false
  attr :loading, :boolean, default: false
  attr :show_clear, :boolean, default: false
  attr :errors, :list, default: []
  attr :target, :any, default: nil
  attr :clear_event, :string, default: "combobox_clear"
  attr :rest, :global, include: ~w(phx-change phx-debounce phx-focus phx-blur autocomplete disabled readonly)

  slot :panel_footer
  slot :options
  slot :empty
  slot :loading_content

  def bt_combobox(assigns) do
    wrapper_id = assigns.id
    input_id = assigns[:input_id] || (wrapper_id && "#{wrapper_id}-input") || "#{assigns.name}-input"
    wrapper_id = wrapper_id || "#{input_id}-combobox"

    assigns =
      assigns
      |> assign(:wrapper_id, wrapper_id)
      |> assign(:input_id, input_id)
      |> assign(:panel_id, "#{input_id}-panel")
      |> assign(:errors_id, "#{input_id}-errors")
      |> assign(:field_class, ["bt-field", assigns.errors != [] && "bt-field--error"])

    # APG "combobox with listbox popup". ↑/↓ move the active option
    # (aria-activedescendant), Enter picks it, Escape closes — see a11y.js.
    ~H"""
    <div
      class={["bt-combobox", @open && "bt-combobox--open", @class]}
      id={@wrapper_id}
      phx-hook="BtCombobox"
    >
      <div class={@field_class}>
        <label :if={@label} for={@input_id}>{@label}</label>
        <div class="bt-combobox__input-wrap">
          <input
            type="text"
            id={@input_id}
            name={@name}
            value={@value}
            class="bt-input"
            placeholder={@placeholder}
            role="combobox"
            aria-autocomplete="list"
            aria-expanded={to_string(@open)}
            aria-controls={@panel_id}
            aria-busy={to_string(@loading)}
            aria-invalid={@errors != [] && "true"}
            aria-describedby={@errors != [] && @errors_id}
            autocomplete="off"
            data-combobox-input
            phx-target={@target}
            {@rest}
          />
          <div class="bt-combobox__trailing">
            <span :if={@loading} class="bt-combobox__spinner" aria-hidden="true" />
            <button
              :if={@show_clear and not @loading}
              type="button"
              class="bt-combobox__clear"
              aria-label={gettext("Clear")}
              phx-target={@target}
              phx-click={@clear_event}
            >
              <span class="bt-symbol" aria-hidden="true">close</span>
            </button>
          </div>
        </div>
        <p :if={@errors != []} id={@errors_id} class="bt-field__error">
          <span class="bt-icon" aria-hidden="true">error</span>
          {Enum.join(@errors, " ")}
        </p>
      </div>
      <div
        :if={@open}
        id={@panel_id}
        class="bt-combobox__panel"
        role="listbox"
        aria-label={@label}
      >
        <div :if={@panel_footer != []} class="bt-combobox__footer">
          {render_slot(@panel_footer)}
        </div>
        <div :if={@loading} class="bt-combobox__status" role="status">
          <%= if @loading_content != [] do %>
            {render_slot(@loading_content)}
          <% else %>
            {gettext("Searching…")}
          <% end %>
        </div>
        <div :if={not @loading and @options != []} class="bt-combobox__options">
          {render_slot(@options)}
        </div>
        <div
          :if={not @loading and @options == [] and @empty != [] and @open}
          class="bt-combobox__status"
          role="status"
        >
          {render_slot(@empty)}
        </div>
      </div>
    </div>
    """
  end

  attr :id, :string, default: nil, doc: "Needed for aria-activedescendant; a11y.js assigns one if missing."
  attr :selected, :boolean, default: false
  attr :variant, :string, default: "default", values: ~w(default warning)
  attr :rest, :global, include: ~w(phx-click phx-value-id type)

  slot :inner_block, required: true

  def bt_combobox_option(assigns) do
    variant_class =
      case {assigns.variant, assigns.selected} do
        {"warning", true} -> "bt-combobox__option bt-combobox__option--warning bt-combobox__option--selected"
        {"warning", _} -> "bt-combobox__option bt-combobox__option--warning"
        {_, true} -> "bt-combobox__option bt-combobox__option--selected"
        _ -> "bt-combobox__option"
      end

    assigns = assign(assigns, :class, variant_class)

    ~H"""
    <button
      type="button"
      id={@id}
      class={@class}
      role="option"
      aria-selected={to_string(@selected)}
      tabindex="-1"
      {@rest}
    >
      {render_slot(@inner_block)}
    </button>
    """
  end

  attr :class, :any, default: nil
  slot :inner_block, required: true

  def bt_tree_empty(assigns) do
    ~H"""
    <div class={["bt-tree-empty", @class]}>{render_slot(@inner_block)}</div>
    """
  end

  attr :class, :any, default: nil
  attr :items, :list, required: true
  attr :separator, :string, default: "/"
  attr :label, :string, default: nil
  attr :rest, :global

  def bt_breadcrumb(assigns) do
    assigns = assign_new(assigns, :nav_label, fn -> assigns.label || gettext("Breadcrumb") end)

    ~H"""
    <nav class={["bt-breadcrumb", @class]} aria-label={@nav_label} {@rest}>
      <ol class="bt-breadcrumb__list" role="list">
        <li :for={{item, index} <- Enum.with_index(@items)} class="bt-breadcrumb__item">
          <span :if={index > 0} class="bt-breadcrumb__sep" aria-hidden="true">{@separator}</span>
          <.link
            :if={!item[:current] && (item[:href] || item[:navigate] || item[:patch])}
            href={item[:href]}
            navigate={item[:navigate]}
            patch={item[:patch]}
            class="bt-breadcrumb__link"
          >
            {item.label}
          </.link>
          <span :if={item[:current]} class="bt-breadcrumb__current" aria-current="page">
            {item.label}
          </span>
        </li>
      </ol>
    </nav>
    """
  end

  attr :id, :string, default: nil
  attr :class, :any, default: nil
  attr :compact, :boolean, default: false
  attr :title, :string, default: nil
  attr :title_tag, :string, default: "h3", values: ~w(h2 h3 h4 p)
  attr :description, :string, default: nil
  attr :rest, :global
  slot :icon
  slot :actions
  slot :inner_block

  # Slots are lists: check `!= []`, not `render_slot/1` (which is nil when empty).
  def bt_empty(assigns) do
    ~H"""
    <div id={@id} class={["bt-empty", @compact && "bt-empty--compact", @class]} {@rest}>
      <div :if={@icon != []} class="bt-empty__icon" aria-hidden="true">{render_slot(@icon)}</div>
      <.dynamic_tag :if={@title} tag_name={@title_tag} class="bt-empty__title">{@title}</.dynamic_tag>
      <p :if={@description} class="bt-empty__description">{@description}</p>
      <div :if={@inner_block != []}>{render_slot(@inner_block)}</div>
      <div :if={@actions != []} class="bt-empty__actions">{render_slot(@actions)}</div>
    </div>
    """
  end

  attr :class, :any, default: nil
  attr :size, :string, default: "md", values: ~w(sm md lg)
  attr :label, :string, default: nil, doc: "Announced text; defaults to \"Loading\"."
  attr :rest, :global

  def bt_spinner(assigns) do
    assigns =
      assigns
      |> assign(:class, ["bt-spinner", size_class("bt-spinner", assigns.size), assigns.class])
      |> assign(:announce, assigns.label || gettext("Loading"))

    ~H"""
    <span class={@class} role="status" {@rest}>
      <span class="bt-sr-only">{@announce}</span>
    </span>
    """
  end

  attr :class, :any, default: nil
  attr :current, :integer, required: true
  attr :steps, :list, required: true
  attr :icons, :boolean, default: false
  attr :show_labels, :boolean, default: false

  def bt_stepper(assigns) do
    labeled? = Enum.all?(assigns.steps, &is_binary/1)
    show_labels? = assigns.show_labels && not labeled?

    stepper_class =
      cond do
        assigns.icons -> "bt-stepper bt-stepper--icons"
        labeled? -> "bt-stepper bt-stepper--labeled"
        true -> "bt-stepper"
      end

    assigns =
      assigns
      |> assign(:labeled?, labeled?)
      |> assign(:show_labels?, show_labels?)
      |> assign(:stepper_class, stepper_class)

    ~H"""
    <div class={@class}>
      <div class={@stepper_class} role="list" aria-label={gettext("Progress")}>
        <%= for {step, index} <- Enum.with_index(@steps, 1) do %>
          <span :if={index > 1} class="bt-stepper__connector" aria-hidden="true"></span>
          <span
            class={step_classes(index, @current, @labeled?)}
            role="listitem"
            aria-current={if index == @current, do: "step", else: false}
            aria-label={step_aria_label(step, index, @labeled?)}
          >
            <%= if @labeled? and index < @current do %>
              <span class="bt-stepper__check bt-symbol" aria-hidden="true">check</span>
            <% else %>
              {step_content(step, index, @current, @labeled?)}
            <% end %>
          </span>
        <% end %>
      </div>
      <div :if={@show_labels?} class="bt-stepper__labels">
        <span :for={label <- @steps}>{label}</span>
      </div>
    </div>
    """
  end

  defp step_classes(index, current, labeled?) do
    [
      "bt-stepper__step",
      index == current && "bt-stepper__step--active",
      index == current && labeled? && "bt-stepper__step--badge",
      index < current && "bt-stepper__step--complete"
    ]
  end

  defp step_content(step, index, current, labeled?) when labeled? do
    cond do
      index == current -> step
      true -> Integer.to_string(index)
    end
  end

  defp step_content(step, index, _current, false), do: step_marker(step, index)

  defp step_aria_label(step, _index, true) when is_binary(step), do: step
  defp step_aria_label(_step, index, false), do: gettext("Step %{number}", number: index)

  defp step_marker(step, _index) when is_binary(step), do: step
  defp step_marker(_step, index), do: index

  attr :id, :string, required: true
  attr :class, :any, default: nil
  attr :title, :string, required: true
  attr :subtitle, :string, default: nil
  attr :large, :boolean, default: false
  attr :close_event, :any,
    required: true,
    doc: "Server event name, or a `Phoenix.LiveView.JS` command for client-side modals (e.g. `JS.hide(to: \"#id\")`)."

  attr :close_label, :string, default: nil
  attr :show_close, :boolean, default: true
  attr :rest, :global
  slot :inner_block, required: true
  slot :footer
  slot :header_actions

  # Focus: moves into the panel on mount, is trapped by focus_wrap, and returns
  # to the element that was focused before opening when the modal is removed
  # (a11y.js remembers it via data-focus-return).
  def bt_modal(assigns) do
    assigns = assign_new(assigns, :close_label, fn -> gettext("Close dialog") end)

    ~H"""
    <%!-- phx-remove plays the exit animation before LiveView removes the
         modal (see .bt-modal--leaving in motion.css). --%>
    <div
      id={@id}
      class={["bt-modal", @class]}
      phx-key="Escape"
      phx-window-keydown={@close_event}
      phx-remove={Phoenix.LiveView.JS.transition("bt-modal--leaving", time: 150)}
      data-focus-return
      {@rest}
    >
      <button
        type="button"
        class="bt-modal__backdrop"
        phx-click={@close_event}
        aria-label={@close_label}
        tabindex="-1"
      />
      <.focus_wrap
        id={"#{@id}-panel"}
        class={["bt-modal__panel", @large && "bt-modal__panel--lg"]}
        role="dialog"
        aria-modal="true"
        aria-labelledby={"#{@id}-title"}
        aria-describedby={@subtitle && "#{@id}-subtitle"}
        phx-mounted={Phoenix.LiveView.JS.focus_first()}
      >
        <header class="bt-modal__header">
          <div class="bt-modal__heading">
            <h2 id={"#{@id}-title"} class="bt-modal__title">{@title}</h2>
            <p :if={@subtitle} id={"#{@id}-subtitle"} class="bt-modal__subtitle">{@subtitle}</p>
          </div>
          <div :if={@header_actions != []}>{render_slot(@header_actions)}</div>
          <button
            :if={@show_close}
            type="button"
            class="bt-icon-button"
            phx-click={@close_event}
            aria-label={@close_label}
          >
            <span class="bt-icon" aria-hidden="true">close</span>
          </button>
        </header>
        <div class="bt-modal__body">{render_slot(@inner_block)}</div>
        <footer :if={@footer != []} class="bt-modal__footer">{render_slot(@footer)}</footer>
      </.focus_wrap>
    </div>
    """
  end
end
