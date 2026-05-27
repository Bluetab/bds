defmodule BdsTest do
  use ExUnit.Case, async: true

  test "asset paths exist after sync" do
    assert File.exists?(Bds.css_path())
    assert File.exists?(Bds.interactions_path())
  end

  test "translate_error without gettext interpolates placeholders" do
    assert Bds.Components.translate_error({"must be %{count}", count: 3}) == "must be 3"
  end
end
