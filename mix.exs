defmodule PlugStats.MixProject do
  use Mix.Project

  def project do
    [
      app: :stats_plug,
      version: "1.0.0",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      description: description(),
      package: package(),
      deps: deps(),
      source_url: "https://github.com/salemove/stats_plug"
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
      {:jason, "~> 1.0", only: :test},
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false}
    ]
  end

  defp description() do
    ~S"""
    An Elixir Plug to collect statistics in your application
    and send them to your favorite backend.
    """
  end

  defp package() do
    [
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/salemove/stats_plug"}
    ]
  end
end
