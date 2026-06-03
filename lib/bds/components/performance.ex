defmodule Bds.Components.Performance do
  @moduledoc """
  Performance-cycle workspace components (`bt-performance-*`) for briefings,
  evaluations, reported hours, and team review rows.
  """
  use Phoenix.Component
  use Gettext, backend: Bds.Gettext

  import Bds.Components, only: [bt_button: 1]
  import Bds.Components.CatalogUi, only: [bt_icon: 1]

  @rating_classes %{
    "a" => "bt-performance-rating--a",
    "b" => "bt-performance-rating--b",
    "c" => "bt-performance-rating--c",
    "d" => "bt-performance-rating--d"
  }

  @briefing_status_variants %{
    "draft" => "warning",
    "published" => "info",
    "acknowledged" => "success"
  }

  attr :id, :string, default: nil
  attr :class, :any, default: nil
  attr :title, :string, default: nil
  attr :name, :string, required: true
  attr :email, :string, default: nil
  attr :picture, :string, default: nil
  attr :rest, :global

  def bt_performance_evaluator_card(assigns) do
    assigns = assign_new(assigns, :title, fn -> gettext("Evaluator") end)

    ~H"""
    <article
      id={@id}
      class={["bt-performance-card bt-performance-evaluator", @class]}
      {@rest}
    >
      <h2 class="bt-performance-section-title">{@title}</h2>
      <div class="bt-performance-evaluator__row">
        <img
          src={@picture || default_avatar()}
          alt={@name}
          class="bt-performance-evaluator__avatar"
        />
        <div class="min-w-0">
          <p class="bt-performance-evaluator__name truncate">{@name}</p>
          <p :if={@email} class="bt-performance-meta-sub truncate">{@email}</p>
        </div>
      </div>
    </article>
    """
  end

  attr :id, :string, default: nil
  attr :class, :any, default: nil
  attr :title, :string, default: nil
  attr :hours_groups, :list, required: true
  attr :expanded_keys, :any, default: MapSet.new()
  attr :show_all_groups?, :boolean, default: false
  attr :hidden_group_count, :integer, default: 0
  attr :toggle_group_event, :string, default: "toggle_hours_group"
  attr :toggle_more_event, :string, default: "toggle_more_hours_groups"
  attr :empty_message, :string, default: nil
  attr :rest, :global

  def bt_performance_hours_panel(assigns) do
    assigns =
      assigns
      |> assign_new(:title, fn -> gettext("Reported hours") end)
      |> assign_new(:empty_message, fn -> gettext("No reported hours for this scope.") end)

    visible =
      if assigns.show_all_groups? or assigns.hidden_group_count == 0 do
        assigns.hours_groups
      else
        Enum.take(assigns.hours_groups, length(assigns.hours_groups) - assigns.hidden_group_count)
      end

    assigns =
      assigns
      |> assign(:visible_groups, visible)
      |> assign(:expanded?, &MapSet.member?(assigns.expanded_keys, &1))

    ~H"""
    <div id={@id} class={["bt-performance-panel", @class]} {@rest}>
      <div class="bt-performance-panel__inner">
        <div class="bt-performance-panel__header">
          <h3 class="bt-performance-kicker" style="color: var(--bt-color-text-subtle); margin: 0;">
            {@title}
          </h3>
        </div>
        <p :if={@hours_groups == []} class="bt-performance-empty">{@empty_message}</p>
        <ul :if={@hours_groups != []} class="list-none m-0 p-0 divide-y" style="border-color: var(--bt-color-border);">
          <li :for={group <- @visible_groups}>
            <div class="bt-performance-hours-row">
              <button
                type="button"
                phx-click={@toggle_group_event}
                phx-value-key={group.key}
                class="bt-performance-hours-toggle"
              >
                <.bt_icon class={if @expanded?.(group.key), do: "opacity-70", else: "opacity-70"}>
                  {if @expanded?.(group.key), do: "▾", else: "▸"}
                </.bt_icon>
                <span>{group.label}</span>
              </button>
              <span class="bt-performance-hours-pill">{group.total_label}</span>
            </div>
            <ul
              :if={@expanded?.(group.key) && group.projects != []}
              class="bt-performance-hours-projects list-none m-0 p-0"
            >
              <li :for={row <- group.projects} class="bt-performance-hours-project">
                <span class="bt-performance-hours-project__name">{row.project_name}</span>
                <span class="bt-performance-hours-project__owner">{row.project_owner}</span>
                <span class="bt-performance-hours-project__qty">{row.hours_label}</span>
              </li>
            </ul>
          </li>
        </ul>
        <div :if={@hidden_group_count > 0} style="padding-top: var(--bt-space-2);">
          <.bt_button variant="ghost" type="button" phx-click={@toggle_more_event}>
            <%= if @show_all_groups? do %>
              {gettext("Show fewer clients")}
            <% else %>
              {gettext("Show %{count} more clients", count: @hidden_group_count)}
            <% end %>
          </.bt_button>
        </div>
      </div>
    </div>
    """
  end

  attr :id, :string, required: true
  attr :class, :any, default: nil
  attr :status, :string, required: true
  attr :date_label, :string, required: true
  attr :period_name, :string, default: nil
  attr :show_period_chip?, :boolean, default: true
  attr :creator_label, :string, required: true
  attr :role_description, :string, required: true
  attr :objectives, :list, default: []
  attr :evaluation, :map, default: nil
  attr :ack_state, :atom, default: :hidden, values: [:hidden, :pending, :acknowledged]
  attr :default_expanded?, :boolean, default: false
  attr :draft_label, :string, default: nil
  attr :rest, :global
  slot :actions

  def bt_performance_briefing_card(assigns) do
    assigns = assign_new(assigns, :draft_label, fn -> gettext("Draft · only visible to you") end)

    has_evaluation = is_map(assigns.evaluation) and map_size(assigns.evaluation) > 0
    assigns = assign(assigns, :has_evaluation, has_evaluation)

    ~H"""
    <article
      id={@id}
      class={[
        "bt-performance-card",
        @status == "draft" && "bt-performance-card--draft",
        @class
      ]}
      data-briefing-status={@status}
      {@rest}
    >
      <header class="bt-performance-card__header">
        <div class="min-w-0" style="display: grid; gap: var(--bt-space-2);">
          <p :if={@status == "draft"} class="bt-performance-kicker">{@draft_label}</p>
          <div class="bt-performance-meta-row">
            <.bt_icon>📄</.bt_icon>
            <span class="bt-performance-meta-row__date">{@date_label}</span>
            <span :if={@show_period_chip? && @period_name} class="bt-performance-chip">
              {@period_name}
            </span>
            <.bt_performance_ack_chip :if={@ack_state != :hidden} state={@ack_state} />
          </div>
          <p class="bt-performance-meta-sub">{gettext("Created by %{name}", name: @creator_label)}</p>
        </div>
        <div :if={render_slot(@actions) != []} class="bt-performance-actions">
          {render_slot(@actions)}
        </div>
      </header>
      <div class="bt-performance-card__body">
        <p style="margin: 0; white-space: pre-wrap; font-size: var(--bt-font-size-sm); color: var(--bt-color-text-muted);">
          {@role_description}
        </p>
        <div :if={@objectives != []} style="display: grid; gap: var(--bt-space-2);">
          <h3 class="bt-performance-section-title" style="font-size: var(--bt-font-size-sm);">
            <%= if @has_evaluation do %>
              {gettext("Objectives and evaluator assessment")}
            <% else %>
              {gettext("Objectives")}
            <% end %>
          </h3>
          <details class="bt-performance-objectives" open={@default_expanded?}>
            <summary>{gettext("Objectives")}</summary>
            <ul class="list-none m-0 p-0" style="margin-top: var(--bt-space-3); display: grid; gap: var(--bt-space-2);">
              <li :for={obj <- @objectives} class="bt-performance-objective">
                <div class="bt-performance-objective__head">
                  <span style="font-weight: 600;">{obj.title}</span>
                  <span class="bt-performance-chip">{obj.weight}%</span>
                  <span
                    :if={obj[:rating_label]}
                    class={[
                      "bt-performance-rating",
                      rating_class(obj[:rating])
                    ]}
                  >
                    {obj.rating_label}
                  </span>
                </div>
                <p :if={obj[:description]} class="bt-performance-objective__desc">{obj.description}</p>
              </li>
            </ul>
          </details>
        </div>
        <div :if={@has_evaluation} class="bt-performance-evaluation">
          <div style="display: flex; flex-wrap: wrap; align-items: flex-start; justify-content: space-between; gap: var(--bt-space-3);">
            <div style="display: grid; gap: var(--bt-space-1);">
              <div class="bt-performance-meta-row">
                <.bt_icon>✦</.bt_icon>
                <span class="bt-performance-meta-row__date">{@evaluation.date_label}</span>
              </div>
              <p class="bt-performance-meta-sub">
                {gettext("Evaluated by %{name}", name: @evaluation.creator_label)}
              </p>
              <p class="bt-performance-kicker" style="color: var(--bt-color-text-subtle);">
                {gettext("Overall assessment")}
              </p>
            </div>
            <span class={["bt-performance-rating", rating_class(@evaluation.rating)]}>
              {@evaluation.rating_label}
            </span>
          </div>
          <p style="margin: 0; white-space: pre-wrap; font-size: var(--bt-font-size-sm); color: var(--bt-color-text-muted);">
            {@evaluation.rationale}
          </p>
          <details class="bt-performance-objectives" open={@default_expanded?} style="background: var(--bt-color-surface-soft);">
            <summary>{gettext("Strengths, weaknesses, recommendations")}</summary>
            <div style="margin-top: var(--bt-space-3); display: grid; gap: var(--bt-space-2); font-size: var(--bt-font-size-sm); color: var(--bt-color-text-muted);">
              <p :if={@evaluation.strengths} style="margin: 0;">
                <strong style="display: block; margin-bottom: 0.15rem;">{gettext("Strengths")}</strong>
                <span style="white-space: pre-wrap;">{@evaluation.strengths}</span>
              </p>
              <p :if={@evaluation.weaknesses} style="margin: 0;">
                <strong style="display: block; margin-bottom: 0.15rem;">{gettext("Weaknesses")}</strong>
                <span style="white-space: pre-wrap;">{@evaluation.weaknesses}</span>
              </p>
              <p :if={@evaluation.recommendations} style="margin: 0;">
                <strong style="display: block; margin-bottom: 0.15rem;">{gettext("Recommendations")}</strong>
                <span style="white-space: pre-wrap;">{@evaluation.recommendations}</span>
              </p>
            </div>
          </details>
        </div>
      </div>
    </article>
    """
  end

  attr :state, :atom, required: true, values: [:pending, :acknowledged]

  def bt_performance_ack_chip(assigns) do
    ~H"""
    <span class={[
      "bt-performance-ack",
      @state == :acknowledged && "bt-performance-ack--done",
      @state == :pending && "bt-performance-ack--pending"
    ]}>
      <.bt_icon>{if @state == :acknowledged, do: "✓", else: "◷"}</.bt_icon>
      <span>
        {if @state == :acknowledged,
          do: gettext("Acknowledged"),
          else: gettext("Awaiting acknowledgement")}
      </span>
    </span>
    """
  end

  attr :id, :string, default: nil
  attr :class, :any, default: nil
  attr :name, :string, required: true
  attr :email, :string, default: nil
  attr :picture, :string, default: nil
  attr :category, :string, default: nil
  attr :project_label, :string, default: nil
  attr :hours_label, :string, default: nil
  attr :no_hours_message, :string, default: nil
  attr :delegator_name, :string, default: nil
  attr :show_delegator?, :boolean, default: false
  attr :briefing_date_label, :string, default: nil
  attr :briefing_status_label, :string, default: nil
  attr :briefing_status, :string, default: nil
  attr :rating, :string, default: nil
  attr :rating_label, :string, default: nil
  attr :rest, :global
  slot :actions

  def bt_performance_team_card(assigns) do
    status_variant = Map.get(@briefing_status_variants, assigns.briefing_status || "", "info")

    assigns =
      assigns
      |> assign_new(:no_hours_message, fn ->
        gettext("No reported hours in this period for this person.")
      end)
      |> assign(:status_variant, status_variant)
      |> assign(:rating_class, rating_class(assigns.rating))

    ~H"""
    <article
      id={@id}
      class={["bt-performance-card bt-performance-team-card", @class]}
      {@rest}
    >
      <div class="bt-performance-team-card__main">
        <img
          src={@picture || default_avatar()}
          alt={@name}
          class="bt-performance-evaluator__avatar bt-performance-evaluator__avatar--sm"
        />
        <div class="min-w-0" style="display: grid; gap: var(--bt-space-1);">
          <div style="display: flex; min-width: 0; align-items: center; gap: var(--bt-space-2);">
            <span style="font-size: var(--bt-font-size-sm); font-weight: 600; overflow: hidden; text-overflow: ellipsis;">
              {@name}
            </span>
            <span :if={@category} class="bt-performance-chip truncate" style="max-width: 14rem;">
              {@category}
            </span>
          </div>
          <p :if={@email} class="bt-performance-meta-sub truncate">{@email}</p>
          <div :if={@project_label} style="display: flex; flex-wrap: wrap; align-items: center; gap: var(--bt-space-2); font-size: var(--bt-font-size-xs);">
            <span style="font-weight: 600; color: var(--bt-color-text);">{@project_label}</span>
            <span :if={@hours_label} class="bt-performance-hours-pill">{@hours_label}</span>
          </div>
          <p :if={!@project_label} class="bt-performance-empty" style="font-size: var(--bt-font-size-xs);">
            {@no_hours_message}
          </p>
        </div>
      </div>
      <div class="bt-performance-team-card__aside">
        <div :if={@show_delegator? && @delegator_name} class="bt-performance-team-card__delegation">
          <span>{gettext("Delegated by")}</span>
          <strong>{@delegator_name}</strong>
        </div>
        <div :if={@briefing_date_label} style="display: flex; flex-wrap: wrap; align-items: center; justify-content: flex-end; gap: var(--bt-space-2);">
          <span style="font-size: var(--bt-font-size-sm); font-weight: 600; color: var(--bt-color-primary);">
            {gettext("Briefing on %{date}", date: @briefing_date_label)}
          </span>
          <span :if={@briefing_status_label} class={"bt-status bt-status--#{@status_variant}"}>
            {@briefing_status_label}
          </span>
          <span :if={@rating_label} class={["bt-performance-rating", @rating_class]}>
            {@rating_label}
          </span>
        </div>
        <div :if={!@briefing_date_label && render_slot(@actions) != []} class="bt-performance-actions">
          {render_slot(@actions)}
        </div>
      </div>
    </article>
    """
  end

  @doc false
  def briefing_ack_state(%{acknowledged_at: acknowledged_at}) when not is_nil(acknowledged_at),
    do: :acknowledged

  def briefing_ack_state(%{status: "draft"}), do: :hidden
  def briefing_ack_state(_), do: :pending

  @doc false
  def hours_group_attrs(groups, format_hours) when is_function(format_hours, 1) do
    Enum.map(groups, fn group ->
      %{
        key: group.key,
        label: group.label,
        total_label: format_hours.(group.total_hours),
        projects:
          Enum.map(group.projects, fn row ->
            %{
              project_name: row.project_name || "—",
              project_owner: row.project_owner,
              hours_label: format_hours.(row.posted_quantity)
            }
          end)
      }
    end)
  end

  @doc false
  def objective_attrs(objectives) do
    Enum.map(objectives, fn obj ->
      rating = Map.get(obj, :rating)

      %{
        title: obj.title,
        weight: obj.weight,
        description: Map.get(obj, :description),
        rating: rating,
        rating_label: rating_label(rating)
      }
    end)
  end

  @doc false
  def evaluation_attrs(nil), do: nil

  def evaluation_attrs(eval) do
    %{
      date_label: eval.date_label,
      creator_label: eval.creator_label,
      rating: eval.rating,
      rating_label: eval.rating_label,
      rationale: eval.rationale,
      strengths: Map.get(eval, :strengths),
      weaknesses: Map.get(eval, :weaknesses),
      recommendations: Map.get(eval, :recommendations)
    }
  end

  defp rating_class(nil), do: nil
  defp rating_class(rating) when is_binary(rating), do: Map.get(@rating_classes, String.downcase(rating))

  defp rating_label(nil), do: nil
  defp rating_label("a"), do: "A"
  defp rating_label("b"), do: "B"
  defp rating_label("c"), do: "C"
  defp rating_label("d"), do: "D"
  defp rating_label(other) when is_binary(other), do: String.upcase(other)

  defp default_avatar, do: "https://www.gravatar.com/avatar/?d=mp"
end
