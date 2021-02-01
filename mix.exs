defmodule PlugStats.MixProject do
  use Mix.Project

  def project do
    [
      app: :stats_plug,
      version: "0.1.0",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:plug, "~> 1.11"},
      {:mox, "~> 1.0", only: :test},
      {:phoenix, "~> 1.5", only: :test},
      {:jason, "~> 1.0", only: :test}
    ]
  end
end
