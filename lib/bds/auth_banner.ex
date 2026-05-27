defmodule Bds.AuthBanner do
  @moduledoc """
  Canonical [Ash Authentication Phoenix](https://hexdocs.pm/ash_authentication_phoenix/ui-overrides.html)
  `Banner` overrides for Bluetab apps.

  Light and dark logo assets swap via `bt-auth-banner__logo--light` / `--dark` in `auth.css`
  (same `html[data-theme="dark"]` pattern as `bt-brand__logo`).

  Styles live in the design-system bundle (`bt-auth-banner*` classes in `auth.css`).
  """

  @logo_light_path "/images/bluetab_ibm_light.png"
  @logo_dark_path "/images/bluetab_ibm_dark.png"

  @doc "Logo for light theme (dark mark on light background)."
  @spec logo_light_path() :: String.t()
  def logo_light_path, do: @logo_light_path

  @doc "Logo for dark theme (light mark on dark background)."
  @spec logo_dark_path() :: String.t()
  def logo_dark_path, do: @logo_dark_path

  @doc "Alias for `logo_light_path/0`."
  @spec logo_path() :: String.t()
  def logo_path, do: logo_light_path()

  @doc """
  Returns an `override AshAuthentication.Phoenix.Components.Banner` block for `AuthOverrides`.

  `app_name` is shown as the banner title (e.g. `"Storybook"`).
  """
  @spec override_snippet(String.t()) :: String.t()
  def override_snippet(app_name) when is_binary(app_name) do
    """
    override AshAuthentication.Phoenix.Components.Banner do
      set :root_class, "bt-auth-banner"
      set :href_url, nil
      set :href_class, nil
      set :image_class, "bt-auth-banner__logo bt-auth-banner__logo--light"
      set :image_url, #{inspect(@logo_light_path)}
      set :dark_image_class, "bt-auth-banner__logo bt-auth-banner__logo--dark"
      set :dark_image_url, #{inspect(@logo_dark_path)}
      set :text, #{inspect(app_name)}
      set :text_class, "bt-auth-banner__title"
    end
    """
    |> String.trim_trailing()
  end
end
