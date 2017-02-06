defmodule Exsummary.Mixfile do
  use Mix.Project

  def project do
    [app: :exsummary,
     version: "0.1.0",
     elixir: "~> 1.4",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     preferred_cli_env: [ espec: :test ],
     test_coverage: [ tool: Coverex.Task ],
     deps: deps()]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    # Specify extra applications you'll use from Erlang/Elixir
    [extra_applications: [:logger]]
  end

  # Dependencies can be Hex packages:
  #
  #   {:my_dep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:my_dep, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [ {:espec, "1.2.1", only: :test},
      {:credo, "~> 0.5", only: [ :test, :dev ] },
      {:coverex, "~> 1.4.10", only: :test },
      {:ex_doc, ">= 0.0.0", only: :dev }
    ]
  end
end
