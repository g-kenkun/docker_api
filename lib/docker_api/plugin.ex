defmodule DockerAPI.Plugin do
  @moduledoc false

  import DockerAPI.Util

  alias DockerAPI.{Connection, Plugin}

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
    Connection.get!(conn, path_for(), params)
    |> Enum.map(&new(&1, conn))
  end

  def privileges(conn, params \\ []) do
    Connection.get(conn, path_for(), params)
  end

  def privileges!(conn, params \\ []) do
    Connection.get!(conn, path_for(), params)
  end

  def install(conn, params \\ [], body \\ []) do
    conn
    |> add_header("X-Registry-Auth", conn.identity_token)
    |> Connection.post(path_for(:pull), params, body)
  end

  def install!(conn, params \\ [], body \\ []) do
    conn
    |> add_header("X-Registry-Auth", conn.identity_token)
    |> Connection.post!(path_for(:pull), params, body)
  end

  def inspect(plugin) do
    Connection.get(plugin.connection, path_for(plugin, :json))
  end

  def inspect!(plugin) do
    Connection.get!(plugin.connection, path_for(plugin, :json))
  end

  def remove(plugin, params \\ []) do
    Connection.delete(plugin.connection, path_for(plugin), params)
  end

  def remove!(plugin, params \\ []) do
    Connection.delete(plugin.connection, path_for(plugin), params)
  end

  def enable(plugin, params \\ []) do
    Connection.post(plugin.connection, path_for(plugin, :enable), params)
  end

  def enable!(plugin, params \\ []) do
    Connection.post!(plugin.connection, path_for(plugin, :enable), params)
  end

  def disable(plugin) do
    Connection.post(plugin.connection, path_for(plugin, :disable))
  end

  def disable!(plugin) do
    Connection.post!(plugin.connection, path_for(plugin, :disable))
  end

  def upgrade(plugin, params \\ [], body \\ []) do
    Connection.post(plugin.connection, path_for(plugin, :upgrade), params, body)
  end

  def upgrade!(plugin, params \\ [], body \\ []) do
    Connection.post!(plugin.connection, path_for(plugin, :upgrade), params, body)
  end

  def create(conn, body \\ "") do
    Connection.post(conn, path_for(:create), [], body)
  end

  def create!(conn, body \\ "") do
    Connection.post!(conn, path_for(:create), [], body)
  end

  def push(plugin) do
    Connection.post(plugin.connection, path_for(plugin, :push))
  end

  def push!(plugin) do
    Connection.post!(plugin.connection, path_for(plugin, :push))
  end

  def configure(plugin, body \\ []) do
    Connection.post(plugin.connection, path_for(plugin, :set), [], body)
  end

  def configure!(plugin, body \\ []) do
    Connection.post!(plugin.connection, path_for(plugin, :set), [], body)
  end

  defp new(json, conn) do
    %Plugin{
      id: json["Id"],
      connection: conn
    }
  end

  defp path_for do
    "/plugins"
  end

  defp path_for(path) when is_atom(path) do
    "/plugins/#{path}"
  end

  defp path_for(plugin = %Plugin{}) do
    "/plugins/#{plugin.id}"
  end

  defp path_for(plugin = %Plugin{}, path) do
    "/plugins/#{plugin.id}/#{path}"
  end
end
