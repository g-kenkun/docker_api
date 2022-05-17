defmodule DockerAPI.MixProject do
  use Mix.Project

  def project do
    [
      app: :docker_api,
      version: "0.4.0",
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      description: description(),
      package: package(),
      deps: deps(),
      name: "DockerAPI",
      source_url: "https://github.com/g-kenkun/docker_api",
      homepage_url: "https://github.com/g-kenkun/docker_api",
      docs: docs()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp description do
    """
    Docker remote API wrapper. This library support Containers, Images, Network, Volumes, etc...
    """
  end

  defp package do
    [
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/g-kenkun/docker_api"}
    ]
  end

  defp deps do
    [
      {:finch, "~> 0.12.0"},
      {:jason, "~> 1.3"},
      {:ex_doc, "~> 0.28.4", only: :dev, runtime: false},
      {:dialyxir, "~> 1.0", only: [:dev], runtime: false}
    ]
  end

  defp docs do
    [
      main: "readme",
      extras: ["README.md"]
    ]
  end
end
