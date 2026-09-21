defmodule Bds.ComponentsInputTest do
  use ExUnit.Case, async: true

  import Phoenix.Component
  import Bds.Components

  test "empty textarea has no leading whitespace" do
    assigns = %{}

    html =
      ~H"""
      <.bt_input id="day_entry_comments" name="day_entry[comments]" type="textarea" rows="2" />
      """
      |> Phoenix.HTML.Safe.to_iodata()
      |> IO.iodata_to_binary()

    [inner] =
      Regex.run(~r/<textarea[^>]*id="day_entry_comments"[^>]*>(.*?)<\/textarea>/s, html,
        capture: :all_but_first
      )

    # Phoenix.HTML prepends a single LF (ignored by browsers). Extra whitespace
    # shows up as blank lines in the textarea.
    assert inner in ["", "\n"]
  end
end
