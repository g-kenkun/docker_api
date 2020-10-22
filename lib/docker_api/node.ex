defmodule DockerAPI.Node do
  @moduledoc false

  alias DockerAPI.{Connection, Node}

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

  def inspect(node = %Node{}) do
    Connection.get(node.connection, path_for(node))
  end

  def inspect!(node = %Node{}) do
    Connection.get!(node.connection, path_for(node))
  end

  def delete(node = %Node{}, params \\ []) when is_list(params) do
    Connection.delete(node.connection, path_for(node), params)
  end

  def delete!(node = %Node{}, params \\ []) when is_list(params) do
    Connection.delete!(node.connection, path_for(node), params)
  end

  def update(node = %Node{}, params \\ [], body \\ %{}) when is_list(params) and is_map(body) do
    Connection.post(node.connection, path_for(node, "update"), params, body)
  end

  def update!(node = %Node{}, params \\ [], body \\ %{}) when is_list(params) and is_map(body) do
    Connection.post!(node.connection, path_for(node, "update"), params, body)
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

  defp path_for(path) when is_binary(path) do
    "/nodes/#{path}"
  end

  defp path_for(node = %Node{}) do
    "/nodes/#{node.id}"
  end

  defp path_for(node = %Node{}, path) do
    "/nodes/#{node.id}/#{path}"
  end
end
