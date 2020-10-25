defmodule DockerAPI.Service do
  @moduledoc false

  import DockerAPI.Util

  alias DockerAPI.{Connection, Service}

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

  def create(conn, body \\ %{}) do
    conn
    |> add_header("X-Registry-Auth", conn.identity_token)
    |> Connection.post(path_for(:create), [], body)
    |> case do
      {:ok, json} ->
        {:ok, new(json, conn)}

      {:error, error} ->
        {:error, error}
    end
  end

  def create!(conn, body \\ %{}) do
    conn
    |> add_header("X-Registry-Auth", conn.identity_token)
    |> Connection.post!(path_for(:create), [], body)
    |> new(conn)
  end

  def inspect(service, params \\ []) do
    Connection.get(service.connection, path_for(service), params)
  end

  def inspect!(service, params \\ []) do
    Connection.get!(service.connection, path_for(service), params)
  end

  def delete(service) do
    Connection.delete(service.connection, path_for(service))
  end

  def delete!(service) do
    Connection.delete!(service.connection, path_for(service))
  end

  def update(service, params \\ []) do
    service.connection
    |> add_header("X-Registry-Auth", service.connection.identity_token)
    |> Connection.post(path_for(service, :update), params)
  end

  def update!(service, params \\ []) do
    service.connection
    |> add_header("X-Registry-Auth", service.connection.identity_token)
    |> Connection.post!(path_for(service, :update), params)
  end

  def logs(_service, _params \\ []) do
    :none
  end

  def logs!(_service, _params \\ []) do
    :none
  end

  defp new(json, conn) do
    %Service{
      id: json["ID"],
      connection: conn
    }
  end

  defp path_for do
    "/services"
  end

  defp path_for(path) when is_atom(path) do
    "/services/#{path}"
  end

  defp path_for(service) do
    "/services/#{service.id}"
  end

  defp path_for(service, path) do
    "/services/#{service.id}/#{path}"
  end
end
