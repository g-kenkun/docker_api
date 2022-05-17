defmodule DockerAPI.Endpoints.Network do
  use DockerAPI.Base, "/networks"

  alias DockerAPI.{Connection, Error}

  @moduledoc since: "0.4.0"
  @moduledoc """
  Networks are user-defined networks that containers can be attached to. See the networking documentation for more information.

  ## Official document

  https://docs.docker.com/engine/api/v1.41/#tag/Network
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
  @spec inspect(
          network :: t(),
          params :: Connection.params(),
          headers :: Connection.headers()
        ) ::
          {:ok, term()} | {:error, Error.t()}
  def inspect(network, params \\ %{}, headers \\ []) do
    Connection.get(network.connection, path_for(network), params, headers)
    |> handle_json_response()
  end

  @doc since: "0.4.0"
  @spec inspect!(
          network :: t(),
          params :: Connection.params(),
          headers :: Connection.headers()
        ) ::
          term()
  def inspect!(network, params \\ %{}, headers \\ []) do
    inspect(network, params, headers)
    |> bang!()
  end

  @doc since: "0.4.0"
  @spec remove(
          network :: t(),
          params :: Connection.params(),
          headers :: Connection.headers()
        ) ::
          :ok | {:error, Error.t()}
  def remove(network, params \\ %{}, headers \\ []) do
    Connection.delete(network.connection, path_for(network), params, headers)
    |> handle_no_response()
  end

  @doc since: "0.4.0"
  @spec remove(
          network :: t(),
          params :: Connection.params(),
          headers :: Connection.headers()
        ) ::
          :ok
  def remove!(network, params \\ %{}, headers \\ []) do
    remove(network, params, headers)
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
  @spec connect(
          conn :: Connection.t(),
          params :: Connection.params(),
          body :: Connection.body(),
          headers :: Connection.headers()
        ) ::
          :ok | {:error, Error.t()}
  def connect(network, params \\ %{}, body \\ nil, headers \\ []) do
    Connection.post(network.connection, path_for(network, :connect), params, body, headers)
    |> handle_no_response()
  end

  @doc since: "0.4.0"
  @spec connect!(
          conn :: Connection.t(),
          params :: Connection.params(),
          body :: Connection.body(),
          headers :: Connection.headers()
        ) ::
          :ok
  def connect!(network, params \\ %{}, body \\ nil, headers \\ []) do
    connect(network, params, body, headers)
    |> bang!()
  end

  @doc since: "0.4.0"
  @spec disconnect(
          network :: t(),
          params :: Connection.params(),
          body :: Connection.body(),
          headers :: Connection.headers()
        ) ::
          :ok | {:error, Error.t()}
  def disconnect(network, params \\ %{}, body \\ nil, headers \\ []) do
    Connection.post(network.connection, path_for(network, :disconnect), params, body, headers)
    |> handle_no_response()
  end

  @doc since: "0.4.0"
  @spec disconnect!(
          network :: t(),
          params :: Connection.params(),
          body :: Connection.body(),
          headers :: Connection.headers()
        ) ::
          :ok
  def disconnect!(network, params \\ %{}, body \\ nil, headers \\ []) do
    disconnect(network, params, body, headers)
    |> bang!()
  end

  @doc since: "0.4.0"
  @spec prune(
          conn :: Connection.t(),
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
          conn :: Connection.t(),
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
