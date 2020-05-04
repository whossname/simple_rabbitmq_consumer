defmodule SimpleRabbitMQConsumer.MixProject do
  use Mix.Project

  @version "0.1.0"
  @url "https://github.com/whossname/utm_ex"
  @maintainers ["Tyson Buzza"]

  def project do
    [
      app: :simple_rabbitmq_consumer,
      version: @version,
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      name: "Simple RabbitMQ Consumer",
      description: "Simple Consumer for RabbitMQ messages",
      source_url: @url,
      homepage_url: @url,
      package: package(),
      deps: deps(),
      docs: docs(),
    ]
  end

  def package do
    [
      maintainers: @maintainers,
      licenses: ["MIT"],
      links: %{"GitHub" => @url},
      files: ~w(lib) ++ ~w(LICENSE.md mix.exs README.md)
    ]
  end

  def docs do
    [
      extras: ["README.md", "LICENSE.md"],
      source_ref: "v#{@version}",
      main: "readme"
    ]
  end

  def application do
    [
      extra_applications: [:logger],
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:amqp, "~> 1.4.0"},
      {:jason, "~> 1.1"},
      {:ex_doc, "~> 0.21", only: :dev, runtime: false},
    ]
  end
end
