defmodule Bds.Components.Expense do
  @moduledoc """
  Spend / expense workspace components (`bt-expense-*`) for liquidaciones lists,
  workflow tracks, gasto cards, and wizards.
  """
  use Phoenix.Component
  use Gettext, backend: Bds.Gettext

  @workflow_pill %{
    "info" => "bt-expense-workflow__pill bt-expense-workflow__pill--info",
    "warning" => "bt-expense-workflow__pill bt-expense-workflow__pill--warning",
    "success" => "bt-expense-workflow__pill bt-expense-workflow__pill--success"
  }

  attr :class, :any, default: nil
  attr :title, :string, required: true
  attr :meta, :string, default: nil
  slot :actions
  slot :filters
  slot :status

  def bt_expense_toolbar(assigns) do
    ~H"""
    <div class={["bt-expense-toolbar", @class]}>
      <div class="bt-expense-toolbar__head">
        <h1 class="bt-expense-toolbar__title">{@title}</h1>
        <span :if={@meta} class="bt-expense-toolbar__meta">{@meta}</span>
      </div>
      <div :if={render_slot(@actions) != []}>{render_slot(@actions)}</div>
      <div :if={render_slot(@filters) != []}>{render_slot(@filters)}</div>
      <div :if={render_slot(@status) != []}>{render_slot(@status)}</div>
    </div>
    """
  end

  attr :class, :any, default: nil
  attr :filters, :list, required: true
  attr :active, :string, required: true
  attr :event, :string, default: "set_filter"

  def bt_expense_filter_bar(assigns) do
    ~H"""
    <div class={["bt-expense-filter-bar", @class]} role="tablist" aria-label={gettext("Liquidaciones filters")}>
      <button
        :for={filter <- @filters}
        id={filter[:dom_id] || filter.id}
        type="button"
        role="tab"
        aria-selected={to_string(filter_value(filter) == @active)}
        phx-click={@event}
        phx-value-filter={filter_value(filter)}
        class={["bt-expense-filter-bar__btn", filter_value(filter) == @active && "is-active"]}
      >
        {filter.label}
      </button>
    </div>
    """
  end

  defp filter_value(filter), do: filter[:value] || filter.id

  attr :id, :string, required: true
  attr :class, :any, default: nil
  attr :concept, :string, required: true
  attr :date_label, :string, required: true
  attr :project_name, :string, required: true
  attr :gasto_count, :integer, required: true
  attr :rejected?, :boolean, default: false
  attr :rejected_label, :string
  attr :current_step_index, :integer, default: 1
  attr :current_step_label, :string, default: nil
  attr :pill_variant, :string, default: "info", values: ~w(info warning success)
  attr :total_steps, :integer, default: 5
  attr :navigate, :any, default: nil
  attr :patch, :any, default: nil
  attr :href, :string, default: nil
  attr :rest, :global
  slot :project_icon

  def bt_expense_liquidacion_card(assigns) do
    pill_class =
      Map.get(@workflow_pill, assigns.pill_variant, @workflow_pill["info"])

    card_class = ["bt-expense-liquidacion-card", assigns.class]

    assigns =
      assigns
      |> assign(:rejected_label, resolved_rejected_label(assigns))
      |> assign(:pill_class, pill_class)
      |> assign(:card_class, card_class)
      |> assign(:link?, link_card?(assigns))

    ~H"""
    <%= if @link? do %>
      <.link
        id={@id}
        class={@card_class}
        navigate={@navigate}
        patch={@patch}
        href={@href}
        {@rest}
      >
        <.bt_expense_liquidacion_card_body
          rejected?={@rejected?}
          rejected_label={@rejected_label}
          current_step_index={@current_step_index}
          current_step_label={@current_step_label}
          pill_class={@pill_class}
          total_steps={@total_steps}
          date_label={@date_label}
          concept={@concept}
          project_name={@project_name}
          gasto_count={@gasto_count}
        >
          <:project_icon>{render_slot(@project_icon)}</:project_icon>
        </.bt_expense_liquidacion_card_body>
      </.link>
    <% else %>
      <article id={@id} class={@card_class} {@rest}>
        <.bt_expense_liquidacion_card_body
          rejected?={@rejected?}
          rejected_label={@rejected_label}
          current_step_index={@current_step_index}
          current_step_label={@current_step_label}
          pill_class={@pill_class}
          total_steps={@total_steps}
          date_label={@date_label}
          concept={@concept}
          project_name={@project_name}
          gasto_count={@gasto_count}
        >
          <:project_icon>{render_slot(@project_icon)}</:project_icon>
        </.bt_expense_liquidacion_card_body>
      </article>
    <% end %>
    """
  end

  attr :rejected?, :boolean, required: true
  attr :rejected_label, :string, required: true
  attr :current_step_index, :integer, required: true
  attr :current_step_label, :string, default: nil
  attr :pill_class, :string, required: true
  attr :total_steps, :integer, required: true
  attr :date_label, :string, required: true
  attr :concept, :string, required: true
  attr :project_name, :string, required: true
  attr :gasto_count, :integer, required: true
  slot :project_icon

  defp bt_expense_liquidacion_card_body(assigns) do
    ~H"""
    <div class="bt-expense-liquidacion-card__top">
      <%= if @rejected? do %>
        <span class="bt-expense-workflow__pill bt-expense-workflow__pill--error">{@rejected_label}</span>
      <% else %>
        <.bt_expense_workflow_track
          total_steps={@total_steps}
          current_index={@current_step_index}
          current_label={@current_step_label}
          pill_class={@pill_class}
        />
      <% end %>
      <span class="bt-expense-date-chip">{@date_label}</span>
    </div>
    <p class="bt-expense-liquidacion-card__concept">{@concept}</p>
    <div class="bt-expense-liquidacion-card__meta">
      <div class="bt-expense-liquidacion-card__project">
        <span :if={render_slot(@project_icon) != []} class="bt-expense-liquidacion-card__project-icon">
          {render_slot(@project_icon)}
        </span>
        <span class="bt-expense-liquidacion-card__project-name">{@project_name}</span>
      </div>
      <span>
        {ngettext("%{count} expense", "%{count} expenses", @gasto_count, count: @gasto_count)}
      </span>
    </div>
    """
  end

  defp link_card?(assigns) do
    assigns.navigate || assigns.patch || assigns.href
  end

  attr :total_steps, :integer, default: 5
  attr :current_index, :integer, required: true
  attr :current_label, :string, required: true
  attr :pill_class, :string, required: true
  attr :class, :any, default: nil

  def bt_expense_workflow_track(assigns) do
    ~H"""
    <div class={["bt-expense-workflow", @class]} aria-hidden="true">
      <%= for step <- 1..@total_steps do %>
        <span :if={step > 1} class="bt-expense-workflow__line"></span>
        <%= if step == @current_index do %>
          <span class={@pill_class}>{@current_label}</span>
        <% else %>
          <span class={[
            "bt-expense-workflow__dot",
            step < @current_index && "bt-expense-workflow__dot--done"
          ]}>
          </span>
        <% end %>
      <% end %>
    </div>
    """
  end

  attr :class, :any, default: nil
  attr :variant, :string, default: "info", values: ~w(info error success)
  slot :inner_block, required: true

  def bt_expense_callout(assigns) do
    variant_class = "bt-expense-callout bt-expense-callout--#{assigns.variant}"
    assigns = assign(assigns, :class, [variant_class, assigns.class])

    ~H"""
    <div class={@class} role={if @variant == "error", do: "alert", else: "status"}>
      {render_slot(@inner_block)}
    </div>
    """
  end

  attr :class, :any, default: nil
  attr :label, :string, required: true
  attr :value, :string, required: true

  def bt_expense_summary(assigns) do
    ~H"""
    <div class={["bt-expense-summary", @class]}>
      <p class="bt-expense-summary__label">{@label}</p>
      <p class="bt-expense-summary__value">{@value}</p>
    </div>
    """
  end

  attr :class, :any, default: nil
  attr :projects, :list, required: true
  attr :selected_id, :string, default: nil
  attr :empty_message, :string, default: nil
  attr :select_event, :string, default: "select_project"

  def bt_expense_project_list(assigns) do
    assigns =
      assign_new(assigns, :empty_message, fn -> gettext("No matching projects.") end)

    ~H"""
    <div class={["bt-expense-project-list", @class]}>
      <p :if={@projects == []} class="p-4 text-sm" style="color: var(--bt-color-text-muted);">
        {@empty_message}
      </p>
      <button
        :for={project <- @projects}
        type="button"
        phx-click={@select_event}
        phx-value-project_id={project.id}
        class={[
          "bt-expense-project-list__item",
          to_string(project.id) == @selected_id && "is-selected"
        ]}
      >
        <span class="bt-expense-project-list__code">{project.doc_num}</span>
        <span class="min-w-0 flex-1 font-medium leading-tight">{project.name}</span>
      </button>
    </div>
    """
  end

  attr :class, :any, default: nil
  attr :title, :string, required: true
  attr :subtitle, :string, default: nil
  attr :total_label, :string, default: nil
  slot :actions
  slot :inner_block, required: true

  def bt_expense_section(assigns) do
    ~H"""
    <section class={["bt-expense-section", @class]}>
      <header class="bt-expense-section__header">
        <div>
          <h2 class="bt-expense-section__title">{@title}</h2>
          <p :if={@subtitle} class="bt-expense-section__subtitle">{@subtitle}</p>
        </div>
        <div class="flex flex-wrap items-center gap-3">
          <span :if={@total_label} class="bt-expense-section__total">{@total_label}</span>
          <div :if={render_slot(@actions) != []}>{render_slot(@actions)}</div>
        </div>
      </header>
      <div class="bt-expense-section__body">{render_slot(@inner_block)}</div>
    </section>
    """
  end

  attr :id, :string, required: true
  attr :class, :any, default: nil
  attr :type_label, :string, required: true
  attr :date_label, :string, required: true
  attr :title, :string, required: true
  attr :amount, :string, default: nil
  attr :currency_suffix, :string, default: nil
  attr :rebill?, :boolean, default: false
  attr :rebill_label, :string, default: nil
  attr :footer_label, :string, default: nil
  attr :href, :string, default: nil
  attr :navigate, :any, default: nil
  slot :actions
  slot :badges

  def bt_expense_gasto_card(assigns) do
    assigns = assign_new(assigns, :rebill_label, fn -> gettext("Rebill") end)

    ~H"""
    <article id={@id} class={["bt-expense-gasto-card", @class]}>
      <%= if @href || @navigate do %>
        <.link href={@href} navigate={@navigate} class="bt-expense-gasto-card__body bt-expense-gasto-card__body--link">
          <.bt_expense_gasto_card_body {assigns} />
        </.link>
      <% else %>
        <div class="bt-expense-gasto-card__body">
          <.bt_expense_gasto_card_body {assigns} />
        </div>
      <% end %>
      <div :if={render_slot(@actions) != []} class="bt-expense-gasto-card__actions">
        {render_slot(@actions)}
      </div>
    </article>
    """
  end

  attr :type_label, :string, required: true
  attr :date_label, :string, required: true
  attr :title, :string, required: true
  attr :amount, :string, default: nil
  attr :currency_suffix, :string, default: nil
  attr :rebill?, :boolean, default: false
  attr :rebill_label, :string, default: nil
  attr :footer_label, :string, default: nil
  slot :badges

  defp bt_expense_gasto_card_body(assigns) do
    ~H"""
    <div class="bt-expense-gasto-card__head">
      <span class="bt-expense-gasto-card__type">{@type_label}</span>
      <span class="bt-expense-date-chip">{@date_label}</span>
    </div>
    <div class="bt-expense-gasto-card__row">
      <h3 class="bt-expense-gasto-card__title">{@title}</h3>
      <div class="flex items-center gap-2 shrink-0">
        <span :if={@rebill?} class="bt-badge bt-badge--inline bt-badge--success">{@rebill_label}</span>
        {render_slot(@badges)}
        <p class="bt-expense-gasto-card__amount">
          <%= if @amount do %>
            {@amount}
            <span :if={@currency_suffix} class="bt-expense-gasto-card__amount-suffix">
              {@currency_suffix}
            </span>
          <% else %>
            —
          <% end %>
        </p>
      </div>
    </div>
    <div :if={@footer_label} class="bt-expense-gasto-card__footer">{@footer_label}</div>
    """
  end

  @doc """
  Maps liquidación workflow status to pill variant (`info`, `warning`, `success`).
  """
  @spec workflow_pill_variant(String.t()) :: String.t()
  def workflow_pill_variant(status) do
    case String.downcase(status || "") do
      "imputada" -> "info"
      "liberada" -> "warning"
      "pendientefinanzas" -> "warning"
      "pendienterrhh" -> "warning"
      "aprobada" -> "success"
      "pagada" -> "success"
      _ -> "info"
    end
  end

  defp resolved_rejected_label(assigns) do
    case Map.get(assigns, :rejected_label) do
      label when is_binary(label) ->
        if String.trim(label) != "", do: label, else: gettext("Rejected liquidación")

      _ ->
        gettext("Rejected liquidación")
    end
  end
end
