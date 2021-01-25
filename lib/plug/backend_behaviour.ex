defmodule Plug.Stats.Behaviours.Backend do
  @callback histogram(String.t(), Integer.t(), list(Keyword.t())) :: none()
end
