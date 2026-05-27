defmodule Bds.AuthSnippetsTest do
  use ExUnit.Case, async: true

  test "AuthBanner snippet includes light and dark logos" do
    snippet = Bds.AuthBanner.override_snippet("MyApp")

    assert snippet =~ "bt-auth-banner__logo--light"
    assert snippet =~ "bt-auth-banner__logo--dark"
    assert snippet =~ "/images/bluetab_ibm_light.png"
    assert snippet =~ "/images/bluetab_ibm_dark.png"
    assert snippet =~ ~s|set :text, "MyApp"|
  end

  test "AuthUi OAuth2 snippet uses token-based classes" do
    snippet = Bds.AuthUi.oauth2_override_snippet()

    assert snippet =~ "bt-auth-oauth-link"
    assert snippet =~ "AshAuthentication.Phoenix.Components.OAuth2"
  end

  test "install_snippets/1 combines banner and oauth blocks" do
    combined = Bds.AuthUi.install_snippets("Acme")

    assert combined =~ "Components.Banner"
    assert combined =~ "Components.OAuth2"
  end
end
