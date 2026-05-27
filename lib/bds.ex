defmodule Bds do
  @moduledoc """
  Bluetab Design System (`bt-*`) for Phoenix and LiveView apps.

  ## Assets

  Styles and interaction helpers ship under `priv/static/`:

      @import "bds/styles.css";

      import {initBtInteractions} from "bds/interactions"

  Source lives in `assets/src/`. After changes, run `mix assets.build` (or
  rely on a consumer Vite alias to `assets/src` in dev for hot reload).

  ## Components

      import Bds.Components

  Or in your web module:

      use Bds, :html

  Ash Authentication Phoenix sign-in UI: `Bds.AuthBanner`, `Bds.AuthUi`.
  """

  @doc "OTP application root for `:bds`."
  @spec app_dir() :: String.t()
  def app_dir, do: Application.app_dir(:bds)

  @doc "Absolute path to the package `priv` directory."
  @spec priv_dir() :: String.t()
  def priv_dir, do: Path.join(app_dir(), "priv")

  @doc "Absolute path to compiled `bds.css`."
  @spec css_path() :: String.t()
  def css_path, do: Path.join(priv_dir(), "static/bds.css")

  @doc "Absolute path to `interactions.js`."
  @spec interactions_path() :: String.t()
  def interactions_path, do: Path.join(priv_dir(), "static/interactions.js")

  defmacro __using__(which) when which in [:html] do
    quote do
      import Bds.Components
    end
  end
end
