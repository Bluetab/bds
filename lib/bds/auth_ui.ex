defmodule Bds.AuthUi do
  @moduledoc """
  Ash Authentication Phoenix UI override snippets for Bluetab apps.

  Use in `YourAppWeb.AuthOverrides` (see `Bds.AuthBanner` for the sign-in banner).
  Styles live in `auth.css` (`bt-auth-*` classes).
  """

  @doc """
  Returns override blocks for the sign-in page shell (layout, flash, strategy width).

  Pair with `install_snippets/1` in `AuthOverrides` and import `bds.css` in the host app.
  """
  @spec sign_in_shell_override_snippet() :: String.t()
  def sign_in_shell_override_snippet do
    """
    override AshAuthentication.Phoenix.SignInLive do
      set :root_class, "bt-auth-page"
    end

    override AshAuthentication.Phoenix.Components.SignIn do
      set :root_class, "bt-auth-sign-in"
      set :strategy_class, "bt-auth-strategy"
      set :authentication_error_container_class, "bt-auth-error"
      set :authentication_error_text_class, ""
    end

    override AshAuthentication.Phoenix.Components.Flash do
      set :message_class_info, "bt-auth-flash bt-auth-flash--info"
      set :message_class_error, "bt-auth-flash bt-auth-flash--error"
    end
    """
    |> String.trim_trailing()
  end

  @doc """
  Banner + OAuth2 + sign-in shell override blocks for `AuthOverrides`.
  """
  @spec install_snippets(String.t()) :: String.t()
  def install_snippets(app_name) when is_binary(app_name) do
    Bds.AuthBanner.override_snippet(app_name) <>
      "\n\n  " <>
      oauth2_override_snippet() <>
      "\n\n  " <>
      sign_in_shell_override_snippet()
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
