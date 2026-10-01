defmodule Bds.ComponentsA11yTest do
  use ExUnit.Case, async: true

  import Phoenix.Component
  import Phoenix.LiveViewTest
  import Bds.Components
  import Bds.Components.CatalogUi

  describe "sizes" do
    test "md adds no modifier, other sizes add one" do
      assigns = %{}
      assert rendered_to_string(~H|<.bt_icon_button label="Edit" icon="edit" />|) =~ ~s(class="bt-icon-button")
      assert rendered_to_string(~H|<.bt_icon_button label="Edit" icon="edit" size="lg" />|) =~ "bt-icon-button--lg"
      assert rendered_to_string(~H|<.bt_chip size="sm">A</.bt_chip>|) =~ "bt-chip--sm"
      assert rendered_to_string(~H|<.bt_spinner size="lg" />|) =~ "bt-spinner--lg"
    end
  end

  describe "forms" do
    test "bt_input links help and errors and flags invalid" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.bt_input id="email" name="email" label="Email" help="Work email" errors={["can't be blank"]} />
        """)

      assert html =~ ~s(aria-invalid="true")
      assert html =~ ~s(aria-describedby="email-help email-errors")
      assert html =~ ~s(id="email-help")
      assert html =~ ~s(id="email-errors")
      assert html =~ "can&#39;t be blank"
    end

    test "valid bt_input has no aria-invalid" do
      assigns = %{}
      html = rendered_to_string(~H|<.bt_input id="name" name="name" label="Name" />|)
      refute html =~ "aria-invalid"
      refute html =~ "aria-describedby"
    end

    test "bt_switch exposes the switch role" do
      assigns = %{}
      assert rendered_to_string(~H|<.bt_switch name="n" label="Notify" />|) =~ ~s(role="switch")
    end

    test "bt_slider always has a label" do
      assigns = %{}
      html = rendered_to_string(~H|<.bt_slider id="vol" label="Volume" hide_label />|)
      assert html =~ ~s(for="vol")
      assert html =~ "bt-sr-only"
    end
  end

  describe "widgets" do
    test "bt_tabs wires tabs and panels with roving tabindex" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.bt_tabs id="t" label="Sections">
          <:tab id="tab-a" label="A" selected />
          <:tab id="tab-b" label="B" />
          <:panel id="panel-a" tab_id="tab-a">a</:panel>
          <:panel id="panel-b" tab_id="tab-b">b</:panel>
        </.bt_tabs>
        """)

      assert html =~ ~s(aria-controls="panel-a")
      assert html =~ ~s(aria-labelledby="tab-a")
      assert html =~ ~r/id="tab-a"[^>]*tabindex="0"|tabindex="0"[^>]*id="tab-a"/
      assert html =~ ~r/id="tab-b"[^>]*tabindex="-1"|tabindex="-1"[^>]*id="tab-b"/
      assert html =~ ~s(aria-label="Sections")
    end

    test "bt_menu_wrap toggle declares the popup" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.bt_menu_wrap id="m"><:item label="One" /></.bt_menu_wrap>
        """)

      assert html =~ ~s(aria-haspopup="menu")
      assert html =~ ~s(aria-expanded="false")
      assert html =~ ~s(aria-controls="m")
    end

    test "bt_expansion exposes its state" do
      assigns = %{}
      html = rendered_to_string(~H|<.bt_expansion id="x" title="More" open>body</.bt_expansion>|)
      assert html =~ ~s(aria-expanded="true")
      assert html =~ ~s(aria-controls="x-content")
    end

    test "bt_progress is a progressbar with a value" do
      assigns = %{}
      html = rendered_to_string(~H|<.bt_progress value={3} max={4} label="Upload" />|)
      assert html =~ ~s(role="progressbar")
      assert html =~ ~s(aria-valuenow="3")
      assert html =~ ~s(aria-valuemax="4")
      assert html =~ "--value: 75%"
    end

    test "bt_modal is named and traps focus" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.bt_modal id="dlg" title="Delete" close_event="close">Sure?</.bt_modal>
        """)

      assert html =~ ~s(aria-labelledby="dlg-title")
      assert html =~ ~s(id="dlg-title")
      # focus_wrap sentinels
      assert html =~ ~s(id="dlg-panel-start")
    end

    test "bt_overlay and bt_dialog have accessible names" do
      assigns = %{}
      assert rendered_to_string(~H|<.bt_overlay id="o" label="Filters">x</.bt_overlay>|) =~ ~s(aria-label="Filters")
      assert rendered_to_string(~H|<.bt_dialog id="d" title="Hi">x</.bt_dialog>|) =~ ~s(aria-labelledby="d-title")
    end

    test "bt_breadcrumb marks the current page" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.bt_breadcrumb items={[%{label: "Home", href: "/"}, %{label: "Page", current: true}]} />
        """)

      assert html =~ ~s(aria-current="page")
      assert html =~ "<ol"
    end

    test "bt_empty renders no empty wrappers" do
      assigns = %{}
      html = rendered_to_string(~H|<.bt_empty title="Nothing here" />|)
      refute html =~ "bt-empty__icon"
      refute html =~ "bt-empty__actions"
    end

    test "dot badge needs a label for screen readers" do
      assigns = %{}
      html = rendered_to_string(~H|<.bt_badge variant="dot" label="New messages" />|)
      assert html =~ ~s(<span class="bt-sr-only">New messages</span>)
    end

    test "bt_combobox is a combobox with listbox popup" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.bt_combobox id="c" name="q" label="Project" open errors={["Pick one"]} />
        """)

      assert html =~ ~s(role="combobox")
      assert html =~ ~s(aria-expanded="true")
      assert html =~ ~s(aria-controls="c-input-panel")
      assert html =~ ~s(aria-describedby="c-input-errors")
      assert html =~ "Pick one"
    end

    test "tree uses disclosure buttons, not invalid tree roles" do
      assigns = %{nodes: [%{id: 1, name: "Root", children: [%{id: 2, name: "Child"}]}]}

      html = rendered_to_string(~H|<.bt_tree id="tree" nodes={@nodes} expanded={MapSet.new(["1"])} />|)

      refute html =~ ~s(role="tree")
      refute html =~ ~s(role="treeitem")
      refute html =~ ~s(role="option")
      assert html =~ ~s(aria-expanded="true")
      assert html =~ "data-bt-tree"
    end
  end
end
