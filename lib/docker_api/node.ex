defmodule DockerAPI.Node do
  @moduledoc false

  alias DockerAPI.{Connection, Node}

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

  def inspect(node) do
    Connection.get(node.connection, path_for(node))
  end

  def inspect!(node) do
    Connection.get!(node.connection, path_for(node))
  end

  def delete(node, params \\ []) do
    Connection.delete(node.connection, path_for(node), params)
  end

  def delete!(node, params \\ []) do
    Connection.delete!(node.connection, path_for(node), params)
  end

  def update(node, params \\ [], body \\ %{}) do
    Connection.post(node.connection, path_for(node, :update), params, body)
  end

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
