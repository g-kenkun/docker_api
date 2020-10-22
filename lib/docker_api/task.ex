defmodule DockerAPI.Task do
  @moduledoc false

  alias DockerAPI.{Connection, Task}

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
    case Connection.get!(conn, path_for(), params) do
      {:ok, json} ->
        {:ok, Enum.map(json, &new(&1, conn))}

      {:error, error} ->
        {:error, error}
    end
  end

  def inspect(task = %Task{}) do
    Connection.get(task.connection, path_for(task))
  end

  def inspect!(task = %Task{}) do
    Connection.get!(task.connection, path_for(task))
  end

  def logs(_tasks = %Task{}, params \\ []) when is_list(params) do
    :none
  end

  defp new(json, conn) do
    %Task{
      id: json["ID"],
      connection: conn
    }
  end

  defp path_for do
    "/tasks"
  end

  defp path_for(task = %Task{}) do
    "/tasks/#{task.id}"
  end

  #  defp path_for(task = %Task{}, path) do
  #    "/tasks/#{task.id}/#{path}"
  #  end
end
