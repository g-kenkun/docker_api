defmodule DockerAPI.Distribution do
  @moduledoc """
  Distribution

  ## Official document

  https://docs.docker.com/engine/api/v1.40/#tag/Distribution
  """

  alias DockerAPI.{Connection}

  @doc """
  Get image information from the registry

  ## Official document

  https://docs.docker.com/engine/api/v1.40/#tag/Distribution

  ## Example

  Please help!
  """

  def inspect(image) do
    Connection.get(image.connection, "/distribution/#{image.id}/json")
  end

  @doc """
  `DockerAPI.Distribution.inspect/1`
  """

  def inspect!(image) do
    Connection.get!(image.connection, "/distribution/#{image.id}/json")
  end
end
