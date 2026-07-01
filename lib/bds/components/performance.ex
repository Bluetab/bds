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

  @completion_classes %{
    "no" => "bt-performance-completion--no",
    "partial" => "bt-performance-completion--partial",
    "total" => "bt-performance-completion--total"
  }

  attr :id, :string, default: nil
  attr :class, :any, default: nil
  attr :name, :string, required: true
  attr :email, :string, default: nil
  attr :picture, :string, default: nil
  attr :rest, :global

  def bt_performance_evaluator_card(assigns) do
    ~H"""
    <article
      id={@id}
      class={["bt-performance-card bt-performance-evaluator", @class]}
      {@rest}
    >
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
        <div :if={@objectives != []} class="bt-performance-objectives-block">
          <h3 class="bt-performance-section-title bt-performance-section-title--sm">
            <%= if @has_evaluation do %>
              {gettext("Objectives and evaluator assessment")}
            <% else %>
              {gettext("Objectives")}
            <% end %>
          </h3>
          <div class="bt-performance-objective-list">
            <details
              :for={obj <- @objectives}
              class="bt-performance-objective-row"
              open={@default_expanded?}
            >
              <summary class="bt-performance-objective-row__summary">
                <div class="bt-performance-objective-row__leading">
                  <span class="bt-performance-objective-row__index">{obj.index}</span>
                  <span :if={obj[:category]} class="bt-performance-chip bt-performance-chip--category">
                    {obj.category}
                  </span>
                  <span class="bt-performance-objective-row__chevron" aria-hidden="true">›</span>
                  <span class="bt-performance-objective-row__title">{obj.title}</span>
                </div>
                <div class="bt-performance-objective-row__trailing">
                  <span
                    :if={obj[:completion_label]}
                    class={[
                      "bt-performance-rating bt-performance-rating--compact",
                      completion_class(obj[:completion])
                    ]}
                  >
                    {obj.completion_label}
                  </span>
                  <span class="bt-performance-objective-row__weight">{obj.weight_share_label}</span>
                </div>
              </summary>
              <div
                :if={obj[:description] || obj[:evaluator_comment]}
                class="bt-performance-objective-row__body"
              >
                <p :if={obj[:description]} class="bt-performance-objective__desc">{obj.description}</p>
                <p :if={obj[:evaluator_comment]} class="bt-performance-objective-row__comment">
                  {obj.evaluator_comment}
                </p>
              </div>
            </details>
          </div>
        </div>
        <div :if={@has_evaluation} class="bt-performance-evaluation">
          <div class="bt-performance-evaluation__header">
            <div class="bt-performance-evaluation__meta">
              <div class="bt-performance-meta-row">
                <.bt_icon>✦</.bt_icon>
                <span class="bt-performance-meta-row__date">{@evaluation.date_label}</span>
                <.bt_performance_ack_chip
                  :if={@evaluation[:ack_state] != :hidden}
                  state={@evaluation.ack_state}
                  date_label={@evaluation[:ack_date_label]}
                />
              </div>
              <p class="bt-performance-meta-sub">
                {gettext("Evaluated by %{name}", name: @evaluation.creator_label)}
              </p>
              <p class="bt-performance-kicker bt-performance-kicker--subtle">
                {gettext("Overall assessment")}
              </p>
            </div>
            <span class={[
              "bt-performance-rating bt-performance-rating--overall",
              rating_class(@evaluation.rating)
            ]}>
              {@evaluation.rating_label}
            </span>
          </div>
          <p class="bt-performance-evaluation__rationale">
            {@evaluation.rationale || "—"}
          </p>
          <details class="bt-performance-objectives bt-performance-objectives--nested" open={@default_expanded?}>
            <summary>{gettext("Strengths, weaknesses, recommendations")}</summary>
            <div class="bt-performance-evaluation__details">
              <p :if={@evaluation.strengths}>
                <strong>{gettext("Strengths")}</strong>
                <span>{@evaluation.strengths}</span>
              </p>
              <p :if={@evaluation.weaknesses}>
                <strong>{gettext("Weaknesses")}</strong>
                <span>{@evaluation.weaknesses}</span>
              </p>
              <p :if={@evaluation.recommendations}>
                <strong>{gettext("Recommendations")}</strong>
                <span>{@evaluation.recommendations}</span>
              </p>
            </div>
          </details>
        </div>
      </div>
    </article>
    """
  end

  attr :state, :atom, required: true, values: [:pending, :acknowledged]
  attr :date_label, :string, default: nil

  def bt_performance_ack_chip(assigns) do
    label =
      case {assigns.state, assigns.date_label} do
        {:acknowledged, date} when is_binary(date) and date != "" ->
          gettext("Acknowledged %{date}", date: date)

        {:acknowledged, _} ->
          gettext("Acknowledged")

        _ ->
          gettext("Awaiting acknowledgement")
      end

    assigns = assign(assigns, :label, label)

    ~H"""
    <span
      class={[
        "bt-performance-ack",
        @state == :acknowledged && "bt-performance-ack--done",
        @state == :pending && "bt-performance-ack--pending"
      ]}
      title={@label}
    >
      <span class="bt-performance-ack__mark" aria-hidden="true">
        {if @state == :acknowledged, do: "✓", else: "◷"}
      </span>
      <span class="bt-performance-ack__label">{@label}</span>
    </span>
    """
  end

  attr :id, :string, default: nil
  attr :class, :any, default: nil
  attr :people_count, :integer, required: true
  attr :rest, :global
  slot :search, required: true
  slot :filters
  slot :controls

  def bt_performance_team_toolbar(assigns) do
    ~H"""
    <div
      id={@id}
      class={["bt-performance-team-toolbar bt-card", @class]}
      {@rest}
    >
      <div class="bt-performance-team-toolbar__filters">
        <div class="bt-performance-team-toolbar__search">{render_slot(@search)}</div>
        <div :if={render_slot(@filters) != []} class="bt-performance-team-toolbar__filter-actions">
          {render_slot(@filters)}
        </div>
      </div>
      <div class="bt-performance-team-toolbar__controls">
        <div class="bt-performance-team-toolbar__control-cluster">{render_slot(@controls)}</div>
        <p class="bt-performance-team-toolbar__count">
          {gettext("People")}:
          <strong>{@people_count}</strong>
        </p>
      </div>
    </div>
    """
  end

  attr :class, :any, default: nil
  attr :label, :string, required: true
  attr :active?, :boolean, default: false
  attr :arrow, :string, default: nil
  attr :rest, :global

  def bt_performance_toolbar_pill(assigns) do
    ~H"""
    <button
      type="button"
      class={[
        "bt-performance-toolbar-pill",
        @active? && "bt-performance-toolbar-pill--active",
        @class
      ]}
      {@rest}
    >
      <span>{@label}</span>
      <span :if={@arrow} class="bt-performance-toolbar-pill__arrow" aria-hidden="true">
        {@arrow}
      </span>
    </button>
    """
  end

  attr :class, :any, default: nil
  attr :label, :string, required: true
  attr :rest, :global

  def bt_performance_toolbar_section_label(assigns) do
    ~H"""
    <span class={["bt-performance-team-toolbar__section-label", @class]} {@rest}>
      {@label}
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
  attr :briefing_status, :string, default: nil
  attr :evaluation_date_label, :string, default: nil
  attr :evaluation_rating, :string, default: nil
  attr :evaluation_status, :string, default: nil
  attr :rating, :string, default: nil
  attr :rating_label, :string, default: nil
  attr :rest, :global
  slot :actions

  def bt_performance_team_card(assigns) do
    evaluation_rating = assigns.evaluation_rating || assigns.rating
    {briefing_mark, briefing_mark_class} = briefing_status_mark(assigns.briefing_status)
    {evaluation_mark, evaluation_mark_class} = evaluation_status_mark(assigns.evaluation_status)

    evaluation_rating_letter = rating_letter(evaluation_rating)

    has_evaluation? =
      evaluation_rating_letter != nil or is_binary(assigns.evaluation_date_label)

    assigns =
      assigns
      |> assign_new(:no_hours_message, fn ->
        gettext("No reported hours in this period for this person.")
      end)
      |> assign(:briefing_mark, briefing_mark)
      |> assign(:briefing_mark_class, briefing_mark_class)
      |> assign(:evaluation_mark, evaluation_mark)
      |> assign(:evaluation_mark_class, evaluation_mark_class)
      |> assign(:evaluation_rating_letter, evaluation_rating_letter)
      |> assign(:evaluation_rating_class, rating_class(evaluation_rating))
      |> assign(:has_evaluation?, has_evaluation?)

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
        <div class="bt-performance-team-card__identity">
          <div class="bt-performance-team-card__name-row">
            <span class="bt-performance-team-card__name">{@name}</span>
            <span :if={@category} class="bt-performance-chip bt-performance-chip--category">
              {@category}
            </span>
          </div>
          <div :if={@project_label} class="bt-performance-team-card__project-row">
            <span class="bt-performance-team-card__project">{@project_label}</span>
            <span :if={@hours_label} class="bt-performance-hours-pill">{@hours_label}</span>
          </div>
          <p :if={!@project_label} class="bt-performance-empty bt-performance-empty--inline">
            {@no_hours_message}
          </p>
        </div>
        <div :if={@show_delegator? && @delegator_name} class="bt-performance-team-card__delegation">
          <span>{gettext("Delegated by")}</span>
          <strong>{@delegator_name}</strong>
        </div>
      </div>
      <div class="bt-performance-team-card__aside">
        <div :if={@briefing_date_label} class="bt-performance-team-card__status-panel">
          <div class="bt-performance-team-card__status-row">
            <span class="bt-performance-team-card__status-label">{gettext("Briefing")}</span>
            <span class="bt-performance-team-card__status-date">{@briefing_date_label}</span>
            <span class={["bt-performance-status-mark", @briefing_mark_class]}>{@briefing_mark}</span>
          </div>
          <div :if={@has_evaluation?} class="bt-performance-team-card__status-row">
            <span class="bt-performance-team-card__status-leading">
              <span class="bt-performance-team-card__status-label">{gettext("Evaluation")}</span>
              <span
                :if={@evaluation_rating_letter}
                class={["bt-performance-rating-mark", @evaluation_rating_class]}
              >
                {@evaluation_rating_letter}
              </span>
            </span>
            <span :if={@evaluation_date_label} class="bt-performance-team-card__status-date">
              {@evaluation_date_label}
            </span>
            <span class={["bt-performance-status-mark", @evaluation_mark_class]}>{@evaluation_mark}</span>
          </div>
          <span :if={!@has_evaluation?} class="bt-performance-team-card__no-eval">
            {gettext("No evaluation yet")}
          </span>
        </div>
        <div :if={!@briefing_date_label} class="bt-performance-team-card__pending">
          <span class="bt-performance-empty bt-performance-empty--inline">
            {gettext("No briefing yet")}
          </span>
          <div :if={render_slot(@actions) != []} class="bt-performance-actions">
            {render_slot(@actions)}
          </div>
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
  def objective_attrs(objectives, ratings_by_id \\ %{}) do
    objectives = Enum.reject(objectives, &is_nil/1)

    total_weight =
      objectives
      |> Enum.map(&(&1.weight || 0))
      |> Enum.sum()

    objectives
    |> Enum.with_index(1)
    |> Enum.map(fn {obj, index} ->
      weight = obj.weight || 0

      percent =
        if total_weight > 0, do: weight * 100.0 / total_weight, else: 0.0

      rating_entry =
        obj.id
        |> objective_rating_lookup(ratings_by_id)
        |> normalize_objective_rating()

      completion = rating_entry && rating_entry.rating

      %{
        index: index,
        title: obj.title,
        weight: weight,
        weight_share_label: format_weight_share(percent),
        category: Map.get(obj, :category),
        description: Map.get(obj, :description),
        completion: completion,
        completion_label: objective_completion_label(completion),
        evaluator_comment: rating_entry && rating_entry.rationale
      }
    end)
  end

  @doc false
  def evaluation_attrs(nil), do: nil

  def evaluation_attrs(eval) do
    rating = Map.get(eval, :rating)

    %{
      date_label: Map.get(eval, :date_label),
      creator_label: Map.get(eval, :creator_label),
      rating: rating,
      rating_label: Map.get(eval, :rating_label) || rating_label(rating),
      rationale: Map.get(eval, :rationale),
      strengths: Map.get(eval, :strengths),
      weaknesses: Map.get(eval, :weaknesses),
      recommendations: Map.get(eval, :recommendations),
      ack_state: Map.get(eval, :ack_state) || evaluation_ack_state(eval),
      ack_date_label: Map.get(eval, :ack_date_label)
    }
  end

  @doc false
  def objective_completion_label(rating), do: completion_label(rating)

  @doc false
  def evaluation_rating_label(rating), do: rating_label(rating)

  @doc false
  def rating_letter(nil), do: nil

  def rating_letter(rating) when is_binary(rating) do
    case String.downcase(String.trim(rating)) do
      "a" -> "A"
      "b" -> "B"
      "c" -> "C"
      "d" -> "D"
      other when byte_size(other) == 1 -> String.upcase(other)
      _ -> nil
    end
  end

  @doc false
  def evaluation_ack_state(%{acknowledged_at: acknowledged_at}) when not is_nil(acknowledged_at),
    do: :acknowledged

  def evaluation_ack_state(_), do: :pending

  defp briefing_status_mark("acknowledged"), do: {"✓", "bt-performance-status-mark--agreed"}

  defp briefing_status_mark(status) when status in ["published", "draft", "created"] do
    case status do
      "published" -> {"P", "bt-performance-status-mark--published"}
      _ -> {"D", "bt-performance-status-mark--draft"}
    end
  end

  defp briefing_status_mark(status) when is_binary(status) do
    briefing_status_mark(String.downcase(String.trim(status)))
  end

  defp briefing_status_mark(_), do: {"D", "bt-performance-status-mark--draft"}

  defp evaluation_status_mark("acknowledged"), do: {"✓", "bt-performance-status-mark--agreed"}
  defp evaluation_status_mark(_), do: {"P", "bt-performance-status-mark--published"}

  defp rating_class(nil), do: nil
  defp rating_class(rating) when is_binary(rating), do: Map.get(@rating_classes, String.downcase(rating))

  defp completion_class(nil), do: nil

  defp completion_class(completion) when is_binary(completion),
    do: Map.get(@completion_classes, String.downcase(completion))

  defp objective_rating_lookup(obj_id, ratings_by_id) do
    Map.get(ratings_by_id, obj_id) || Map.get(ratings_by_id, to_string(obj_id))
  end

  defp normalize_objective_rating(nil), do: nil

  defp normalize_objective_rating(rating) when is_binary(rating),
    do: %{rating: rating, rationale: nil}

  defp normalize_objective_rating(%{} = entry) do
    %{
      rating: Map.get(entry, :rating) || Map.get(entry, "rating"),
      rationale: Map.get(entry, :rationale) || Map.get(entry, "rationale")
    }
  end

  defp completion_label(nil), do: nil
  defp completion_label("no"), do: gettext("Not achieved")
  defp completion_label("partial"), do: gettext("Partially achieved")
  defp completion_label("total"), do: gettext("Fully achieved")

  defp completion_label(other) when is_binary(other) do
    case String.downcase(String.trim(other)) do
      "no" -> gettext("Not achieved")
      "partial" -> gettext("Partially achieved")
      "total" -> gettext("Fully achieved")
      _ -> other
    end
  end

  defp rating_label(nil), do: nil
  defp rating_label("a"), do: gettext("Exceptional")
  defp rating_label("b"), do: gettext("Above expected")
  defp rating_label("c"), do: gettext("Expected")
  defp rating_label("d"), do: gettext("Below expected")

  defp rating_label(other) when is_binary(other) do
    case String.downcase(String.trim(other)) do
      "a" -> gettext("Exceptional")
      "b" -> gettext("Above expected")
      "c" -> gettext("Expected")
      "d" -> gettext("Below expected")
      _ -> other
    end
  end

  defp format_weight_share(percent) do
    gettext("%{percent}%", percent: :erlang.float_to_binary(percent, decimals: 1))
  end

  defp default_avatar, do: "https://www.gravatar.com/avatar/?d=mp"
end
