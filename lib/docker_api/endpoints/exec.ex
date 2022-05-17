defmodule DockerAPI.Endpoints.Exec do
  use DockerAPI.Base, "/exec"

  alias DockerAPI.{Connection, Error}

  @moduledoc since: "0.4.0"
  @moduledoc """
  Run new commands inside running containers. Refer to the command-line reference for more information.

  ## Official document

  https://docs.docker.com/engine/api/v1.41/#tag/Exec
  """

  @type id() :: String.t()

  @type t() :: %__MODULE__{id: id(), connection: Connection.t()}

  @doc since: "0.4.0"
  @spec create(
          container :: Container.t(),
          params :: Connection.params(),
          body :: Connection.body(),
          headers :: Connection.headers()
        ) ::
          {:ok, t()} | {:error, Error.t()}
  def create(container, params \\ %{}, body \\ nil, headers \\ []) do
    Connection.post(
      container.connection,
      "/containers/#{container.id}/exec",
      params,
      body,
      headers
    )
    |> handle_json_response()
    |> case do
      {:ok, json} ->
        {:ok, new(json["Id"], container.connection)}

      error ->
        error
    end
  end

  @doc since: "0.4.0"
  @spec create!(
          container :: Container.t(),
          params :: Connection.params(),
          body :: Connection.body(),
          headers :: Connection.headers()
        ) ::
          t()
  def create!(container, params \\ %{}, body \\ nil, headers \\ []) do
    create(container, params, body, headers)
    |> bang!()
  end

  @doc since: "0.4.0"
  @spec start(
          exec :: t(),
          params :: Connection.params(),
          body :: Connection.body(),
          headers :: Connection.headers()
        ) ::
          :ok | {:error, Error.t()}
  def start(exec, params \\ %{}, body \\ nil, headers \\ []) do
    Connection.post(exec.connection, path_for(exec, :start), params, body, headers)
    |> handle_no_response()
  end

  @doc since: "0.4.0"
  @spec start!(
          exec :: t(),
          params :: Connection.params(),
          body :: Connection.body(),
          headers :: Connection.headers()
        ) ::
          :ok
  def start!(exec, params \\ %{}, body \\ nil, headers \\ []) do
    start(exec, params, body, headers)
    |> bang!()
  end

  @doc since: "0.4.0"
  @spec resize(
          exec :: t(),
          params :: Connection.params(),
          body :: Connection.body(),
          headers :: Connection.headers()
        ) ::
          :ok | {:error, Error.t()}
  def resize(exec, params \\ %{}, body \\ nil, headers \\ []) do
    Connection.post(exec.connection, path_for(exec, :resize), params, body, headers)
    |> handle_no_response()
  end

  @doc since: "0.4.0"
  @spec resize!(
          exec :: t(),
          params :: Connection.params(),
          body :: Connection.body(),
          headers :: Connection.headers()
        ) ::
          :ok
  def resize!(exec, params \\ %{}, body \\ nil, headers \\ []) do
    resize(exec, params, body, headers)
    |> bang!()
  end

  @doc since: "0.4.0"
  @spec inspect(
          exec :: t(),
          params :: Connection.params(),
          headers :: Connection.headers()
        ) ::
          {:ok, term()} | {:error, Error.t()}
  def inspect(exec, params \\ %{}, headers \\ []) do
    Connection.get(exec.connection, path_for(exec, :json), params, headers)
    |> handle_json_response()
  end

  @doc since: "0.4.0"
  @spec inspect(
          exec :: t(),
          params :: Connection.params(),
          headers :: Connection.headers()
        ) ::
          term()
  def inspect!(exec, params \\ %{}, headers \\ []) do
    inspect(exec, params, headers)
    |> bang!()
  end
end
