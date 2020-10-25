defmodule DockerAPI.Volume do
  @moduledoc false

  alias DockerAPI.{Connection, Volume}

  defstruct name: nil, connection: nil

  def list(conn, params \\ []) do
    Connection.get(conn, path_for(), params)
  end

  def list!(conn, params \\ []) do
    Connection.get!(conn, path_for(), params)
  end

  def create(conn, body \\ %{}) do
    case Connection.post(conn, path_for(:create), [], body) do
      {:ok, json} ->
        {:ok, Enum.map(json["Volumes"], &new(&1, conn))}

      {:error, error} ->
        {:error, error}
    end
  end

  def create!(conn, body \\ %{}) do
    json = Connection.post!(conn, path_for(:create), [], body)
    Enum.map(json["volumes"], &new(&1, conn))
  end

  def inspect(volume) do
    Connection.get(volume.connection, path_for(volume))
  end

  def inspect!(volume) do
    Connection.get!(volume.connection, path_for(volume))
  end

  def delete(volume) do
    Connection.delete(volume.connection, path_for(volume))
  end

  def delete!(volume) do
    Connection.delete!(volume.connection, path_for(volume))
  end

  def prune(conn, params \\ []) do
    Connection.post(conn, path_for(:prune), params)
  end

  def prune!(conn, params \\ []) do
    Connection.post!(conn, path_for(:prune), params)
  end

  defp new(json, conn) do
    %Volume{
      name: json["Name"],
      connection: conn
    }
  end

  defp path_for do
    "/volumes"
  end

  defp path_for(path) when is_atom(path) do
    "/volumes/#{path}"
  end

  defp path_for(volume) do
    "/volumes/#{volume.name}"
  end
end
