defmodule Glia.StatsPlug.Behaviours.Backend do
  @callback histogram(String.t(), Integer.t(), list(Keyword.t())) :: none()
end
