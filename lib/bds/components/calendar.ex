defmodule Bds.Components.Calendar do
  @moduledoc """
  Timesheet calendar components (`bt-calendar-*`) for Tempo-style month views.
  """
  use Phoenix.Component
  use Gettext, backend: Bds.Gettext

  import Bds.Components, only: [bt_input: 1]
  import Bds.Components.CatalogUi, only: [bt_icon_button: 1]

  @entry_input_types ~w(Billable Non-billable Absence)

  @statuses ~w(
    nuevo imputado completado liberado aprobado rechazado festivo vacaciones no-laborable
  )

  @status_icons %{
    "imputado" => "◐",
    "completado" => "●",
    "liberado" => "↑",
    "aprobado" => "✓",
    "rechazado" => "✕"
  }

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
        aria-label={gettext("Close templates panel")}
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
  attr :title, :string, default: nil
  attr :on_close, :any, default: nil
  attr :rest, :global
  slot :inner_block, required: true
  slot :actions

  def bt_calendar_templates_panel(assigns) do
    assigns = assign_new(assigns, :title, fn -> gettext("Templates") end)

    ~H"""
    <div class={["bt-calendar-templates h-full min-h-0 flex flex-col", @class]} {@rest}>
      <div class="bt-calendar-templates__header">
        <button
          :if={@on_close}
          type="button"
          phx-click={@on_close}
          class="bt-calendar-templates__close bt-icon-button"
          aria-label={gettext("Close panel")}
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

  attr :template_id, :string, default: nil
  attr :name, :string, default: ""
  attr :show_title, :boolean, default: true
  attr :hours, :any, default: nil
  attr :projects, :list, default: []
  attr :on_apply, :string, default: nil, doc: "LiveView event when the card is clicked to apply the template"
  attr :class, :any, default: nil
  attr :rest, :global

  def bt_calendar_template_card(assigns) do
    assigns =
      assigns
      |> assign(:project_rows, template_project_rows(assigns.projects, assigns.hours))
      |> assign(:clickable?, is_binary(assigns.on_apply))

    ~H"""
    <%= if @clickable? do %>
      <button
        type="button"
        class={[
          "bt-calendar-template-card bt-calendar-template-card--clickable",
          @class
        ]}
        phx-click={@on_apply}
        phx-value-id={@template_id}
        aria-label={gettext("Apply template %{name}", name: @name)}
        {@rest}
      >
        <.calendar_template_card_body
          name={@name}
          show_title={@show_title}
          project_rows={@project_rows}
        />
      </button>
    <% else %>
      <article class={["bt-calendar-template-card", @class]} {@rest}>
        <.calendar_template_card_body
          name={@name}
          show_title={@show_title}
          project_rows={@project_rows}
        />
      </article>
    <% end %>
    """
  end

  attr :name, :string, default: ""
  attr :show_title, :boolean, default: true
  attr :project_rows, :list, required: true

  defp calendar_template_card_body(assigns) do
    ~H"""
    <div class="bt-calendar-template-card__row">
      <div class="bt-calendar-template-card__body min-w-0 flex-1">
        <p :if={@show_title} class="bt-calendar-template-card__name">{@name}</p>
        <div :if={@project_rows != []} class="bt-calendar-day__projects">
          <div :for={row <- @project_rows} class="bt-calendar-day__project">
            <span class="bt-calendar-day__project-name">{row.name}</span>
            <span :if={row.hours != nil} class="bt-calendar-day__project-hours">{row.hours}h</span>
          </div>
        </div>
      </div>
    </div>
    """
  end

  attr :class, :any, default: nil
  attr :month_label, :string, default: nil
  attr :rest, :global
  slot :left
  slot :center
  slot :right
  slot :far_right

  def bt_calendar_toolbar(assigns) do
    ~H"""
    <div class={["bt-calendar-toolbar", @class]} {@rest}>
      <div class="bt-calendar-toolbar__row">
        <div class="bt-calendar-toolbar__start">{render_slot(@left)}</div>
        <div class="bt-calendar-toolbar__center">
          {render_slot(@center)}
          <span :if={@month_label && render_slot(@center) == []} class="bt-calendar-toolbar__month">
            {@month_label}
          </span>
        </div>
        <div class="bt-calendar-toolbar__end">{render_slot(@right)}</div>
        <div
          :if={render_slot(@far_right) != []}
          class="bt-calendar-toolbar__far-end"
        >
          {render_slot(@far_right)}
        </div>
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
    labels = assigns.labels || calendar_weekday_labels()
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
  attr :selected, :boolean, default: false
  attr :class, :any, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def bt_calendar_month_cell(assigns) do
    ~H"""
    <div
      class={[
        "bt-calendar-month-grid__cell",
        @weekend && "bt-calendar-month-grid__cell--weekend",
        @selected && "bt-calendar-month-grid__cell--selected",
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
  attr :selectable, :boolean, default: false
  attr :date, :any, default: nil
  attr :on_select, :string, default: nil
  attr :on_open, :string, default: nil
  attr :projects, :list, default: []
  attr :grid_row, :integer, default: nil
  attr :grid_col, :integer, default: nil
  attr :type, :string, default: "button"
  attr :class, :any, default: nil
  attr :rest, :global

  def bt_calendar_day(assigns) do
    cond do
      assigns.outside ->
        ~H"""
        <div
          class={[
            "bt-calendar-day bt-calendar-day--outside bt-calendar-day--no-laborable w-full h-full",
            @class
          ]}
          {@rest}
        />
        """

      assigns.selectable ->
        date_iso = calendar_day_iso(assigns.date, assigns.day)

        assigns =
          assigns
          |> assign(:date_iso, date_iso)
          |> assign(:day_body, calendar_day_body(assigns))

        ~H"""
        <div
          class={[
            "bt-calendar-day bt-calendar-day--selectable w-full h-full text-left",
            status_class(@status),
            @today && "bt-calendar-day--today",
            @selected && "bt-calendar-day--selected",
            @class
          ]}
          data-calendar-day={@date_iso}
          data-calendar-selectable="true"
          data-calendar-grid-row={@grid_row}
          data-calendar-grid-col={@grid_col}
          tabindex="0"
          phx-click={@on_select}
          phx-value-date={@date_iso}
          {@rest}
        >
          {@day_body}
          <button
            :if={@on_open}
            type="button"
            class="bt-calendar-day__open bt-button bt-button--ghost bt-button--sm"
            data-calendar-day-open
            phx-click={@on_open}
            phx-value-date={@date_iso}
            aria-label={gettext("Open day")}
          >
            Open
          </button>
        </div>
        """

      true ->
        assigns = assign(assigns, :day_body, calendar_day_body(assigns))

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
          {@day_body}
        </button>
        """
    end
  end

  defp calendar_day_body(assigns) do
    ~H"""
    <span class="bt-calendar-day__number">{@day}</span>
    <div class="bt-calendar-day__content">
      <%= if @projects != [] do %>
        <div class="bt-calendar-day__projects">
          <%= for project <- Enum.take(@projects, 2) do %>
            <div class={["bt-calendar-day__project", project_status_class(project)]}>
              <span
                :if={project_status(project)}
                class="bt-calendar-day__project-status"
                title={project_status_label(project)}
                aria-label={project_status_label(project)}
              />
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
    """
  end

  defp calendar_day_iso(%Date{} = date, _day), do: Date.to_iso8601(date)
  defp calendar_day_iso(iso, _day) when is_binary(iso), do: iso
  defp calendar_day_iso(_, day), do: to_string(day)

  attr :items, :list, required: true
  attr :id, :string, default: nil
  attr :class, :any, default: nil
  attr :label, :string, default: nil
  attr :rest, :global

  def bt_calendar_legend(assigns) do
    assigns = assign_new(assigns, :label, fn -> gettext("Calendar status legend") end)

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
          <span>{legend_item_label(item)}</span>
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

  defp project_status(%{status: status}) when is_binary(status), do: status
  defp project_status(%{"status" => status}) when is_binary(status), do: status
  defp project_status(_), do: nil

  defp project_status_class(project) do
    case project_status(project) do
      status when is_binary(status) -> "bt-calendar-day__project--#{normalize_status(status)}"
      _ -> nil
    end
  end

  defp project_status_label(project) do
    case project_status(project) do
      status when is_binary(status) -> calendar_status_label(status)
      _ -> nil
    end
  end

  defp entry_status(%{status: status}) when is_binary(status), do: status
  defp entry_status(%{"status" => status}) when is_binary(status), do: status
  defp entry_status(_), do: nil

  defp entry_status_class(entry) do
    case entry_status(entry) do
      status when is_binary(status) ->
        "bt-calendar-day-modal__entry-status--#{normalize_status(status)}"

      _ ->
        nil
    end
  end

  defp entry_status_label(entry) do
    case entry[:status_label] || entry["status_label"] do
      label when is_binary(label) and label != "" -> label
      _ -> calendar_status_label(entry_status(entry) || "")
    end
  end

  defp entry_status_icon(entry) do
    entry_status(entry)
    |> then(&Map.get(@status_icons, &1, ""))
  end

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
  attr :entry_form, :any, default: nil
  attr :editing_entry_id, :string, default: nil
  attr :input_types, :list, default: @entry_input_types
  slot :entry_project
  slot :footer_actions
  attr :on_add_entry, :string, default: nil
  attr :on_edit_entry, :string, default: nil
  attr :on_delete_entry, :string, default: nil
  attr :on_cancel_entry, :string, default: nil
  attr :on_save_entry, :string, default: nil
  attr :on_validate_entry, :string, default: nil
  attr :on_hours_preset, :string, default: nil, doc: "phx-click event to set hours (phx-value-hours)"
  attr :on_save, :string, default: nil
  attr :class, :any, default: nil
  attr :rest, :global

  def bt_calendar_day_modal(assigns) do
    total = assigns.total_hours || 0.0
    goal = assigns.goal_hours || 8.0
    progress = min(100.0, total / goal * 100)
    goal_reached = total >= goal
    hours_to_goal = Float.round(max(0.0, goal - total), 1)

    weekday_label =
      assigns.weekday_label ||
        (assigns.date && calendar_modal_weekday_label(assigns.date))

    month_label =
      assigns.month_label ||
        (assigns.date && calendar_modal_month_label(assigns.date))

    assigns =
      assigns
      |> assign(:weekday_label, weekday_label)
      |> assign(:month_label, month_label)
      |> assign(:progress_pct, Float.round(progress, 1))
      |> assign(:goal_reached, goal_reached)
      |> assign(:hours_to_goal, hours_to_goal)
      |> assign(:progress_summary, progress_summary(goal_reached, hours_to_goal))
      |> assign(:editing?, !is_nil(assigns.entry_form))
      |> assign(:entry_form_id, "#{assigns.id}-entry-form")

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
        aria-label={gettext("Close day editor")}
      />
      <div
        class="bt-calendar-day-modal__panel"
        role="dialog"
        aria-modal="true"
        aria-label={gettext("Day %{day}", day: @date.day)}
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
              <div class="bt-calendar-day-modal__progress" aria-hidden="true">
                <div class="bt-calendar-day-modal__progress-fill" style={"width: #{@progress_pct}%"} />
              </div>
              <p class="bt-calendar-day-modal__progress-label">{@progress_summary}</p>
            </div>
          </aside>

          <section class="bt-calendar-day-modal__content">
            <div class="bt-calendar-day-modal__entries">
              <div
                :if={!@read_only && !@editing? && @on_add_entry}
                class="bt-calendar-day-modal__entries-top"
              >
                <button
                  type="button"
                  class="bt-calendar-day-modal__add bt-button bt-button--secondary bt-button--sm"
                  phx-click={@on_add_entry}
                >
                  <span class="bt-icon" aria-hidden="true">+</span> {gettext("New")}
                </button>
              </div>
              <.form
                :if={@entry_form && @on_save_entry}
                for={@entry_form}
                id={@entry_form_id}
                class="bt-calendar-day-modal__editor"
                phx-submit={@on_save_entry}
                phx-change={@on_validate_entry}
              >
                <p class="bt-calendar-day-modal__editor-title">
                  {if @editing_entry_id == "new",
                    do: gettext("Add time entry"),
                    else: gettext("Edit time entry")}
                </p>
                <div class="bt-calendar-day-modal__editor-fields">
                  <div
                    :if={render_slot(@entry_project) != []}
                    class="bt-calendar-day-modal__editor-project"
                  >
                    {render_slot(@entry_project)}
                  </div>
                  <.bt_input
                    :if={render_slot(@entry_project) == []}
                    field={@entry_form[:project_name]}
                    type="text"
                    label={gettext("Project")}
                    placeholder={gettext("Search or type a project")}
                    autocomplete="off"
                    required
                  />
                  <div class="bt-calendar-day-modal__editor-row">
                    <div class="bt-calendar-day-modal__editor-hours">
                      <div class="bt-calendar-day-modal__editor-hours-input">
                        <.bt_input
                          field={@entry_form[:hours]}
                          type="number"
                          label={gettext("Hours")}
                          step="0.5"
                          min="0.5"
                          max="24"
                          required
                        />
                      </div>
                      <div :if={@on_hours_preset} class="bt-calendar-day-modal__editor-hours-presets">
                        <button
                          :for={{label, hours} <- hour_preset_buttons()}
                          type="button"
                          class="bt-button bt-button--secondary bt-button--sm"
                          phx-click={@on_hours_preset}
                          phx-value-hours={hours}
                          aria-label={gettext("Set %{hours} hours", hours: hours)}
                        >
                          {label}
                        </button>
                      </div>
                    </div>
                    <div class="bt-calendar-day-modal__editor-type">
                      <.bt_input
                        field={@entry_form[:input_type]}
                        type="select"
                        label={gettext("Type")}
                        options={@input_types}
                      />
                    </div>
                  </div>
                </div>
                <div class="bt-calendar-day-modal__editor-actions">
                  <button
                    :if={@on_cancel_entry}
                    type="button"
                    class="bt-button bt-button--ghost bt-button--sm"
                    phx-click={@on_cancel_entry}
                  >
                    {gettext("Cancel")}
                  </button>
                  <button type="submit" class="bt-button bt-button--primary bt-button--sm">
                    {if @editing_entry_id == "new", do: gettext("Add entry"), else: gettext("Update entry")}
                  </button>
                </div>
              </.form>

              <%= if @entries == [] && !@editing? do %>
                <div class="bt-calendar-day-modal__empty">
                  <p class="bt-calendar-day-modal__empty-title">{gettext("No entries yet")}</p>
                  <p class="bt-calendar-day-modal__empty-copy">
                    <%= if @read_only do %>
                      {gettext("This day cannot be edited.")}
                    <% else %>
                      {gettext("Add a project line to log hours for this day.")}
                    <% end %>
                  </p>
                </div>
              <% else %>
                <article
                  :for={entry <- @entries}
                  :if={entry_id(entry) != @editing_entry_id}
                  class="bt-calendar-day-modal__entry"
                >
                  <div class="bt-calendar-day-modal__entry-main">
                    <div class="bt-calendar-day-modal__entry-heading">
                      <p class="bt-calendar-day-modal__entry-project">{entry[:project_name] || entry["project_name"]}</p>
                      <span
                        :if={entry_status(entry)}
                        class={["bt-calendar-day-modal__entry-status", entry_status_class(entry)]}
                      >
                        <span class="bt-calendar-day-modal__entry-status-icon" aria-hidden="true">
                          {entry_status_icon(entry)}
                        </span>
                        {entry_status_label(entry)}
                      </span>
                    </div>
                    <p class="bt-calendar-day-modal__entry-type">{entry[:input_type] || entry["input_type"] || "Billable"}</p>
                  </div>
                  <span class="bt-calendar-day-modal__entry-hours">{entry[:hours] || entry["hours"]}h</span>
                  <div :if={!@read_only && @on_edit_entry} class="bt-calendar-day-modal__entry-actions">
                    <.bt_icon_button
                      class="bt-calendar-day-modal__entry-action"
                      label={gettext("Edit entry")}
                      phx-click={@on_edit_entry}
                      phx-value-id={entry_id(entry)}
                    >
                      <.calendar_day_modal_icon name="pencil" />
                    </.bt_icon_button>
                    <.bt_icon_button
                      :if={@on_delete_entry}
                      class="bt-calendar-day-modal__entry-action"
                      label={gettext("Delete entry")}
                      phx-click={@on_delete_entry}
                      phx-value-id={entry_id(entry)}
                      data-confirm={gettext("Remove this time entry?")}
                    >
                      <.calendar_day_modal_icon name="trash" />
                    </.bt_icon_button>
                  </div>
                </article>
              <% end %>
            </div>

            <div :if={render_slot(@footer_actions) != []} class="bt-calendar-day-modal__footer-actions px-4 pb-2">
              {render_slot(@footer_actions)}
            </div>
            <div class="bt-calendar-day-modal__footer">
              <button type="button" class="bt-button bt-button--ghost bt-button--sm" phx-click={@on_close}>
                {gettext("Close")}
              </button>
              <button
                :if={!@read_only && @on_save && !@editing?}
                type="button"
                class="bt-button bt-button--primary bt-button--sm"
                phx-click={@on_save}
              >
                {gettext("Save draft")}
              </button>
            </div>
          </section>
        </div>
      </div>
    </div>
    """
  end

  @doc """
  Localized abbreviated weekday for the day modal aside (e.g. `"Thu"`).
  """
  def calendar_modal_weekday_label(%Date{} = date) do
    calendar_weekday_labels()
    |> Enum.at(Date.day_of_week(date) - 1)
  end

  @doc """
  Localized abbreviated weekday labels for the calendar header row (Mon–Sun).
  """
  def calendar_weekday_labels do
    [
      gettext("Mon"),
      gettext("Tue"),
      gettext("Wed"),
      gettext("Thu"),
      gettext("Fri"),
      gettext("Sat"),
      gettext("Sun")
    ]
  end

  @doc """
  Localized month and year for the day modal aside (e.g. `"June 2026"`).
  """
  def calendar_modal_month_label(%Date{} = date) do
    month = calendar_month_names() |> Enum.at(date.month - 1)
    "#{month} #{date.year}"
  end

  @doc """
  Returns the localized display label for a calendar day/legend `status` slug
  (e.g. `"imputado"`, `"completado"`).
  """
  def calendar_status_label("nuevo"), do: gettext("New")
  def calendar_status_label("imputado"), do: gettext("Draft")
  def calendar_status_label("completado"), do: gettext("Complete")
  def calendar_status_label("liberado"), do: gettext("Sent")
  def calendar_status_label("aprobado"), do: gettext("Approved")
  def calendar_status_label("rechazado"), do: gettext("Rejected")
  def calendar_status_label("festivo"), do: gettext("Holiday")
  def calendar_status_label("vacaciones"), do: gettext("Vacation")
  def calendar_status_label("no-laborable"), do: gettext("Non-working")
  def calendar_status_label(_), do: gettext("Day")

  defp legend_item_label(item) do
    case item[:status] || item["status"] do
      status when is_binary(status) -> calendar_status_label(status)
      _ -> item[:label] || item["label"] || ""
    end
  end

  defp hour_preset_buttons do
    [
      {gettext("1h"), "1"},
      {gettext("2h"), "2"},
      {gettext("4h"), "4"},
      {gettext("8h"), "8"}
    ]
  end

  defp progress_summary(true, _hours_to_goal), do: gettext("Daily goal reached")
  defp progress_summary(false, hours), do: gettext("%{hours}h to reach 8h", hours: hours)

  defp calendar_month_names do
    [
      gettext("January"),
      gettext("February"),
      gettext("March"),
      gettext("April"),
      gettext("May"),
      gettext("June"),
      gettext("July"),
      gettext("August"),
      gettext("September"),
      gettext("October"),
      gettext("November"),
      gettext("December")
    ]
  end

  attr :name, :string, required: true, values: ~w(pencil trash)
  attr :class, :any, default: nil

  def calendar_day_modal_icon(assigns) do
    ~H"""
    <svg
      class={["bt-calendar-day-modal__entry-icon", @class]}
      xmlns="http://www.w3.org/2000/svg"
      fill="none"
      viewBox="0 0 24 24"
      stroke-width="1.5"
      stroke="currentColor"
      aria-hidden="true"
    >
      <%= case @name do %>
        <% "pencil" -> %>
          <path
            stroke-linecap="round"
            stroke-linejoin="round"
            d="m16.862 4.487 1.687-1.688a1.875 1.875 0 1 1 2.652 2.652L10.582 16.07a4.5 4.5 0 0 1-1.897 1.13L6 18l.8-2.685a4.5 4.5 0 0 1 1.13-1.897l8.932-8.931Zm0 0L19.5 7.125M18 14v4.75A2.25 2.25 0 0 1 15.75 21H5.25A2.25 2.25 0 0 1 3 18.75V8.25A2.25 2.25 0 0 1 5.25 6H10"
          />
        <% "trash" -> %>
          <path
            stroke-linecap="round"
            stroke-linejoin="round"
            d="m14.74 9-.346 9m-4.788 0L9.26 9m9.968-3.21c.342.052.682.107 1.022.166m-1.022-.165L18.16 19.673a2.25 2.25 0 0 1-2.244 2.077H8.084a2.25 2.25 0 0 1-2.244-2.077L4.772 5.79m14.456 0a48.108 48.108 0 0 0-3.478-.397m-12 .562c.34-.059.68-.114 1.022-.165m0 0a48.11 48.11 0 0 1 3.478-.397m7.5 0v-.916c0-1.18-.91-2.164-2.09-2.201a51.964 51.964 0 0 0-3.32 0c-1.18.037-2.09 1.022-2.09 2.201v.916m7.5 0a48.667 48.667 0 0 0-7.5 0"
          />
      <% end %>
    </svg>
    """
  end

  defp entry_id(%{id: id}), do: id
  defp entry_id(%{"id" => id}), do: id
  defp entry_id(_), do: nil
end
