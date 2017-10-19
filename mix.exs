defmodule ExLinePay.Mixfile do
  use Mix.Project

  def project do
    [
      app: :ex_line_pay,
      version: "0.1.0",
      elixir: "~> 1.5",
      start_permanent: Mix.env == :prod,
      deps: deps(),
      description: description(),
      package: package(),
      build_embedded: Mix.env == :prod,
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        "coveralls": :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test,
        vcr: :test,
        "vcr.delete": :test,
        "vcr.check": :test,
        "vcr.show": :test
      ],
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:httpoison, ">= 0.0.0" },
      {:poison, ">= 0.0.0", optional: true},
      {:retry, ">= 0.0.0"},
      {:ex_doc, ">= 0.0.0", only: :dev},
      {:earmark, ">= 0.0.0", only: :dev},
      {:excoveralls, ">= 0.0.0", only: :test},
      {:exvcr, ">= 0.0.0", only: [:test, :dev]},
      {:mock, ">= 0.0.0", only: :test},
      {:inch_ex, ">= 0.0.0", only: [:dev, :test]},
      {:cortex, "~> 0.1", only: [:dev, :test]},
    ]
  end

  defp description do
    """
    A LINE Pay client for Elixir.
    """
  end

  defp package do
    [
      files: ["config", "lib", "mix.exs", "README*", "LICENSE*"],
      maintainers: ["Shuhei Hayashibara"],
      licenses: ["MIT"],
      links: %{
        "GitHub" => "https://github.com/shufo/ex_line_pay",
        "Docs" => "https://hexdocs.pm/ex_line_pay"
      }
    ]
  end
end
