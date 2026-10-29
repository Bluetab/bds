defmodule Bds.PickersLabelTest do
  @moduledoc """
  `UserPicker` and `ProjectPicker` are LiveComponents, so `attr` defaults are
  not filled into their assigns: an optional attr such as `label` is simply
  missing unless the caller passes it. Reading it with `@label` raised a
  `KeyError` and the picker crashed on every render without a `label`.
  """
  use ExUnit.Case, async: true

  import Phoenix.LiveViewTest

  alias Bds.Components.{ProjectPicker, UserPicker}

  def search(_query, _opts), do: []

  defp user_picker(extra) do
    render_component(
      UserPicker,
      Keyword.merge([id: "picker", value: nil, search_fn: &__MODULE__.search/2], extra)
    )
  end

  defp project_picker(extra) do
    render_component(
      ProjectPicker,
      Keyword.merge([id: "picker", value: nil, search_fn: &__MODULE__.search/2], extra)
    )
  end

  describe "UserPicker without a label" do
    test "renders in card mode" do
      assert user_picker(title: "Owner") =~ "bt-user-picker"
    end

    test "renders in bare mode" do
      assert user_picker(bare: true) =~ "bt-user-picker--bare"
    end

    test "renders in multi mode" do
      assert user_picker(multi: true) =~ "bt-user-picker--multi"
    end

    test "card mode: the visible title also names the search input, hidden from sight" do
      assert user_picker(title: "Owner") =~
               ~r/<label[^>]*for="picker-search-input"[^>]*class="bt-sr-only"[^>]*>\s*Owner\s*<\/label>/
    end
  end

  describe "UserPicker with a label" do
    test "bare mode shows it as the visible field label" do
      html = user_picker(bare: true, label: "Responsible")

      assert html =~ ~r/<label[^>]*for="picker-search-input"[^>]*>\s*Responsible\s*<\/label>/
      refute html =~ "bt-sr-only"
    end
  end

  describe "ProjectPicker without a label" do
    test "renders in card mode" do
      assert project_picker(title: "Project") =~ "bt-project-picker"
    end

    test "renders in bare mode" do
      assert project_picker(bare: true) =~ "bt-project-picker--bare"
    end
  end
end
