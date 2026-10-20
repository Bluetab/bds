defmodule Bds.Components.Helpers do
  @moduledoc false

  import Phoenix.Component, only: [assign: 3]

  @doc """
  Assigns `fun.()` when `key` is missing, `nil` or `""`.

  Use it instead of `assign_new/3` for optional labels: an `attr :key,
  default: nil` already puts `key: nil` in assigns, so `assign_new/3` never
  applies the translated fallback.
  """
  def assign_default(assigns, key, fun) when is_function(fun, 0) do
    case Map.get(assigns, key) do
      value when value in [nil, ""] -> assign(assigns, key, fun.())
      _ -> assigns
    end
  end
end
