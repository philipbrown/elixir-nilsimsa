defmodule Nilsimsa.MixProject do
  use Mix.Project

  def project do
    [
      app: :nilsimsa,
      version: "1.0.0",
      elixir: "~> 1.11",
      package: package(),
      description: description(),
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.html": :test
      ],
      test_coverage: [tool: ExCoveralls]
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:credo, "~> 1.5", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.1", only: [:dev], runtime: false},
      {:ex_doc, "~> 0.24", only: :dev, runtime: false},
      {:excoveralls, "~> 0.10", only: :test, runtime: false}
    ]
  end

  defp description() do
    "Nilsimsa locality-sensitive hashing algorithm in Elixir."
  end

  defp package() do
    [
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/philipbrown/elixir-nilsimsa"}
    ]
  end
end
