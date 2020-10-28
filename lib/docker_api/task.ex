defmodule DockerAPI.Task do
  @moduledoc """
  A task is a container running on a swarm. It is the atomic scheduling unit of swarm. Swarm mode must be enabled for these endpoints to work.

  ## Official document

  https://docs.docker.com/engine/api/v1.40/#tag/Task
  """

  alias DockerAPI.{Connection, Task}

  defstruct id: nil, connection: nil

  @doc """
  List tasks

  ## Officla document

  https://docs.docker.com/engine/api/v1.40/#operation/TaskList

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
  `DockerAPI.Task.list/2`
  """

  def list!(conn, params \\ []) do
    Connection.get!(conn, path_for(), params)
    |> Enum.map(&new(&1, conn))
  end

  @doc """
  Inspect a task

  ## Official document

  https://docs.docker.com/engine/api/v1.40/#operation/TaskInspect

  ## Example

  Please help!
  """

  def inspect(task) do
    Connection.get(task.connection, path_for(task))
  end

  @doc """
  `DockerAPI.Task.inspect/1`
  """

  def inspect!(task) do
    Connection.get!(task.connection, path_for(task))
  end

  @doc """
  Unimplemented: Get task logs

  ## Official document

  https://docs.docker.com/engine/api/v1.40/#operation/TaskLogs

  ## Example

  Please help!
  """

  def logs(_tasks, _params \\ []) do
    :none
  end

  @doc """
  `DockerAPI.Task.logs/2`
  """

  def logs!(_tasks, _params \\ []) do
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

  defp path_for(task) do
    "/tasks/#{task.id}"
  end
end
