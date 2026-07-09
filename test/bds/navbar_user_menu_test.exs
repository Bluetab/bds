defmodule Bds.NavbarUserMenuTest do
  use ExUnit.Case, async: true

  import Phoenix.Component
  import Bds.Components

  test "renders locale and theme rows in user menu prefs" do
    assigns = %{}

    html =
      ~H"""
      <.bt_navbar_user_menu_prefs>
        <.bt_navbar_user_menu_locale_toggle
          locale="es"
          locales={[%{code: "es", label: "Español"}, %{code: "en", label: "English"}]}
        />
        <.bt_navbar_user_menu_theme_toggle id="theme-test" />
      </.bt_navbar_user_menu_prefs>
      """
      |> Phoenix.HTML.Safe.to_iodata()
      |> IO.iodata_to_binary()

    assert html =~ "bt-navbar-user__dropdown-prefs"
    assert html =~ ~s(>Language<)
    assert html =~ ~s(>Theme<)
    assert html =~ "Español"
    assert html =~ ">Light<"
    assert html =~ "data-theme-toggle"
    assert html =~ "data-theme-value"
    assert html =~ ~s(id="theme-test")
    refute html =~ "/>"
  end

  test "user menu dropdown header renders extended profile with email" do
    assigns = %{}

    html =
      ~H"""
      <.bt_navbar_user_menu
        name="Alex Rivera"
        email="alex@example.com"
        role="Member"
        initials="AR"
      >
        <div>menu</div>
      </.bt_navbar_user_menu>
      """
      |> Phoenix.HTML.Safe.to_iodata()
      |> IO.iodata_to_binary()

    assert html =~ "bt-avatar bt-avatar--expanded"
    assert html =~ "bt-avatar__name"
    assert html =~ "bt-avatar__email"
    assert html =~ "alex@example.com"
    refute html =~ "bt-navbar-user__role"
    refute html =~ "bt-navbar-user__dropdown-role"
  end
end
