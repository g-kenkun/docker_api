defmodule DockerAPI.Swarm do
  @moduledoc false

  alias DockerAPI.Connection

  def inspect(conn) do
    Connection.get(conn, path_for())
  end

  def inspect!(conn) do
    Connection.get!(conn, path_for())
  end

  def initialize(conn, body \\ %{}) do
    Connection.post(conn, path_for(:init), [], body)
  end

  def initialize!(conn, body \\ %{}) do
    Connection.post!(conn, path_for(:init), [], body)
  end

  def join(conn, body \\ %{}) do
    Connection.post(conn, path_for(:join), [], body)
  end

  def join!(conn, body \\ %{}) do
    Connection.post!(conn, path_for(:join), [], body)
  end

  def leave(conn, params \\ []) do
    Connection.get(conn, path_for(:leave), params)
  end

  def leave!(conn, params \\ []) do
    Connection.get!(conn, path_for(:leave), params)
  end

  def update(conn, params \\ [], body \\ %{}) do
    Connection.post(conn, path_for(:update), params, body)
  end

  def update!(conn, params \\ [], body \\ %{}) do
    Connection.post!(conn, path_for(:update), params, body)
  end

  def unlock_key(conn) do
    Connection.get(conn, path_for(:unlockkey))
  end

  def unlock_key!(conn) do
    Connection.get!(conn, path_for(:unlockkey))
  end

  def unlock(conn, body \\ %{}) do
    Connection.post(conn, path_for(:unlock), [], body)
  end

  def unlock!(conn, body \\ %{}) do
    Connection.post!(conn, path_for(:unlock), [], body)
  end

  defp path_for do
    "/swarm"
  end

  defp path_for(path) do
    "/swarm/#{path}"
  end
end
