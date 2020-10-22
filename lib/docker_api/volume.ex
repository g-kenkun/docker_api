defmodule DockerAPI.Volume do
  @moduledoc false

  alias DockerAPI.{Connection, Volume}

  defstruct name: nil, connection: nil

  def list(conn = %Connection{}, params \\ []) when is_list(params) do
    Connection.get(conn, path_for(), params)
  end

  def list!(conn = %Connection{}, params \\ []) when is_list(params) do
    Connection.get!(conn, path_for(), params)
  end

  def create(conn = %Connection{}, body \\ %{}) when is_map(body) do
    case Connection.post(conn, path_for("create"), [], body) do
      {:ok, json} ->
        {:ok, Enum.map(json["Volumes"], &new(&1, conn))}

      {:error, error} ->
        {:error, error}
    end
  end

  def create!(conn = %Connection{}, body \\ %{}) when is_map(body) do
    json = Connection.post!(conn, path_for("create"), [], body)
    Enum.map(json["volumes"], &new(&1, conn))
  end

  def inspect(volume = %Volume{}) do
    Connection.get(volume.connection, path_for(volume))
  end

  def inspect!(volume = %Volume{}) do
    Connection.get!(volume.connection, path_for(volume))
  end

  def delete(volume = %Volume{}) do
    Connection.delete(volume.connection, path_for(volume))
  end

  def delete!(volume = %Volume{}) do
    Connection.delete!(volume.connection, path_for(volume))
  end

  def prune(conn = %Connection{}, params \\ []) when is_list(params) do
    Connection.post(conn, path_for("prune"), params)
  end

  def prune!(conn = %Connection{}, params \\ []) when is_list(params) do
    Connection.post!(conn, path_for("prune"), params)
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

  defp path_for(path) when is_binary(path) do
    "/volumes/#{path}"
  end

  defp path_for(volume = %Volume{}) do
    "/volumes/#{volume.name}"
  end

  #  defp path_for(volume = %Volume{}, path) do
  #    "/volumes/#{volume.name}/#{path}"
  #  end
end
