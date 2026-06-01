defmodule Bds.Components.Calendar do
  @moduledoc """
  Timesheet calendar components (`bt-calendar-*`) for Tempo-style month views.
  """
  use Phoenix.Component

  @statuses ~w(
    nuevo imputado completado liberado aprobado rechazado festivo vacaciones no-laborable
  )

  @weekdays ~w(MON TUE WED THU FRI SAT SUN)

  attr :id, :string, default: nil
  attr :class, :any, default: nil
  attr :sidebar_open, :boolean, default: false
  attr :on_sidebar_close, :string, default: nil, doc: "phx-click event to close sidebar (mobile backdrop)"
  attr :viewport, :boolean, default: false
  attr :rest, :global

  slot :banner
  slot :sidebar
  slot :toolbar
  slot :inner_block, required: true
  slot :legend

  def bt_calendar_shell(assigns) do
    ~H"""
    <div
      id={@id}
      class={[
        "bt-calendar-shell",
        @sidebar_open && "bt-calendar-shell--sidebar-open",
        @viewport && "bt-calendar-shell--viewport",
        @class
      ]}
      data-sidebar-open={if(@sidebar_open, do: "true", else: "false")}
      {@rest}
    >
      {render_slot(@banner)}
      <button
        :if={@sidebar_open && @on_sidebar_close}
        type="button"
        class="bt-calendar-shell__backdrop"
        phx-click={@on_sidebar_close}
        aria-label="Close templates panel"
      />
      <div :if={render_slot(@toolbar) != []} class="bt-calendar-shell__toolbar shrink-0">
        {render_slot(@toolbar)}
      </div>
      <div class="bt-calendar-shell__workspace">
        <aside :if={render_slot(@sidebar) != []} class="bt-calendar-shell__sidebar">
          {render_slot(@sidebar)}
        </aside>
        <div class="bt-calendar-shell__main">
          <div class="bt-calendar-shell__body">
            {render_slot(@inner_block)}
          </div>
          <div :if={render_slot(@legend) != []} class="bt-calendar-shell__legend shrink-0">
            {render_slot(@legend)}
          </div>
        </div>
      </div>
    </div>
    """
  end

  attr :class, :any, default: nil
  attr :title, :string, default: "Templates"
  attr :on_close, :any, default: nil
  attr :rest, :global
  slot :inner_block, required: true
  slot :actions

  def bt_calendar_templates_panel(assigns) do
    ~H"""
    <div class={["bt-calendar-templates h-full min-h-0 flex flex-col", @class]} {@rest}>
      <div class="bt-calendar-templates__header">
        <button
          :if={@on_close}
          type="button"
          phx-click={@on_close}
          class="bt-calendar-templates__close bt-icon-button"
          aria-label="Close panel"
        >
          <span class="bt-icon">←</span>
        </button>
        <span class="truncate">{@title}</span>
      </div>
      <div :if={render_slot(@actions) != []} class="shrink-0 px-4 py-2 border-b border-[var(--bt-color-border)] flex items-center justify-between">
        {render_slot(@actions)}
      </div>
      <div class="bt-calendar-templates__body">
        {render_slot(@inner_block)}
      </div>
    </div>
    """
  end

  attr :key, :string, required: true
  attr :name, :string, required: true
  attr :hours, :any, default: nil
  attr :projects, :list, default: []
  attr :class, :any, default: nil
  attr :rest, :global

  def bt_calendar_template_card(assigns) do
    assigns = assign(assigns, :project_rows, template_project_rows(assigns.projects, assigns.hours))

    ~H"""
    <article class={["bt-calendar-template-card", @class]} {@rest}>
      <div class="bt-calendar-template-card__row">
        <span class="bt-calendar-template-card__key">{@key}</span>
        <div class="min-w-0 flex-1">
          <p class="bt-calendar-template-card__name">{@name}</p>
          <div :if={@project_rows != []} class="bt-calendar-day__projects">
            <div :for={row <- @project_rows} class="bt-calendar-day__project">
              <span class="bt-calendar-day__project-name">{row.name}</span>
              <span :if={row.hours != nil} class="bt-calendar-day__project-hours">{row.hours}h</span>
            </div>
          </div>
        </div>
      </div>
    </article>
    """
  end

  attr :class, :any, default: nil
  attr :month_label, :string, default: nil
  attr :rest, :global
  slot :left
  slot :center
  slot :right

  def bt_calendar_toolbar(assigns) do
    ~H"""
    <div class={["bt-calendar-toolbar", @class]} {@rest}>
      <div class="bt-calendar-toolbar__row">
        <div class="flex items-center gap-1 min-w-0">{render_slot(@left)}</div>
        <div class="flex items-center justify-center gap-1.5 min-w-0">
          {render_slot(@center)}
          <span :if={@month_label && render_slot(@center) == []} class="bt-calendar-toolbar__month">
            {@month_label}
          </span>
        </div>
        <div class="flex items-center justify-end gap-1 min-w-0">{render_slot(@right)}</div>
      </div>
    </div>
    """
  end

  attr :show_weekends, :boolean, default: true
  attr :grid_columns, :string, required: true
  attr :labels, :list, default: nil
  attr :class, :any, default: nil
  attr :rest, :global

  def bt_calendar_weekdays(assigns) do
    labels = assigns.labels || @weekdays
    assigns = assign(assigns, :labels, labels)

    ~H"""
    <div class={["bt-calendar-weekdays", @class]} {@rest}>
      <div class="bt-calendar-weekdays__grid" style={"grid-template-columns: #{@grid_columns};"}>
        <span
          :for={{label, index} <- Enum.with_index(@labels)}
          class={[
            "bt-calendar-weekdays__label",
            index >= 5 && "bt-calendar-weekdays__label--weekend",
            index >= 5 && !@show_weekends && "bt-calendar-weekdays__label--hidden"
          ]}
        >
          {label}
        </span>
      </div>
    </div>
    """
  end

  attr :grid_columns, :string, required: true
  attr :show_weekends, :boolean, default: true
  attr :id, :string, default: nil
  attr :class, :any, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def bt_calendar_month_grid(assigns) do
    ~H"""
    <div
      id={@id}
      class={[
        "bt-calendar-month-grid",
        !@show_weekends && "bt-calendar-month-grid--weekends-hidden",
        @class
      ]}
      style={"grid-template-columns: #{@grid_columns}; grid-auto-rows: minmax(0, 1fr);"}
      {@rest}
    >
      {render_slot(@inner_block)}
    </div>
    """
  end

  attr :weekend, :boolean, default: false
  attr :class, :any, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def bt_calendar_month_cell(assigns) do
    ~H"""
    <div
      class={[
        "bt-calendar-month-grid__cell",
        @weekend && "bt-calendar-month-grid__cell--weekend",
        @class
      ]}
      {@rest}
    >
      {render_slot(@inner_block)}
    </div>
    """
  end

  attr :day, :integer, required: true
  attr :status, :string, required: true, values: @statuses
  attr :selected, :boolean, default: false
  attr :today, :boolean, default: false
  attr :outside, :boolean, default: false
  attr :projects, :list, default: []
  attr :type, :string, default: "button"
  attr :class, :any, default: nil
  attr :rest, :global

  def bt_calendar_day(assigns) do
    if assigns.outside do
      ~H"""
      <div
        class={[
          "bt-calendar-day bt-calendar-day--outside bt-calendar-day--no-laborable w-full h-full",
          @class
        ]}
        {@rest}
      />
      """
    else
      ~H"""
      <button
        type={@type}
        class={[
          "bt-calendar-day w-full h-full text-left",
          status_class(@status),
          @today && "bt-calendar-day--today",
          @selected && "bt-calendar-day--selected",
          @class
        ]}
        {@rest}
      >
        <span class="bt-calendar-day__number">{@day}</span>
        <div class="bt-calendar-day__content">
          <%= if @projects != [] do %>
            <div class="bt-calendar-day__projects">
              <%= for project <- Enum.take(@projects, 2) do %>
                <div class="bt-calendar-day__project">
                  <span class="bt-calendar-day__project-name">{project_name(project)}</span>
                  <span class="bt-calendar-day__project-hours">{project_hours(project)}h</span>
                </div>
              <% end %>
              <%= if length(@projects) > 2 do %>
                <span class="bt-calendar-day__more">+{length(@projects) - 2} more</span>
              <% end %>
            </div>
          <% end %>
        </div>
      </button>
      """
    end
  end

  attr :items, :list, required: true
  attr :id, :string, default: nil
  attr :class, :any, default: nil
  attr :label, :string, default: "Calendar status legend"
  attr :rest, :global

  def bt_calendar_legend(assigns) do
    items =
      Enum.filter(assigns.items, fn item ->
        (item[:count] || item["count"] || 0) > 0
      end)

    assigns = assign(assigns, :items, items)

    ~H"""
    <footer
      id={@id}
      class={["bt-calendar-legend", @class]}
      aria-label={@label}
      {@rest}
    >
      <ul class="bt-calendar-legend__list" role="list">
        <li :for={item <- @items} class="bt-calendar-legend__item">
          <span class={["bt-calendar-legend__icon", legend_icon_class(item)]}>
            <span aria-hidden="true">{item[:icon] || item["icon"]}</span>
          </span>
          <span>{item[:label] || item["label"]}</span>
          <span class="font-semibold tabular-nums">{item[:count] || item["count"]}</span>
        </li>
      </ul>
    </footer>
    """
  end

  defp status_class(status) when is_binary(status) do
    "bt-calendar-day--#{normalize_status(status)}"
  end

  defp modal_status_class(status) when is_binary(status) do
    "bt-calendar-day-modal__shell--#{normalize_status(status)}"
  end

  defp normalize_status(status) do
    status
    |> String.downcase()
    |> String.replace("_", "-")
  end

  defp legend_icon_class(item) do
    status =
      (item[:status] || item["status"] || item[:css] || item["css"] || "nuevo")
      |> to_string()
      |> String.downcase()
      |> String.replace("_", "-")

    "bt-calendar-legend__icon--#{status}"
  end

  defp project_name(%{name: name}), do: name
  defp project_name(%{"name" => name}), do: name
  defp project_name(name) when is_binary(name), do: name

  defp project_hours(%{hours: hours}), do: hours
  defp project_hours(%{"hours" => hours}), do: hours
  defp project_hours(hours) when is_number(hours), do: hours

  defp template_project_rows(projects, card_hours) do
    Enum.map(projects, fn project ->
      %{
        name: project_name(project),
        hours: template_row_hours(project, card_hours)
      }
    end)
  end

  defp template_row_hours(%{hours: hours}, _card_hours) when not is_nil(hours), do: hours
  defp template_row_hours(%{"hours" => hours}, _card_hours) when not is_nil(hours), do: hours
  defp template_row_hours(_project, card_hours), do: card_hours

  attr :id, :string, default: "calendar-day-modal"
  attr :show, :boolean, default: false
  attr :on_close, :string, default: nil
  attr :date, :any, default: nil
  attr :status, :string, default: "nuevo", values: @statuses
  attr :weekday_label, :string, default: nil
  attr :month_label, :string, default: nil
  attr :status_label, :string, default: nil
  attr :entries, :list, default: []
  attr :total_hours, :float, default: 0.0
  attr :goal_hours, :float, default: 8.0
  attr :read_only, :boolean, default: false
  attr :class, :any, default: nil
  attr :rest, :global

  def bt_calendar_day_modal(assigns) do
    total = assigns.total_hours || 0.0
    goal = assigns.goal_hours || 8.0
    progress = min(100.0, total / goal * 100)
    goal_reached = total >= goal
    hours_to_goal = Float.round(max(0.0, goal - total), 1)

    assigns =
      assigns
      |> assign(:progress_pct, Float.round(progress, 1))
      |> assign(:goal_reached, goal_reached)
      |> assign(:hours_to_goal, hours_to_goal)
      |> assign(:status_label, assigns.status_label || status_label(assigns.status))
      |> assign(:progress_summary, progress_summary(goal_reached, hours_to_goal))

    ~H"""
    <div
      :if={@show && @date}
      id={@id}
      class={["bt-calendar-day-modal", @class]}
      data-testid="calendar-day-modal"
      data-day-status={@status}
      {@rest}
    >
      <button
        type="button"
        class="bt-calendar-day-modal__backdrop"
        phx-click={@on_close}
        aria-label="Close day editor"
      />
      <div
        class="bt-calendar-day-modal__panel"
        role="dialog"
        aria-modal="true"
        aria-labelledby={"#{@id}-title"}
      >
        <div class={["bt-calendar-day-modal__shell", modal_status_class(@status)]}>
          <aside class="bt-calendar-day-modal__aside">
            <div class="bt-calendar-day-modal__aside-top">
              <p class="bt-calendar-day-modal__day-number">{@date.day}</p>
              <div class="bt-calendar-day-modal__day-meta">
                <p class="bt-calendar-day-modal__weekday">{@weekday_label}</p>
                <p class="bt-calendar-day-modal__month">{@month_label}</p>
              </div>
            </div>
            <div class="bt-calendar-day-modal__aside-bottom">
              <div class="bt-calendar-day-modal__hours">
                <span class="bt-calendar-day-modal__hours-value">{Float.round(@total_hours * 1.0, 1)}</span>
                <span class="bt-calendar-day-modal__hours-unit">h</span>
              </div>
              <p class="bt-calendar-day-modal__status">{String.upcase(@status_label)}</p>
              <div class="bt-calendar-day-modal__progress" aria-hidden="true">
                <div class="bt-calendar-day-modal__progress-fill" style={"width: #{@progress_pct}%"} />
              </div>
              <p class="bt-calendar-day-modal__progress-label">{@progress_summary}</p>
            </div>
          </aside>

          <section class="bt-calendar-day-modal__content">
            <div class="bt-calendar-day-modal__toolbar">
              <div>
                <p class="bt-calendar-day-modal__kicker">Activity</p>
                <h2 class="bt-calendar-day-modal__title" id={"#{@id}-title"}>Logged hours</h2>
              </div>
              <button
                :if={!@read_only}
                type="button"
                class="bt-calendar-day-modal__add bt-button bt-button--secondary bt-button--sm"
              >
                <span class="bt-icon" aria-hidden="true">+</span> New
              </button>
            </div>

            <div class="bt-calendar-day-modal__entries">
              <%= if @entries == [] do %>
                <div class="bt-calendar-day-modal__empty">
                  <p class="bt-calendar-day-modal__empty-title">No entries yet</p>
                  <p class="bt-calendar-day-modal__empty-copy">
                    <%= if @read_only do %>
                      This day cannot be edited.
                    <% else %>
                      Add a project line to log hours for this day.
                    <% end %>
                  </p>
                </div>
              <% else %>
                <article :for={entry <- @entries} class="bt-calendar-day-modal__entry">
                  <div class="bt-calendar-day-modal__entry-main">
                    <p class="bt-calendar-day-modal__entry-project">{entry[:project_name] || entry["project_name"]}</p>
                    <p class="bt-calendar-day-modal__entry-type">{entry[:input_type] || entry["input_type"] || "Billable"}</p>
                  </div>
                  <div class="bt-calendar-day-modal__entry-meta">
                    <span class="bt-calendar-day-modal__entry-hours">{entry[:hours] || entry["hours"]}h</span>
                    <span :if={entry[:status_label] || entry["status_label"]} class="bt-calendar-day-modal__entry-status">
                      {entry[:status_label] || entry["status_label"]}
                    </span>
                  </div>
                </article>
              <% end %>
            </div>

            <div class="bt-calendar-day-modal__footer">
              <button type="button" class="bt-button bt-button--ghost bt-button--sm" phx-click={@on_close}>
                Close
              </button>
              <button :if={!@read_only} type="button" class="bt-button bt-button--primary bt-button--sm">
                Save draft
              </button>
            </div>
          </section>
        </div>
      </div>
    </div>
    """
  end

  defp status_label("nuevo"), do: "New"
  defp status_label("imputado"), do: "Draft"
  defp status_label("completado"), do: "Complete"
  defp status_label("liberado"), do: "Sent"
  defp status_label("aprobado"), do: "Approved"
  defp status_label("rechazado"), do: "Rejected"
  defp status_label("festivo"), do: "Holiday"
  defp status_label("vacaciones"), do: "Vacation"
  defp status_label("no-laborable"), do: "Non-working"
  defp status_label(_), do: "Day"

  defp progress_summary(true, _hours_to_goal), do: "Daily goal reached"
  defp progress_summary(false, hours), do: "#{hours}h to reach 8h"
end
