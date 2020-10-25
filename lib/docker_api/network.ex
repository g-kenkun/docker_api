defmodule DockerAPI.Network do
  @moduledoc false

  alias DockerAPI.{Connection, Network}

  defstruct id: nil, connection: nil

  def list(conn, params \\ []) do
    case Connection.get(conn, path_for(), params) do
      {:ok, json} ->
        {:ok, Enum.map(json, &new(&1, conn))}

      {:error, error} ->
        {:error, error}
    end
  end

  def list!(conn, params \\ []) do
    Connection.get(conn, path_for(), params)
    |> Enum.map(&new(&1, conn))
  end

  def inspect(network, params \\ []) do
    Connection.get(network.connection, path_for(network), params)
  end

  def inspect!(network, params \\ []) do
    Connection.get!(network.connection, path_for(network), params)
  end

  def remove(network) do
    Connection.delete(network.connection, path_for(network))
  end

  def remove!(network) do
    Connection.delete!(network.connection, path_for(network))
  end

  def create(conn, body \\ %{}) do
    Connection.post(conn, path_for(:create), [], body)
  end

  def create!(conn, body \\ %{}) do
    Connection.post!(conn, path_for(:create), [], body)
  end

  def connect(network, body \\ %{}) do
    Connection.post(network.connection, path_for(network, :connect), [], body)
  end

  def connect!(network, body \\ %{}) do
    Connection.post!(network.connection, path_for(network, :connect), [], body)
  end

  def disconnect(network, body \\ %{}) when is_map(body) do
    Connection.post(network.connection, path_for(network, :disconnect), [], body)
  end

  def disconnect!(network, body \\ %{}) when is_map(body) do
    Connection.post!(network.connection, path_for(network, :disconnect), [], body)
  end

  def prune(conn, params \\ []) do
    Connection.post(conn, path_for(:prune), params)
  end

  def prune!(conn, params \\ []) do
    Connection.post!(conn, path_for(:prune), params)
  end

  defp new(json, conn) do
    %Network{
      id: json["Id"],
      connection: conn
    }
  end

  defp path_for do
    "/networks"
  end

  defp path_for(path) when is_atom(path) do
    "/networks/#{path}"
  end

  defp path_for(network) do
    "/networks/#{network.id}"
  end

  defp path_for(network, path) do
    "/networks/#{network.id}/#{path}"
  end
end
