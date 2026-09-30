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

  test "color_families/0 exposes 10-step scales with level 60 as master" do
    families = Catalog.color_families()

    assert length(families) == 14

    for family <- families do
      assert Enum.map(family["steps"], & &1["level"]) == Enum.to_list(10..100//10)
      assert [%{"level" => 60, "hex" => master}] = Enum.filter(family["steps"], & &1["master"])
      assert master == family["master"]
    end

    assert Catalog.color_family!("bluetab-blue")["master"] == "#212492"
    assert_raise ArgumentError, fn -> Catalog.color_family!("unknown") end
  end

  test "colors examples render one scale per family" do
    assert Catalog.example_heex("colors:2") =~ ~s(<.bt_color_scale family="bluetab-blue")
    assert Catalog.example_html("colors:2") =~ "--bt-palette-bluetab-blue-60"
    assert length(Catalog.get!("colors")["examples"]) == 2 + length(Catalog.color_families())
  end

  test "highlight_html/1 escapes and highlights tags" do
    highlighted = Catalog.highlight_html("<button class=\"bt-button\">")
    rendered = Phoenix.HTML.safe_to_string(highlighted)
    assert rendered =~ "bt-code__tag"
    assert rendered =~ "bt-button"
    refute rendered =~ "<button"
  end
end
