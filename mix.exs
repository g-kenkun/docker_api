defmodule DockerAPI.MixProject do
  use Mix.Project

  def project do
    [
      app: :docker_api,
      version: "0.3.0",
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
      licenses: ["MIT", "Apache-2.0"],
      links: %{"GitHub" => "https://github.com/g-kenkun/docker_api"}
    ]
  end

  defp deps do
    [
      {:httpoison, "~> 1.7"},
      {:jason, "~> 1.2"},
      {:ex_doc, "~> 0.23.0", only: :dev, runtime: false}
    ]
  end

  defp docs do
    [
      main: "readme",
      extras: ["README.md"]
    ]
  end
end
