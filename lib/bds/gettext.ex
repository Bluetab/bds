defmodule Bds.Gettext do
  @moduledoc """
  Gettext backend for Bluetab Design System component and catalog strings.

  Host applications should import this backend (or set locale on it explicitly)
  when rendering `bt_*` components:

      use Gettext.Backend, otp_app: :my_app, imports: [{Bds.Gettext, "default"}]

  Configure form error translation separately:

      config :bds, gettext_backend: MyAppWeb.Gettext
  """
  use Gettext.Backend, otp_app: :bds
end
