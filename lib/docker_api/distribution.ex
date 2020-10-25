defmodule DockerAPI.Distribution do
  @moduledoc false

  alias DockerAPI.{Connection}

  def inspect(image) do
    Connection.get(image.connection, "/distribution/#{image.id}/json")
  end

  def inspect!(image) do
    Connection.get!(image.connection, "/distribution/#{image.id}/json")
  end
end
