defmodule DockerAPI.Endpoints.Task do
  use DockerAPI.Base, "/tasks"

  alias DockerAPI.{Connection, Error}

  @moduledoc since: "0.4.0"
  @moduledoc """
  A task is a container running on a swarm. It is the atomic scheduling unit of swarm. Swarm mode must be enabled for these endpoints to work.

  ## Official document

  https://docs.docker.com/engine/api/v1.41/#tag/Task
  """

  @type id() :: String.t()

  @type t() :: %__MODULE__{id: id(), connection: Connection.t()}

  @doc since: "0.4.0"
  @spec list(
          conn :: Connection.t(),
          params :: Connection.params(),
          headers :: Connection.headers()
        ) ::
          {:ok, [t(), ...]} | {:error, Error.t()}
  def list(conn, params \\ %{}, headers \\ []) do
    Connection.get(conn, path_for(), params, headers)
    |> handle_json_response()
    |> case do
      {:ok, json} ->
        {:ok, Enum.map(json, &new(&1["ID"], conn))}

      error ->
        error
    end
  end

  @doc since: "0.4.0"
  @spec list!(
          conn :: Connection.t(),
          params :: Connection.params(),
          headers :: Connection.headers()
        ) ::
          [t(), ...]
  def list!(conn, params \\ %{}, headers \\ []) do
    list(conn, params, headers)
    |> bang!()
  end

  @doc since: "0.4.0"
  @spec inspect(
          task :: t(),
          params :: Connection.params(),
          headers :: Connection.headers()
        ) ::
          {:ok, term()} | {:error, Error.t()}
  def inspect(task, params \\ %{}, headers \\ []) do
    Connection.get(task.connection, path_for(task), params, headers)
    |> handle_json_response()
  end

  @doc since: "0.4.0"
  @spec inspect!(
          task :: t(),
          params :: Connection.params(),
          headers :: Connection.headers()
        ) ::
          term()
  def inspect!(task, params \\ %{}, headers \\ []) do
    inspect(task, params, headers)
    |> bang!()
  end

  @doc false
  def logs(_tasks, _params) do
    :none
  end

  @doc false
  def logs!(_tasks, _params) do
    :none
  end
end
