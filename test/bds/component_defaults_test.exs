defmodule Bds.ComponentDefaultsTest do
  @moduledoc """
  Translated fallbacks for optional labels. An `attr :x, default: nil` puts
  `x: nil` in assigns, so `assign_new(assigns, :x, ...)` never runs: these
  tests render each component without the attr and expect the fallback.
  """
  use ExUnit.Case, async: true

  import Phoenix.Component
  import Phoenix.LiveViewTest
  import Bds.Components
  import Bds.Components.CatalogUi

  test "bt_menu_wrap toggle has visible text without toggle_label" do
    assigns = %{}
    html = rendered_to_string(~H|<.bt_menu_wrap id="m"><:item label="One" /></.bt_menu_wrap>|)
    assert html =~ ~r/aria-controls="m"\s*>\s*Open menu/
  end

  test "bt_modal close buttons are named without close_label" do
    assigns = %{}

    html =
      rendered_to_string(
        ~H|<.bt_modal id="dlg" title="Delete" close_event="close">Sure?</.bt_modal>|
      )

    assert html =~ ~s(aria-label="Close dialog")
    refute html =~ ~s(aria-label="")
  end

  test "bt_bottom_nav and bt_segmented are named without label" do
    assigns = %{}

    nav =
      rendered_to_string(
        ~H|<.bt_bottom_nav><:item label="Home" icon="home" href="/" /></.bt_bottom_nav>|
      )

    assert nav =~ ~s(aria-label="Bottom navigation")

    seg = rendered_to_string(~H|<.bt_segmented><:item label="Day" /></.bt_segmented>|)
    assert seg =~ ~s(aria-label="Segmented control")
  end

  test "calendar templates panel and legend fall back to translated labels" do
    assigns = %{}

    panel =
      rendered_to_string(~H"""
      <Bds.Components.Calendar.bt_calendar_templates_panel id="t" on_help="help">body</Bds.Components.Calendar.bt_calendar_templates_panel>
      """)

    assert panel =~ "Templates"
    assert panel =~ ~s(aria-label="Template help")

    legend =
      rendered_to_string(
        ~H|<Bds.Components.Calendar.bt_calendar_legend items={[%{label: "Done", count: 1}]} />|
      )

    assert legend =~ ~s(aria-label="Calendar status legend")
  end

  test "bt_tabs with no selected tab selects the first one" do
    assigns = %{}

    html =
      rendered_to_string(~H"""
      <.bt_tabs id="t" label="Sections">
        <:tab id="tab-a" label="A" />
        <:tab id="tab-b" label="B" />
        <:panel id="panel-a" tab_id="tab-a">a</:panel>
        <:panel id="panel-b" tab_id="tab-b">b</:panel>
      </.bt_tabs>
      """)

    assert html =~ ~r/id="tab-a"[^>]*aria-selected="true"|aria-selected="true"[^>]*id="tab-a"/
    assert html =~ ~r/id="tab-a"[^>]*tabindex="0"|tabindex="0"[^>]*id="tab-a"/
    assert html =~ ~r/id="panel-a"[^>]*aria-hidden="false"|aria-hidden="false"[^>]*id="panel-a"/
  end

  test "bt_breadcrumb shows a level without a link as text" do
    assigns = %{}

    html =
      rendered_to_string(~H"""
      <.bt_breadcrumb items={[%{label: "Home", href: "/"}, %{label: "Section"}, %{label: "Page", current: true}]} />
      """)

    assert html =~ "Section"
  end

  test "expense and performance empty states render their fallback text" do
    assigns = %{}

    list =
      rendered_to_string(~H|<Bds.Components.Expense.bt_expense_project_list projects={[]} />|)

    assert list =~ "No matching projects."

    hours =
      rendered_to_string(
        ~H|<Bds.Components.Performance.bt_performance_hours_panel hours_groups={[]} />|
      )

    assert hours =~ "No reported hours for this scope."
  end
end
