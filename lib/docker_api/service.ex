defmodule DockerAPI.Service do
  @moduledoc false

  import DockerAPI.Util

  alias DockerAPI.{Connection, Service}

  defstruct id: nil, connection: nil

  def list(conn = %Connection{}, params \\ []) when is_list(params) do
    case Connection.get(conn, path_for(), params) do
      {:ok, json} ->
        {:ok, Enum.map(json, &new(&1, conn))}

      {:error, error} ->
        {:error, error}
    end
  end

  def list!(conn = %Connection{}, params \\ []) when is_list(params) do
    Connection.get!(conn, path_for(), params)
    |> Enum.map(&new(&1, conn))
  end

  def create(conn = %Connection{}, body \\ %{}) when is_map(body) do
    newConn = add_header(conn, "X-Registry-Auth", conn.identity_token)

    case Connection.post(newConn, path_for("create"), [], body) do
      {:ok, json} ->
        {:ok, new(json, conn)}

      {:error, error} ->
        {:error, error}
    end
  end

  def create!(conn = %Connection{}, body \\ %{}) when is_map(body) do
    newConn = add_header(conn, "X-Registry-Auth", conn.identity_token)

    Connection.post!(newConn, path_for("create"), [], body)
    |> new(conn)
  end

  def inspect(service = %Service{}, params \\ []) when is_list(params) do
    Connection.get(service.connection, path_for(service), params)
  end

  def inspect!(service = %Service{}, params \\ []) when is_list(params) do
    Connection.get!(service.connection, path_for(service), params)
  end

  def delete(service = %Service{}) do
    Connection.delete(service.connection, path_for(service))
  end

  def delete!(service = %Service{}) do
    Connection.delete!(service.connection, path_for(service))
  end

  def update(service = %Service{}, params \\ []) when is_list(params) do
    newConn = add_header(service.connection, "X-Registry-Auth", service.connection.identity_token)
    Connection.post(newConn, path_for(service, "update"), params)
  end

  def update!(service = %Service{}, params \\ []) when is_list(params) do
    newConn = add_header(service.connection, "X-Registry-Auth", service.connection.identity_token)
    Connection.post!(newConn, path_for(service, "update"), params)
  end

  def logs(_service = %Service{}, params \\ []) when is_list(params) do
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

  defp path_for(path) when is_binary(path) do
    "/services/#{path}"
  end

  defp path_for(service = %Service{}) do
    "/services/#{service.id}"
  end

  defp path_for(service = %Service{}, path) do
    "/services/#{service.id}/#{path}"
  end
end
