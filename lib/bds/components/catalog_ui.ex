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

  attr :class, :any, default: nil
  slot :inner_block, required: true

  def bt_icon(assigns) do
    ~H"""
    <span class={["bt-icon", @class]} aria-hidden="true">{render_slot(@inner_block)}</span>
    """
  end

  attr :class, :any, default: nil
  attr :variant, :string, default: "default", values: ~w(default primary)
  attr :label, :string, required: true
  attr :icon, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: false

  def bt_icon_button(assigns) do
    variant_class =
      if assigns.variant == "primary",
        do: "bt-icon-button bt-icon-button--primary",
        else: "bt-icon-button"

    assigns = assign(assigns, :class, [variant_class, assigns.class])

    ~H"""
    <button type="button" class={@class} aria-label={@label} {@rest}>
      <span :if={@icon} class="bt-icon" aria-hidden="true">{@icon}</span>
      {render_slot(@inner_block)}
    </button>
    """
  end

  attr :class, :any, default: nil
  attr :extended, :boolean, default: false
  attr :label, :string, required: true
  attr :rest, :global
  slot :inner_block, required: true

  def bt_fab(assigns) do
    ~H"""
    <button
      type="button"
      class={["bt-fab", @extended && "bt-fab--extended", @class]}
      aria-label={@label}
      {@rest}
    >
      {render_slot(@inner_block)}
    </button>
    """
  end

  attr :class, :any, default: nil
  attr :variant, :string, default: "default"
  attr :span, :string, default: nil
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
    <article class={@class}>
      <div :if={@span} class="bt-card__media"></div>
      <h3 :if={@title != []}>{render_slot(@title)}</h3>
      <div :if={@inner_block != []}>{render_slot(@inner_block)}</div>
      <div :if={@actions != []} class="bt-card__actions">{render_slot(@actions)}</div>
    </article>
    """
  end

  attr :class, :any, default: nil
  attr :variant, :string, default: "default"
  slot :inner_block

  def bt_badge(assigns) do
    variant_class =
      case assigns.variant do
        "dot" -> "bt-badge bt-badge--dot"
        "inline" -> "bt-badge bt-badge--inline"
        "inline-success" -> "bt-badge bt-badge--inline bt-badge--success"
        "success" -> "bt-badge bt-badge--success"
        "primary" -> "bt-badge bt-badge--primary"
        "secondary" -> "bt-badge bt-badge--secondary"
        _ -> "bt-badge"
      end

    assigns = assign(assigns, :class, [variant_class, assigns.class])

    ~H"""
    <span class={@class}>{render_slot(@inner_block)}</span>
    """
  end

  slot :inner_block, required: true

  def bt_badge_wrap(assigns) do
    ~H"""
    <span class="bt-badge-wrap">{render_slot(@inner_block)}</span>
    """
  end

  attr :class, :any, default: nil
  attr :variant, :string, default: "default", values: ~w(default selected outline)
  attr :tag, :string, default: "span", values: ~w(span button)
  attr :rest, :global
  slot :inner_block, required: true

  def bt_chip(assigns) do
    variant_class =
      case assigns.variant do
        "selected" -> "bt-chip bt-chip--selected"
        "outline" -> "bt-chip bt-chip--outline"
        _ -> "bt-chip"
      end

    assigns = assign(assigns, :class, [variant_class, assigns.class])

    ~H"""
    <button :if={@tag == "button"} type="button" class={@class} {@rest}>
      {render_slot(@inner_block)}
    </button>
    <span :if={@tag == "span"} class={@class}>{render_slot(@inner_block)}</span>
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
        href={item.href || "#"}
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
  attr :checked, :boolean, default: false
  attr :disabled, :boolean, default: false
  attr :rest, :global

  def bt_switch(assigns) do
    ~H"""
    <label class="bt-switch">
      <input
        type="checkbox"
        id={@id}
        name={@name}
        checked={@checked}
        disabled={@disabled}
        {@rest}
      />
      <span class="bt-switch__track" aria-hidden="true"></span>
      <span>{@label}</span>
    </label>
    """
  end

  attr :id, :string, default: nil
  attr :name, :string, required: true
  attr :label, :string, required: true
  attr :checked, :boolean, default: false
  attr :disabled, :boolean, default: false
  attr :rest, :global

  def bt_radio(assigns) do
    ~H"""
    <label class="bt-radio">
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

  attr :id, :string, default: nil
  attr :name, :string, default: nil
  attr :label, :string, default: nil
  attr :value, :integer, default: 50
  attr :min, :integer, default: 0
  attr :max, :integer, default: 100
  attr :help, :string, default: nil
  attr :rest, :global

  def bt_slider(assigns) do
    ~H"""
    <div :if={@label} class="bt-field">
      <label :if={@label} for={@id}>{@label}</label>
      <input
        type="range"
        id={@id}
        name={@name}
        class="bt-slider"
        min={@min}
        max={@max}
        value={@value}
        {@rest}
      />
      <small :if={@help} class="bt-help">{@help}</small>
    </div>
    <input
      :if={!@label}
      type="range"
      id={@id}
      name={@name}
      class="bt-slider"
      min={@min}
      max={@max}
      value={@value}
      {@rest}
    />
    """
  end

  attr :id, :string, required: true
  attr :title, :string, default: nil
  attr :role, :string, default: "dialog"
  attr :open, :boolean, default: false
  slot :inner_block, required: true
  slot :actions

  def bt_dialog(assigns) do
    ~H"""
    <div
      class="bt-dialog"
      id={@id}
      role={@role}
      aria-modal="true"
      aria-labelledby={@title && "#{@id}-title"}
      open={@open}
    >
      <div class="bt-dialog__surface">
        <h3 :if={@title} id={"#{@id}-title"}>{@title}</h3>
        {render_slot(@inner_block)}
        <div :if={@actions != []} class="bt-dialog__actions">{render_slot(@actions)}</div>
      </div>
    </div>
    """
  end

  attr :id, :string, required: true
  attr :open, :boolean, default: false
  slot :inner_block, required: true

  def bt_overlay(assigns) do
    ~H"""
    <div class="bt-overlay" id={@id} role="dialog" aria-modal="true" open={@open}>
      <div class="bt-overlay__surface">{render_slot(@inner_block)}</div>
    </div>
    """
  end

  attr :id, :string, required: true
  attr :toggle_label, :string, default: nil
  slot :item, required: true do
    attr :label, :string, required: true
  end

  def bt_menu_wrap(assigns) do
    assigns = assign_new(assigns, :toggle_label, fn -> gettext("Open menu") end)

    ~H"""
    <div class="bt-menu-wrap">
      <button type="button" class="bt-button bt-button--secondary" data-menu-toggle={@id}>
        {@toggle_label}
      </button>
      <div class="bt-menu" id={@id} role="menu">
        <button :for={item <- @item} type="button" role="menuitem">{item.label}</button>
      </div>
    </div>
    """
  end

  attr :id, :string, required: true
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
    ~H"""
    <div data-tabs id={@id}>
      <div class="bt-tabs" role="tablist">
        <button
          :for={tab <- @tab}
          type="button"
          class="bt-tab"
          role="tab"
          id={tab.id}
          data-tab={tab.id}
          aria-selected={Map.get(tab, :selected, false)}
        >
          {tab.label}
        </button>
      </div>
      <div
        :for={panel <- @panel}
        class="bt-tab-panel"
        id={panel.id}
        role="tabpanel"
        aria-hidden={!panel_selected?(@tab, panel.tab_id)}
      >
        {render_slot(panel)}
      </div>
    </div>
    """
  end

  defp panel_selected?(tabs, tab_id) do
    Enum.any?(tabs, &( &1.id == tab_id && Map.get(&1, :selected, false)))
  end

  attr :title, :string, required: true
  attr :open, :boolean, default: false
  slot :inner_block

  def bt_expansion(assigns) do
    ~H"""
    <div class="bt-expansion" data-expansion data-open={to_string(@open)}>
      <button class="bt-expansion__button" type="button" data-expansion-toggle>
        <span>{@title}</span>
        <span class="bt-expansion__icon">⌄</span>
      </button>
      <div class="bt-expansion__content">
        {render_slot(@inner_block)}
      </div>
    </div>
    """
  end

  attr :id, :string, required: true
  attr :open, :boolean, default: false
  slot :inner_block, required: true
  slot :actions

  def bt_snackbar(assigns) do
    ~H"""
    <div class="bt-snackbar" id={@id} data-open={to_string(@open)} role="status">
      {render_slot(@inner_block)}
      <div :if={@actions != []}>{render_slot(@actions)}</div>
    </div>
    """
  end

  attr :value, :integer, default: 0
  attr :label, :string, default: nil
  attr :class, :any, default: nil

  def bt_progress(assigns) do
    assigns = assign_new(assigns, :progress_aria_label, fn -> gettext("Progress") end)

    ~H"""
    <div class={["bt-progress", @class]} aria-label={@label || @progress_aria_label}>
      <div class="bt-progress__bar" style={"--value: #{@value}%"}></div>
    </div>
    """
  end

  attr :value, :integer, default: 0
  attr :label, :string, default: nil
  attr :class, :any, default: nil

  def bt_progress_circle(assigns) do
    ~H"""
    <div
      class={["bt-progress-circle", @class]}
      style={"--value: #{@value}%"}
      data-label={@label || "#{@value}%"}
    >
    </div>
    """
  end

  attr :text, :string, required: true
  slot :inner_block, required: true

  def bt_tooltip(assigns) do
    ~H"""
    <span class="bt-tooltip" data-tooltip={@text}>{render_slot(@inner_block)}</span>
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
  slot :inner_block, required: true

  def bt_container(assigns) do
    class =
      if assigns.variant == "compact",
        do: "bt-container bt-container--compact",
        else: "bt-container"

    assigns = assign(assigns, :class, class)

    ~H"""
    <section class={@class}>{render_slot(@inner_block)}</section>
    """
  end

  attr :title, :string, required: true
  attr :description, :string, default: nil
  slot :actions
  slot :inner_block

  def bt_section(assigns) do
    ~H"""
    <section class="bt-section">
      <div class="bt-section__header">
        <h2 class="bt-section__title">{@title}</h2>
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
  slot :item, required: true do
    attr :label, :string, required: true
    attr :pressed, :boolean
  end

  def bt_segmented(assigns) do
    assigns = assign_new(assigns, :label, fn -> gettext("Segmented control") end)

    ~H"""
    <div class="bt-segmented" role="group" aria-label={@label}>
      <button
        :for={item <- @item}
        type="button"
        aria-pressed={Map.get(item, :pressed, false)}
      >
        {item.label}
      </button>
    </div>
    """
  end

  attr :label, :string, required: true
  attr :swatch, :string, required: true

  def bt_color_swatch(assigns) do
    ~H"""
    <div class="bt-color-swatch">
      <div class="bt-color-swatch__color" style={"--swatch: #{@swatch}"}></div>
      <div class="bt-color-swatch__text">{@label}</div>
    </div>
    """
  end

  attr :class, :any, default: nil
  attr :name, :string, required: true
  attr :email, :string, default: nil
  attr :src, :string, default: nil
  attr :initials, :string, default: nil
  attr :compactness, :string, default: "compact", values: ~w(compact expanded)

  def bt_avatar(assigns) do
    initials = assigns.initials || avatar_initials(assigns.name)

    assigns =
      assigns
      |> assign(:initials, initials)
      |> assign(:compactness_class, "bt-avatar--#{assigns.compactness}")

    ~H"""
    <div class={["bt-avatar", @compactness_class, @class]}>
      <div class="bt-avatar__media" aria-hidden={is_nil(@src)}>
        <img :if={@src} src={@src} alt={@name} class="bt-avatar__image" />
        <span :if={is_nil(@src)}>{@initials}</span>
      </div>
      <div class="bt-avatar__text">
        <p class="bt-avatar__name">{@name}</p>
        <p :if={@email} class="bt-avatar__email">{@email}</p>
      </div>
    </div>
    """
  end

  attr :initials, :string, required: true
  attr :title, :string, required: true
  attr :subtitle, :string, default: nil
  attr :class, :any, default: nil

  def bt_list_item(assigns) do
    ~H"""
    <div class={["bt-list-item", @class]}>
      <div class="bt-list-item__avatar">{@initials}</div>
      <div class="bt-list-item__content">
        <p class="bt-list-item__title">{@title}</p>
        <p :if={@subtitle} class="bt-list-item__subtitle">{@subtitle}</p>
      </div>
    </div>
    """
  end

  slot :inner_block, required: true

  def bt_list_group(assigns) do
    ~H"""
    <div class="bt-list">{render_slot(@inner_block)}</div>
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

  def bt_tree(assigns) do
    ~H"""
    <ul class={["bt-tree", @depth > 0 && "bt-tree--nested", @class]} id={@id} role={if(@depth == 0, do: "tree")}>
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

    assigns =
      assigns
      |> assign(:key, key)
      |> assign(:children, children)
      |> assign(:has_children?, has_children?)
      |> assign(:open?, open?)
      |> assign(:section?, section?)
      |> assign(:selectable?, selectable?)
      |> assign(:label_row_class, tree_label_row_class(node, selectable?))

    ~H"""
    <li class="bt-tree__item" role={if(@depth == 0, do: "treeitem")} aria-expanded={to_string(@open?)}>
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
            aria-label={gettext("Toggle branch")}
          >
            <span class={["bt-tree__chevron", @open? && "bt-tree__chevron--open"]}>›</span>
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
            role="option"
          >
            <.bt_tree_label_content node={@node} />
          </button>
          <div :if={not @section? and not @selectable?} class={@label_row_class}>
            <.bt_tree_label_content node={@node} />
          </div>
          <.bt_tree
            :if={@has_children? and @open?}
            nodes={@children}
            expanded={@expanded}
            toggle_event={@toggle_event}
            toggle_target={@toggle_target}
            select_event={@select_event}
            select_target={@select_target}
            depth={@depth + 1}
          />
        </div>
      </div>
    </li>
    """
  end

  attr :node, :map, required: true

  defp bt_tree_label_content(assigns) do
    ~H"""
    <.bt_avatar
      :if={@node[:avatar]}
      name={@node.avatar.name}
      email={Map.get(@node.avatar, :email)}
      src={Map.get(@node.avatar, :src)}
      initials={Map.get(@node.avatar, :initials)}
      compactness={Map.get(@node.avatar, :compactness, "compact")}
    />
    <.bt_badge
      :if={!@node[:avatar] && tree_project_doc_badge?(@node)}
      variant="inline"
      class="bt-tree__doc-badge"
    >
      {tree_project_doc_label(@node)}
    </.bt_badge>
    <span :if={!@node[:avatar] && @node[:kind_label]} class="bt-tree__kind">{@node.kind_label}</span>
    <span :if={!@node[:avatar]} class="bt-tree__name">{@node.name}</span>
    <span :if={!@node[:avatar] && @node[:doc_num] && !tree_project_doc_badge?(@node)} class="bt-tree__doc">
      P-{@node.doc_num}
    </span>
    <span :if={!@node[:avatar] && @node[:secondary_label]} class="bt-tree__secondary">
      {@node.secondary_label}
    </span>
    <span :if={@node[:badges] != []} class="bt-tree__badges">
      <.bt_badge
        :for={badge <- @node[:badges] || []}
        variant={Map.get(badge, :variant, "secondary")}
      >
        {badge.label}
      </.bt_badge>
    </span>
    <span :if={!@node[:avatar] && @node[:meta]} class="bt-tree__meta">· {@node.meta}</span>
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
      |> assign(:field_class, ["bt-field", assigns.errors != [] && "bt-field--error"])

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
              ×
            </button>
          </div>
        </div>
      </div>
      <div
        :if={@open}
        id={@panel_id}
        class="bt-combobox__panel"
        role="listbox"
      >
        <div :if={@panel_footer != []} class="bt-combobox__footer">
          {render_slot(@panel_footer)}
        </div>
        <div :if={@loading} class="bt-combobox__status">
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
        >
          {render_slot(@empty)}
        </div>
      </div>
    </div>
    """
  end

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
    <button type="button" class={@class} role="option" aria-selected={to_string(@selected)} {@rest}>
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

  def bt_breadcrumb(assigns) do
    ~H"""
    <nav class={["bt-breadcrumb", @class]} aria-label={gettext("Breadcrumb")}>
      <%= for {item, index} <- Enum.with_index(@items) do %>
        <span :if={index > 0} class="bt-breadcrumb__sep" aria-hidden="true">{@separator}</span>
        <span class="bt-breadcrumb__item">
          <.link
            :if={item[:href] || item[:navigate] || item[:patch]}
            href={item[:href]}
            navigate={item[:navigate]}
            patch={item[:patch]}
            class="bt-breadcrumb__link"
          >
            {item.label}
          </.link>
          <span :if={item[:current]} class="bt-breadcrumb__current">{item.label}</span>
        </span>
      <% end %>
    </nav>
    """
  end

  attr :class, :any, default: nil
  attr :compact, :boolean, default: false
  attr :title, :string, default: nil
  attr :description, :string, default: nil
  slot :icon
  slot :actions
  slot :inner_block

  def bt_empty(assigns) do
    ~H"""
    <div class={["bt-empty", @compact && "bt-empty--compact", @class]}>
      <div :if={render_slot(@icon) != []} class="bt-empty__icon">{render_slot(@icon)}</div>
      <h3 :if={@title} class="bt-empty__title">{@title}</h3>
      <p :if={@description} class="bt-empty__description">{@description}</p>
      <div :if={render_slot(@inner_block) != []}>{render_slot(@inner_block)}</div>
      <div :if={render_slot(@actions) != []} class="bt-empty__actions">{render_slot(@actions)}</div>
    </div>
    """
  end

  attr :class, :any, default: nil
  attr :size, :string, default: "md", values: ~w(sm md lg)
  attr :label, :string, default: nil

  def bt_spinner(assigns) do
    size_class =
      case assigns.size do
        "sm" -> "bt-spinner bt-spinner--sm"
        "lg" -> "bt-spinner bt-spinner--lg"
        _ -> "bt-spinner"
      end

    assigns = assign(assigns, :class, [size_class, assigns.class])

    ~H"""
    <span class={@class} role="status" aria-live="polite">
      <span :if={@label} class="sr-only">{@label}</span>
    </span>
    """
  end

  attr :class, :any, default: nil
  attr :current, :integer, required: true
  attr :steps, :list, required: true
  attr :icons, :boolean, default: false

  def bt_stepper(assigns) do
    stepper_class = if assigns.icons, do: "bt-stepper bt-stepper--icons", else: "bt-stepper"
    assigns = assign(assigns, :stepper_class, stepper_class)

    ~H"""
    <div class={@class}>
      <div class={@stepper_class} role="list" aria-label={gettext("Progress")}>
        <%= for {step, index} <- Enum.with_index(@steps, 1) do %>
          <span :if={index > 1} class="bt-stepper__connector" aria-hidden="true"></span>
          <span
            class={[
              "bt-stepper__step",
              index == @current && "bt-stepper__step--active",
              index < @current && "bt-stepper__step--complete"
            ]}
            role="listitem"
            aria-current={if index == @current, do: "step", else: false}
          >
            {step_marker(step, index)}
          </span>
        <% end %>
      </div>
      <div class="bt-stepper__labels">
        <span :for={label <- @steps}>{label}</span>
      </div>
    </div>
    """
  end

  defp step_marker(step, _index) when is_binary(step), do: step
  defp step_marker(_step, index), do: index

  attr :id, :string, required: true
  attr :class, :any, default: nil
  attr :title, :string, required: true
  attr :subtitle, :string, default: nil
  attr :large, :boolean, default: false
  attr :close_event, :string, required: true
  attr :close_label, :string, default: nil
  attr :show_close, :boolean, default: true
  attr :rest, :global
  slot :inner_block, required: true
  slot :footer
  slot :header_actions

  def bt_modal(assigns) do
    assigns = assign_new(assigns, :close_label, fn -> gettext("Close dialog") end)

    ~H"""
    <div
      id={@id}
      class={["bt-modal", @class]}
      phx-key="Escape"
      phx-window-keydown={@close_event}
      {@rest}
    >
      <button
        type="button"
        class="bt-modal__backdrop"
        phx-click={@close_event}
        aria-label={@close_label}
      />
      <div class={["bt-modal__panel", @large && "bt-modal__panel--lg"]} role="dialog" aria-modal="true">
        <header class="bt-modal__header">
          <div class="min-w-0">
            <h2 class="bt-modal__title">{@title}</h2>
            <p :if={@subtitle} class="bt-modal__subtitle">{@subtitle}</p>
          </div>
          <div :if={render_slot(@header_actions) != []}>{render_slot(@header_actions)}</div>
          <button
            :if={@show_close}
            type="button"
            class="bt-icon-button"
            phx-click={@close_event}
            aria-label={@close_label}
          >
            <span class="bt-icon" aria-hidden="true">×</span>
          </button>
        </header>
        <div class="bt-modal__body">{render_slot(@inner_block)}</div>
        <footer :if={render_slot(@footer) != []} class="bt-modal__footer">{render_slot(@footer)}</footer>
      </div>
    </div>
    """
  end
end
