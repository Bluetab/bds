defmodule Bds.CatalogTest do
  use ExUnit.Case, async: true

  alias Bds.Catalog

  test "loads catalog with expected default" do
    assert Catalog.default_id() == "get-started"
    assert length(Catalog.components()) >= 30
    assert Catalog.get!("buttons")["title"] == "Buttons"
    refute Catalog.valid_id?("not-a-component")
  end

  test "components_in_group/2 filters by title" do
    matches = Catalog.components_in_group("Components", "button")
    assert Enum.any?(matches, &(&1["id"] == "buttons"))
    refute Enum.any?(matches, &(&1["id"] == "tables"))
  end

  test "normalize_snippet/1 trims whitespace" do
    assert Catalog.normalize_snippet("\n  <button></button>\n") == "<button></button>"
  end

  test "example_html/1 returns snippet by ref" do
    html = Catalog.example_html("buttons:0")
    assert html =~ "bt-button"
  end

  test "example_heex/1 returns Phoenix component markup" do
    heex = Catalog.example_heex("buttons:0")
    assert heex =~ "<.bt_button"
    refute heex =~ "<button class=\"bt-button\""
  end

  test "highlight_heex/1 highlights component tags" do
    highlighted = Catalog.highlight_heex("<.bt_button>Save</.bt_button>")
    rendered = Phoenix.HTML.safe_to_string(highlighted)
    assert rendered =~ "bt-code__tag"
    assert rendered =~ "bt_button"
  end

  test "localized_component/1 translates metadata with locale" do
    Gettext.put_locale(Bds.Gettext, "es")

    component = Catalog.get!("buttons") |> Catalog.localized_component()

    assert component["title"] == "Botones"
  end

  test "highlight_html/1 escapes and highlights tags" do
    highlighted = Catalog.highlight_html("<button class=\"bt-button\">")
    rendered = Phoenix.HTML.safe_to_string(highlighted)
    assert rendered =~ "bt-code__tag"
    assert rendered =~ "bt-button"
    refute rendered =~ "<button"
  end
end
