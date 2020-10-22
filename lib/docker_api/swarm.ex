defmodule DockerAPI.Swarm do
  @moduledoc false

  alias DockerAPI.Connection

  def inspect(conn = %Connection{}) do
    Connection.get(conn, path_for())
  end

  def inspect!(conn = %Connection{}) do
    Connection.get!(conn, path_for())
  end

  def initialize(conn = %Connection{}, body \\ %{}) when is_map(body) do
    Connection.post(conn, path_for("init"), [], body)
  end

  def initialize!(conn = %Connection{}, body \\ %{}) when is_map(body) do
    Connection.post!(conn, path_for("init"), [], body)
  end

  def join(conn = %Connection{}, body \\ %{}) when is_map(body) do
    Connection.post(conn, path_for("join"), [], body)
  end

  def join!(conn = %Connection{}, body \\ %{}) when is_map(body) do
    Connection.post!(conn, path_for("join"), [], body)
  end

  def leave(conn = %Connection{}, params \\ []) do
    Connection.get(conn, path_for("leave"), params)
  end

  def leave!(conn = %Connection{}, params \\ []) do
    Connection.get!(conn, path_for("leave"), params)
  end

  def update(conn = %Connection{}, params \\ [], body \\ %{})
      when is_list(params) and is_map(body) do
    Connection.post(conn, path_for("update"), params, body)
  end

  def update!(conn = %Connection{}, params \\ [], body \\ %{})
      when is_list(params) and is_map(body) do
    Connection.post!(conn, path_for("update"), params, body)
  end

  def unlock_key(conn = %Connection{}) do
    Connection.get(conn, path_for("unlockkey"))
  end

  def unlock_key!(conn = %Connection{}) do
    Connection.get!(conn, path_for("unlockkey"))
  end

  def unlock(conn = %Connection{}, body \\ %{}) when is_map(body) do
    Connection.post(conn, path_for("unlock"), [], body)
  end

  def unlock!(conn = %Connection{}, body \\ %{}) when is_map(body) do
    Connection.post!(conn, path_for("unlock"), [], body)
  end

  defp path_for do
    "/swarm"
  end

  defp path_for(path) when is_binary(path) do
    "/swarm/#{path}"
  end
end
