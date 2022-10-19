defmodule BayesicNif.MixProject do
  use Mix.Project

  def project do
    [
      app: :bayesic_nif,
      version: "0.1.0",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      package: package(),
      deps: deps(),
      compilers: Mix.compilers()
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
      {:rustler, "~> 0.26"},

      {:benchee, "~> 1.0", only: :dev},
      {:csv, "~> 2.0", only: :dev},
      {:dialyxir, "~> 0.5", only: :dev, runtime: false},
      {:ex_doc, "~> 0.18", only: :dev, runtime: false}
    ]
  end

  defp package do
    [
      maintainers: ["Michael Ries"],
      licenses: ["MIT"],
      description: """
      A probablistic string matcher similar to Naive Bayes, but optimized for many classes with small documents
      """,
      links: %{
        github: "https://github.com/mmmries/bayesic_nif",
        docs: "http://hexdocs.pm/bayesic_nif"
      },
    ]
  end
end
