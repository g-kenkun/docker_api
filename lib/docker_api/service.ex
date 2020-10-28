defmodule DockerAPI.Service do
  @moduledoc """
  Services are the definitions of tasks to run on a swarm. Swarm mode must be enabled for these endpoints to work.

  ## Official document

  https://docs.docker.com/engine/api/v1.40/#tag/Service
  """

  alias DockerAPI.{Connection, Service}

  defstruct id: nil, connection: nil

  @doc """
  List services

  ## Official document

  https://docs.docker.com/engine/api/v1.40/#operation/ServiceList

  ## Example

  Please help!
  """

  def list(conn, params \\ []) do
    case Connection.get(conn, path_for(), params) do
      {:ok, json} ->
        {:ok, Enum.map(json, &new(&1, conn))}

      error ->
        error
    end
  end

  @doc """
  `DockerAPI.Service.list/2`
  """

  def list!(conn, params \\ []) do
    Connection.get!(conn, path_for(), params)
    |> Enum.map(&new(&1, conn))
  end

  @doc """
  Create a service

  ## Official document

  https://docs.docker.com/engine/api/v1.40/#operation/ServiceCreate

  ## Example

  Please help!
  """

  def create(conn, body \\ %{}) do
    conn
    |> Connection.add_header("X-Registry-Auth", conn.identity_token)
    |> Connection.post(path_for(:create), [], body)
    |> case do
      {:ok, json} ->
        {:ok, new(json, conn)}

      error ->
        error
    end
  end

  @doc """
  `DockerAPI.Service.create/2`
  """

  def create!(conn, body \\ %{}) do
    conn
    |> Connection.add_header("X-Registry-Auth", conn.identity_token)
    |> Connection.post!(path_for(:create), [], body)
    |> new(conn)
  end

  @doc """
  Inspect a service

  ## Official document

  https://docs.docker.com/engine/api/v1.40/#operation/ServiceInspect

  ## Example

  Please help!
  """

  def inspect(service, params \\ []) do
    Connection.get(service.connection, path_for(service), params)
  end

  @doc """
  `DockerAPI.Service.inspect/2`
  """

  def inspect!(service, params \\ []) do
    Connection.get!(service.connection, path_for(service), params)
  end

  @doc """
  Delete a service

  ## Official document

  https://docs.docker.com/engine/api/v1.40/#operation/ServiceDelete

  ## Example

  Please help!
  """

  def delete(service) do
    Connection.delete(service.connection, path_for(service))
  end

  @doc """
  `DockerAPI.Service.delete/1`
  """

  def delete!(service) do
    Connection.delete!(service.connection, path_for(service))
  end

  @doc """
  Update a service

  ## Official document

  https://docs.docker.com/engine/api/v1.40/#operation/ServiceUpdate

  ## Example

  Please help!
  """

  def update(service, params \\ []) do
    service.connection
    |> Connection.add_header("X-Registry-Auth", service.connection.identity_token)
    |> Connection.post(path_for(service, :update), params)
  end

  @doc """
  `DockerAPI.Service.update/2`
  """

  def update!(service, params \\ []) do
    service.connection
    |> Connection.add_header("X-Registry-Auth", service.connection.identity_token)
    |> Connection.post!(path_for(service, :update), params)
  end

  @doc """
  Unimplemented: Get service logs

  ## Official document

  https://docs.docker.com/engine/api/v1.40/#operation/ServiceLogs

  ## Example

  Please help!
  """

  def logs(_service, _params \\ []) do
    :none
  end

  @doc """
  `DockerAPI.Service.logs/2`
  """

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
