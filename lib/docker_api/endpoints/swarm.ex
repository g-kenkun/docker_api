defmodule DockerAPI.Endpoints.Swarm do
  use DockerAPI.Base, "/swarm"

  alias DockerAPI.{Connection, Error}

  @moduledoc since: "0.4.0"
  @moduledoc """
  Engines can be clustered together in a swarm. Refer to the swarm mode documentation for more information.

  ## Official document

  https://docs.docker.com/engine/api/v1.41/#tag/Swarm
  """

  @doc since: "0.4.0"
  @spec inspect(
          conn :: Connection.t(),
          params :: Connection.params(),
          headers :: Connection.headers()
        ) ::
          {:ok, term()} | {:error, Error.t()}
  def inspect(conn, params \\ %{}, headers \\ []) do
    Connection.get(conn, path_for(), params, headers)
    |> handle_json_response()
  end

  @doc since: "0.4.0"
  @spec inspect!(
          conn :: Connection.t(),
          params :: Connection.params(),
          headers :: Connection.headers()
        ) ::
          term()
  def inspect!(conn, params \\ %{}, headers \\ []) do
    inspect(conn, params, headers)
    |> bang!()
  end

  @doc since: "0.4.0"
  @spec initialize(
          conn :: Connection.t(),
          params :: Connection.params(),
          body :: Connection.body(),
          headers :: Connection.headers()
        ) ::
          {:ok, String.t()} | {:error, Error.t()}
  def initialize(conn, params \\ %{}, body \\ nil, headers \\ []) do
    Connection.post(conn, path_for(:init), params, body, headers)
  end

  @doc since: "0.4.0"
  @spec initialize!(
          conn :: Connection.t(),
          params :: Connection.params(),
          body :: Connection.body(),
          headers :: Connection.headers()
        ) ::
          String.t()
  def initialize!(conn, params \\ %{}, body \\ nil, headers \\ []) do
    initialize(conn, params, body, headers)
    |> bang!()
  end

  @doc since: "0.4.0"
  @spec join(
          conn :: Connection.t(),
          params :: Connection.params(),
          body :: Connection.body(),
          headers :: Connection.headers()
        ) ::
          :ok | {:error, Error.t()}
  def join(conn, params \\ %{}, body \\ nil, headers \\ []) do
    Connection.post(conn, path_for(:join), params, body, headers)
    |> handle_no_response()
  end

  @doc since: "0.4.0"
  @spec join!(
          conn :: Connection.t(),
          params :: Connection.params(),
          body :: Connection.body(),
          headers :: Connection.headers()
        ) ::
          :ok
  def join!(conn, params \\ %{}, body \\ nil, headers \\ []) do
    join(conn, params, body, headers)
    |> bang!()
  end

  @doc since: "0.4.0"
  @spec leave(
          conn :: Connection.t(),
          params :: Connection.params(),
          headers :: Connection.headers()
        ) ::
          :ok | {:error, Error.t()}
  def leave(conn, params \\ %{}, headers \\ []) do
    Connection.get(conn, path_for(:leave), params, headers)
    |> handle_no_response()
  end

  @doc since: "0.4.0"
  @spec leave!(
          conn :: Connection.t(),
          params :: Connection.params(),
          headers :: Connection.headers()
        ) ::
          :ok
  def leave!(conn, params \\ %{}, headers \\ []) do
    leave(conn, params, headers)
    |> bang!()
  end

  @doc since: "0.4.0"
  @spec update(
          conn :: Connection.t(),
          params :: Connection.params(),
          body :: Connection.body(),
          headers :: Connection.headers()
        ) ::
          :ok | {:error, Error.t()}
  def update(conn, params \\ %{}, body \\ nil, headers \\ []) do
    Connection.post(conn, path_for(:update), params, body, headers)
    |> handle_json_response()
  end

  @doc since: "0.4.0"
  @spec update!(
          conn :: Connection.t(),
          params :: Connection.params(),
          body :: Connection.body(),
          headers :: Connection.headers()
        ) ::
          :ok
  def update!(conn, params \\ %{}, body \\ nil, headers \\ []) do
    update(conn, params, body, headers)
    |> bang!()
  end

  @doc since: "0.4.0"
  @spec unlock_key(
          conn :: Connection.t(),
          params :: Connection.params(),
          headers :: Connection.headers()
        ) ::
          {:ok, term()} | {:error, Error.t()}
  def unlock_key(conn, params \\ %{}, headers \\ []) do
    Connection.get(conn, path_for(:unlockkey), params, headers)
    |> handle_json_response()
  end

  @doc since: "0.4.0"
  @spec unlock_key!(
          conn :: Connection.t(),
          params :: Connection.params(),
          headers :: Connection.headers()
        ) ::
          term()
  def unlock_key!(conn, params \\ %{}, headers \\ []) do
    unlock_key(conn, params, headers)
    |> bang!()
  end

  @doc since: "0.4.0"
  @spec unlock(
          conn :: Connection.t(),
          params :: Connection.params(),
          body :: Connection.body(),
          headers :: Connection.headers()
        ) ::
          :ok | {:error, Error.t()}
  def unlock(conn, params \\ %{}, body \\ nil, headers \\ []) do
    Connection.post(conn, path_for(:unlock), params, body, headers)
    |> handle_no_response()
  end

  @doc since: "0.4.0"
  @spec unlock!(
          conn :: Connection.t(),
          params :: Connection.params(),
          body :: Connection.body(),
          headers :: Connection.headers()
        ) ::
          :ok
  def unlock!(conn, params \\ %{}, body \\ nil, headers \\ []) do
    unlock(conn, params, body, headers)
    |> bang!()
  end
end
