defmodule DockerAPI.Distribution do
  @moduledoc false

  alias DockerAPI.{Connection, Image}

  def inspect(image = %Image{}) do
    Connection.get(image.connection, "/distribution/#{image.id}/json")
  end

  def inspect!(image = %Image{}) do
    Connection.get!(image.connection, "/distribution/#{image.id}/json")
  end
end
