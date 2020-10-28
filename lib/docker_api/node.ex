defmodule DockerAPI.Node do
  @moduledoc """
  Nodes are instances of the Engine participating in a swarm. Swarm mode must be enabled for these endpoints to work.

  ## Official document

  https://docs.docker.com/engine/api/v1.40/#tag/Node
  """

  alias DockerAPI.{Connection, Node}

  defstruct id: nil, connection: nil

  @doc """
  List nodes

  ## Official document

  https://docs.docker.com/engine/api/v1.40/#operation/NodeList

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
  `DockerAPI.Node.list/2`
  """

  def list!(conn, params \\ []) do
    Connection.get!(conn, path_for(), params)
    |> Enum.map(&new(&1, conn))
  end

  @doc """
  Inspect a node

  ## Official document

  https://docs.docker.com/engine/api/v1.40/#operation/NodeInspect

  ## Example

  Please help!
  """

  def inspect(node) do
    Connection.get(node.connection, path_for(node))
  end

  @doc """
  `DockerAPI.Node.inspect/1`
  """

  def inspect!(node) do
    Connection.get!(node.connection, path_for(node))
  end

  @doc """
  Delete a node

  ## Official document

  https://docs.docker.com/engine/api/v1.40/#operation/NodeDelete

  ## Example

  Please help!
  """

  def delete(node, params \\ []) do
    Connection.delete(node.connection, path_for(node), params)
  end

  @doc """
  `DockerAPI.Node.delete/2`
  """

  def delete!(node, params \\ []) do
    Connection.delete!(node.connection, path_for(node), params)
  end

  @doc """
  Update a node

  ## Official document

  https://docs.docker.com/engine/api/v1.40/#operation/NodeUpdate

  ## Example

  Please help!
  """

  def update(node, params \\ [], body \\ %{}) do
    case Connection.post(node.connection, path_for(node, :update), params, body) do
      :ok ->
        {:ok, node}

      error ->
        error
    end
  end

  @doc """
  `DockerAPI.Node.update/3`
  """

  def update!(node, params \\ [], body \\ %{}) do
    Connection.post!(node.connection, path_for(node, :update), params, body)
  end

  defp new(json, conn) do
    %Node{
      id: json["ID"],
      connection: conn
    }
  end

  defp path_for do
    "/nodes"
  end

  defp path_for(node) do
    "/nodes/#{node.id}"
  end

  defp path_for(node, path) do
    "/nodes/#{node.id}/#{path}"
  end
end
