defmodule DockerAPI.Endpoints.Container do
  use DockerAPI.Base, "/containers"

  alias DockerAPI.{Connection, Error}

  @moduledoc since: "0.4.0"
  @moduledoc """
  Create and manage containers.

  ## Official document

  Create and manage containers.
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
    Connection.get(conn, path_for(:json), params, headers)
    |> handle_json_response()
    |> case do
      {:ok, json} ->
        {:ok, Enum.map(json, &new(&1["Id"], conn))}

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
  @spec create(
          conn :: Connection.t(),
          params :: Connection.params(),
          body :: Connection.body(),
          headers :: Connection.headers()
        ) ::
          {:ok, t()} | {:error, Error.t()}
  def create(conn, params \\ %{}, body \\ nil, headers \\ []) do
    Connection.post(conn, path_for(:create), params, body, headers)
    |> handle_json_response()
    |> case do
      {:ok, json} ->
        {:ok, new(json["Id"], conn)}

      error ->
        error
    end
  end

  @doc since: "0.4.0"
  @spec create!(
          conn :: Connection.t(),
          params :: Connection.params(),
          body :: Connection.body(),
          headers :: Connection.headers()
        ) ::
          t()
  def create!(conn, params \\ %{}, body \\ nil, headers \\ []) do
    create(conn, params, body, headers)
    |> bang!()
  end

  @doc since: "0.4.0"
  @spec inspect(
          container :: t(),
          params :: Connection.params(),
          headers :: Connection.headers()
        ) ::
          {:ok, term()} | {:error, Error.t()}
  def inspect(container, params \\ %{}, headers \\ []) do
    Connection.get(container.connection, path_for(container, :json), params, headers)
    |> handle_json_response()
  end

  @doc since: "0.4.0"
  @spec inspect!(
          container :: t(),
          params :: Connection.params(),
          headers :: Connection.headers()
        ) ::
          term()
  def inspect!(container, params \\ %{}, headers \\ []) do
    inspect(container, params, headers)
    |> bang!()
  end

  @doc since: "0.4.0"
  @spec top(
          container :: t(),
          params :: Connection.params(),
          headers :: Connection.headers()
        ) ::
          {:ok, term()} | {:error, Error.t()}
  def top(container, params \\ %{}, headers \\ []) do
    Connection.get(container.connection, path_for(container, :top), params, headers)
    |> handle_json_response()
  end

  @doc since: "0.4.0"
  @spec top!(
          container :: t(),
          params :: Connection.params(),
          headers :: Connection.headers()
        ) ::
          term()
  def top!(container, params \\ %{}, headers \\ []) do
    top(container, params, headers)
    |> bang!()
  end

  @doc false
  @spec logs(
          _container :: t(),
          _params :: Connection.params(),
          _headers :: Connection.headers()
        ) ::
          :none
  def logs(_container, _params, _headers) do
    :none
  end

  @spec logs!(
          _container :: t(),
          _params :: Connection.params(),
          _headers :: Connection.headers()
        ) ::
          :none
  def logs!(_container, _params, _headers) do
    :none
  end

  @doc false
  @spec changes(
          container :: t(),
          params :: Connection.params(),
          headers :: Connection.headers()
        ) ::
          {:ok, term()} | {:error, Error.t()}
  def changes(container, params \\ %{}, headers \\ []) do
    Connection.get(container.connection, path_for(container, :changes), params, headers)
    |> handle_json_response()
  end

  @doc since: "0.4.0"
  @spec changes!(
          container :: t(),
          params :: Connection.params(),
          headers :: Connection.headers()
        ) ::
          term()
  def changes!(container, params \\ %{}, headers \\ []) do
    changes(container, params, headers)
    |> bang!()
  end

  @doc since: "0.4.0"
  @spec export(
          container :: t(),
          params :: Connection.params(),
          headers :: Connection.headers()
        ) ::
          {:ok, binary()} | {:error, Error.t()}
  def export(container, params \\ %{}, headers \\ []) do
    Connection.get(container.connection, path_for(container, :export), params, headers)
  end

  @doc since: "0.4.0"
  @spec export!(
          container :: t(),
          params :: Connection.params(),
          headers :: Connection.headers()
        ) ::
          binary()
  def export!(container, params \\ %{}, headers \\ []) do
    export(container, params, headers)
    |> bang!()
  end

  @doc since: "0.4.0"
  @spec stats(
          container :: t(),
          params :: Connection.params(),
          headers :: Connection.headers()
        ) ::
          {:ok, term()} | {:error, Error.t()}
  def stats(container, params \\ %{}, headers \\ []) do
    Connection.get(container.connection, path_for(container, :stats), params, headers)
    |> handle_json_response()
  end

  @doc since: "0.4.0"
  @spec stats!(
          container :: t(),
          params :: Connection.params(),
          headers :: Connection.headers()
        ) ::
          term()
  def stats!(container, params \\ %{}, headers \\ []) do
    stats(container, params, headers)
    |> bang!()
  end

  @doc since: "0.4.0"
  @spec resize(
          container :: t(),
          params :: Connection.params(),
          body :: Connection.body(),
          headers :: Connection.headers()
        ) ::
          :ok | {:error, Error.t()}
  def resize(container, params \\ %{}, body \\ nil, headers \\ []) do
    Connection.post(container.connection, path_for(container, :resize), params, body, headers)
    |> handle_no_response()
  end

  @doc since: "0.4.0"
  @spec resize!(
          container :: t(),
          params :: Connection.params(),
          body :: Connection.body(),
          headers :: Connection.headers()
        ) ::
          :ok
  def resize!(container, params \\ %{}, body \\ nil, headers \\ []) do
    resize(container, params, body, headers)
    |> bang!()
  end

  @doc since: "0.4.0"
  @spec start(
          container :: t(),
          params :: Connection.params(),
          body :: Connection.body(),
          headers :: Connection.headers()
        ) ::
          :ok | {:error, Error.t()}
  def start(container, params \\ %{}, body \\ nil, headers \\ []) do
    Connection.post(container.connection, path_for(container, :start), params, body, headers)
    |> handle_no_response()
  end

  @doc since: "0.4.0"
  @spec start!(
          container :: t(),
          params :: Connection.params(),
          body :: Connection.body(),
          headers :: Connection.headers()
        ) ::
          :ok
  def start!(container, params \\ %{}, body \\ nil, headers \\ []) do
    start(container, params, body, headers)
    |> bang!()
  end

  @doc since: "0.4.0"
  @spec stop(
          container :: t(),
          params :: Connection.params(),
          body :: Connection.body(),
          headers :: Connection.headers()
        ) ::
          :ok | {:error, Error.t()}
  def stop(container, params \\ %{}, body \\ nil, headers \\ []) do
    Connection.post(container.connection, path_for(container, :stop), params, body, headers)
    |> handle_no_response()
  end

  @doc since: "0.4.0"
  @spec stop!(
          container :: t(),
          params :: Connection.params(),
          body :: Connection.body(),
          headers :: Connection.headers()
        ) ::
          :ok
  def stop!(container, params \\ %{}, body \\ nil, headers \\ []) do
    stop(container, params, body, headers)
    |> bang!()
  end

  @doc since: "0.4.0"
  @spec restart(
          container :: t(),
          params :: Connection.params(),
          body :: Connection.body(),
          headers :: Connection.headers()
        ) ::
          :ok | {:error, Error.t()}
  def restart(container, params \\ %{}, body \\ nil, headers \\ []) do
    Connection.post(container.connection, path_for(container, :restart), params, body, headers)
    |> handle_no_response()
  end

  @doc since: "0.4.0"
  @spec restart!(
          container :: t(),
          params :: Connection.params(),
          body :: Connection.body(),
          headers :: Connection.headers()
        ) ::
          :ok
  def restart!(container, params \\ %{}, body \\ nil, headers \\ []) do
    restart(container, params, body, headers)
    |> bang!()
  end

  @doc since: "0.4.0"
  @spec kill(
          container :: t(),
          params :: Connection.params(),
          body :: Connection.body(),
          headers :: Connection.headers()
        ) ::
          :ok | {:error, Error.t()}
  def kill(container, params \\ %{}, body \\ nil, headers \\ []) do
    Connection.post(container.connection, path_for(container, :kill), params, body, headers)
    |> handle_no_response()
  end

  @doc since: "0.4.0"
  @spec kill!(
          container :: t(),
          params :: Connection.params(),
          body :: Connection.body(),
          headers :: Connection.headers()
        ) ::
          :ok
  def kill!(container, params \\ %{}, body \\ nil, headers \\ []) do
    kill(container, params, body, headers)
    |> bang!()
  end

  @doc since: "0.4.0"
  @spec update(
          container :: t(),
          params :: Connection.params(),
          body :: Connection.body(),
          headers :: Connection.headers()
        ) ::
          {:ok, term()} | {:error, Error.t()}
  def update(container, params \\ %{}, body \\ nil, headers \\ []) do
    Connection.post(container.connection, path_for(container, :update), params, body, headers)
    |> handle_json_response()
  end

  @doc since: "0.4.0"
  @spec update!(
          container :: t(),
          params :: Connection.params(),
          body :: Connection.body(),
          headers :: Connection.headers()
        ) ::
          term()
  def update!(container, params \\ %{}, body \\ nil, headers \\ []) do
    update(container, params, body, headers)
    |> bang!()
  end

  @doc since: "0.4.0"
  @spec rename(
          container :: t(),
          params :: Connection.params(),
          body :: Connection.body(),
          headers :: Connection.headers()
        ) ::
          :ok | {:error, Error.t()}
  def rename(container, params \\ %{}, body \\ nil, headers \\ []) do
    Connection.post(container.connection, path_for(container, :rename), params, body, headers)
    |> handle_no_response()
  end

  @doc since: "0.4.0"
  @spec rename!(
          container :: t(),
          params :: Connection.params(),
          body :: Connection.body(),
          headers :: Connection.headers()
        ) ::
          :ok
  def rename!(container, params \\ %{}, body \\ nil, headers \\ []) do
    rename(container, params, body, headers)
    |> bang!()
  end

  @doc since: "0.4.0"
  @spec pause(
          container :: t(),
          params :: Connection.params(),
          body :: Connection.body(),
          headers :: Connection.headers()
        ) ::
          :ok | {:error, Error.t()}
  def pause(container, params \\ %{}, body \\ nil, headers \\ []) do
    Connection.post(container.connection, path_for(container, :pause), params, body, headers)
    |> handle_no_response()
  end

  @doc since: "0.4.0"
  @spec pause!(
          container :: t(),
          params :: Connection.params(),
          body :: Connection.body(),
          headers :: Connection.headers()
        ) ::
          :ok
  def pause!(container, params \\ %{}, body \\ nil, headers \\ []) do
    pause(container, params, body, headers)
    |> bang!()
  end

  @doc since: "0.4.0"
  @spec unpause(
          container :: t(),
          params :: Connection.params(),
          body :: Connection.body(),
          headers :: Connection.headers()
        ) ::
          :ok | {:error, Error.t()}
  def unpause(container, params \\ %{}, body \\ nil, headers \\ []) do
    Connection.post(container.connection, path_for(container, :unpause), params, body, headers)
    |> handle_no_response()
  end

  @doc since: "0.4.0"
  @spec unpause(
          container :: t(),
          params :: Connection.params(),
          body :: Connection.body(),
          headers :: Connection.headers()
        ) ::
          :ok
  def unpause!(container, params \\ %{}, body \\ nil, headers \\ []) do
    unpause(container, params, body, headers)
    |> bang!()
  end

  @doc false
  @spec attach(
          _container :: t(),
          _params :: Connection.params(),
          _body :: Connection.body(),
          _headers :: Connection.headers()
        ) ::
          :none
  def attach(_container, _params, _body, _headers) do
    :none
  end

  @doc false
  @spec attach!(
          _container :: t(),
          _params :: Connection.params(),
          _body :: Connection.body(),
          _headers :: Connection.headers()
        ) ::
          :none
  def attach!(_container, _params, _body, _headers) do
    :none
  end

  @doc since: "0.4.0"
  @spec wait(
          container :: t(),
          params :: Connection.params(),
          body :: Connection.body(),
          headers :: Connection.headers()
        ) ::
          {:ok, term()} | {:error, Error.t()}
  def wait(container, params \\ %{}, body \\ nil, headers \\ []) do
    Connection.post(container.connection, path_for(container, :wait), params, body, headers)
    |> handle_json_response()
  end

  @doc since: "0.4.0"
  @spec wait!(
          container :: t(),
          params :: Connection.params(),
          body :: Connection.body(),
          headers :: Connection.headers()
        ) ::
          term()
  def wait!(container, params \\ %{}, body \\ nil, headers \\ []) do
    wait(container, params, body, headers)
    |> bang!()
  end

  @doc since: "0.4.0"
  @spec remove(
          container :: t(),
          params :: Connection.params(),
          headers :: Connection.headers()
        ) ::
          :ok | {:error, Error.t()}
  def remove(container, params \\ %{}, headers \\ []) do
    Connection.delete(container.connection, path_for(container), params, headers)
    |> handle_no_response()
  end

  @doc since: "0.4.0"
  @spec remove!(
          container :: t(),
          params :: Connection.params(),
          headers :: Connection.headers()
        ) ::
          :ok
  def remove!(container, params \\ %{}, headers \\ []) do
    remove(container, params, headers)
    |> bang!()
  end

  @doc since: "0.4.0"
  @spec get_archive_by_head(
          container :: t(),
          params :: Connection.params(),
          headers :: Connection.headers()
        ) ::
          {:ok, binary()} | {:error, Error.t()}
  def get_archive_by_head(container, params \\ %{}, headers \\ []) do
    Connection.head(container.connection, path_for(container, :archive), params, headers)
    |> case do
      {:ok, headers} ->
        {:ok, Keyword.get(headers, "X-Docker-Container-Path-Stat")}

      error ->
        error
    end
  end

  @doc since: "0.4.0"
  @spec get_archive_by_head!(
          container :: t(),
          params :: Connection.params(),
          headers :: Connection.headers()
        ) ::
          binary()
  def get_archive_by_head!(container, params \\ %{}, headers \\ []) do
    get_archive_by_head(container, params, headers)
    |> bang!()
  end

  @doc since: "0.4.0"
  @spec get_archive_by_get(
          container :: t(),
          params :: Connection.params(),
          headers :: Connection.headers()
        ) ::
          {:ok, binary()} | {:error, Error.t()}
  def get_archive_by_get(container, params \\ %{}, headers \\ []) do
    Connection.get(container.connection, path_for(container, :archive), params, headers)
  end

  @doc since: "0.4.0"
  @spec get_archive_by_get!(
          container :: t(),
          params :: Connection.params(),
          headers :: Connection.headers()
        ) ::
          binary()
  def get_archive_by_get!(container, params \\ %{}, headers \\ []) do
    get_archive_by_get(container, params, headers)
    |> bang!()
  end

  @doc since: "0.4.0"
  @spec put_archive(
          container :: t(),
          params :: Connection.params(),
          body :: Connection.body(),
          headers :: Connection.headers()
        ) ::
          :ok | {:error, Error.t()}
  def put_archive(container, params \\ %{}, body \\ nil, headers \\ []) do
    Connection.put(container.connection, path_for(container, :archive), params, body, headers)
    |> handle_no_response()
  end

  @doc since: "0.4.0"
  @spec put_archive!(
          container :: t(),
          params :: Connection.params(),
          body :: Connection.body(),
          headers :: Connection.headers()
        ) ::
          :ok
  def put_archive!(container, params \\ %{}, body \\ nil, headers \\ []) do
    put_archive(container, params, body, headers)
    |> bang!()
  end

  @doc since: "0.4.0"
  @spec prune(
          container :: t(),
          params :: Connection.params(),
          body :: Connection.body(),
          headers :: Connection.headers()
        ) ::
          {:ok, term()} | {:error, Error.t()}
  def prune(conn, params \\ %{}, body \\ nil, headers \\ []) do
    Connection.post(conn, path_for(:prune), params, body, headers)
    |> handle_json_response()
  end

  @doc since: "0.4.0"
  @spec prune!(
          container :: t(),
          params :: Connection.params(),
          body :: Connection.body(),
          headers :: Connection.headers()
        ) ::
          term()
  def prune!(conn, params \\ %{}, body \\ nil, headers \\ []) do
    prune(conn, params, body, headers)
    |> bang!()
  end
end
