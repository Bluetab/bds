defmodule Bds.AuthUi do
  @moduledoc """
  Ash Authentication Phoenix UI override snippets for Bluetab apps.

  Use in `YourAppWeb.AuthOverrides` (see `Bds.AuthBanner` for the sign-in banner).
  Styles live in `auth.css` (`bt-auth-*` classes).
  """

  @doc """
  Banner + OAuth2 override blocks for `AuthOverrides` (used by `bluetab_phoenix.install`).
  """
  @spec install_snippets(String.t()) :: String.t()
  def install_snippets(app_name) when is_binary(app_name) do
    Bds.AuthBanner.override_snippet(app_name) <> "\n\n  " <> oauth2_override_snippet()
  end

  @doc """
  Returns an `override AshAuthentication.Phoenix.Components.OAuth2` block.

  Token-based link styles work in light and dark theme (`data-theme` on `<html>`).
  """
  @spec oauth2_override_snippet() :: String.t()
  def oauth2_override_snippet do
    """
    override AshAuthentication.Phoenix.Components.OAuth2 do
      set :root_class, "bt-auth-oauth"
      set :link_class, "bt-auth-oauth-link"
      set :icon_class, "bt-auth-oauth-link__icon"
      set :icon_src, nil
    end
    """
    |> String.trim_trailing()
  end
end
