defmodule Bds.IconsTest do
  use ExUnit.Case, async: true

  test "lists the whole Material Symbols library, sorted and unique" do
    names = Bds.Icons.names()

    assert Bds.Icons.count() > 3_000
    assert names == names |> Enum.uniq() |> Enum.sort()
    assert "home" in names
  end

  test "valid?/1 checks ligature names" do
    assert Bds.Icons.valid?("accessibility_new")
    refute Bds.Icons.valid?("not_an_icon")
    refute Bds.Icons.valid?("<script>")
  end

  test "search/1 matches every word and ranks prefix matches first" do
    assert ["arrow_back" | _] = Bds.Icons.search("arrow back")
    assert Enum.all?(Bds.Icons.search("calendar month"), &(&1 =~ "calendar" and &1 =~ "month"))
    assert Bds.Icons.search("  ") == Bds.Icons.names()
    assert Bds.Icons.search("zzzz_nothing") == []
  end
end
