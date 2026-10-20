defmodule Bds.OptionalSlotsTest do
  @moduledoc """
  Optional slots are tested with `@slot != []`. `render_slot/1` of an empty
  slot is not `[]`, so `render_slot(@slot) != []` was always true (empty
  wrappers, an empty `<aside>` landmark) and `== []` always false (hidden
  defaults such as the month label or the project field).
  """
  use ExUnit.Case, async: true

  import Phoenix.Component
  import Phoenix.LiveViewTest

  alias Bds.Components.Calendar

  test "calendar shell renders no empty toolbar, sidebar or legend" do
    assigns = %{}
    html = rendered_to_string(~H|<Calendar.bt_calendar_shell>grid</Calendar.bt_calendar_shell>|)
    refute html =~ "bt-calendar-shell__toolbar"
    refute html =~ "<aside"
    refute html =~ "bt-calendar-shell__legend"
  end

  test "calendar toolbar shows the month label when no center slot is given" do
    assigns = %{}
    html = rendered_to_string(~H|<Calendar.bt_calendar_toolbar month_label="Octubre 2026" />|)
    assert html =~ "bt-calendar-toolbar__month"
    assert html =~ "Octubre 2026"
  end

  test "gasto card without actions draws no actions bar" do
    assigns = %{}

    html =
      rendered_to_string(~H"""
      <Bds.Components.Expense.bt_expense_gasto_card
        id="g"
        type_label="Taxi"
        date_label="2026-03-17"
        title="Airport to hotel"
        amount="42.50"
      />
      """)

    refute html =~ "bt-expense-gasto-card__actions"
  end

  test "no component compares render_slot/1 with []" do
    offenders =
      for file <- Path.wildcard(Path.expand("../../lib/**/*.ex", __DIR__)),
          {line, n} <- file |> File.read!() |> String.split("\n") |> Enum.with_index(1),
          line =~ ~r/render_slot\(@\w+\)\s*(!=|==)\s*\[\]/ do
        "#{Path.relative_to_cwd(file)}:#{n}"
      end

    assert offenders == [], "Use `@slot != []` instead:\n" <> Enum.join(offenders, "\n")
  end
end
