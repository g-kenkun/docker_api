defmodule DockerAPI.Endpoints.Config do
  use DockerAPI.Base, "/configs"

  alias DockerAPI.{Connection, Error}

  @moduledoc since: "0.4.0"
  @moduledoc """
  Configs are application configurations that can be used by services. Swarm mode must be enabled for these endpoints to work.

  ## Official document

  https://docs.docker.com/engine/api/v1.41/#tag/Config
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
  end

  @doc since: "0.4.0"
  @spec inspect(
          config :: t(),
          params :: Connection.params(),
          headers :: Connection.headers()
        ) ::
          {:ok, term()} | {:error, Error.t()}
  def inspect(config, params \\ %{}, headers \\ []) do
    Connection.get(config.connection, path_for(config), params, headers)
    |> handle_json_response()
  end

  @doc since: "0.4.0"
  @spec inspect(
          config :: t(),
          params :: Connection.params(),
          headers :: Connection.headers()
        ) ::
          term()
  def inspect!(config, params \\ %{}, headers \\ []) do
    inspect(config, params, headers)
    |> bang!()
  end

  @doc since: "0.4.0"
  @spec delete(
          config :: t(),
          params :: Connection.params(),
          headers :: Connection.headers()
        ) ::
          :ok | {:error, Error.t()}
  def delete(config, params \\ %{}, headers \\ []) do
    Connection.delete(config.connection, path_for(config), params, headers)
    |> handle_no_response()
  end

  @doc since: "0.4.0"
  @spec delete!(
          config :: t(),
          params :: Connection.params(),
          headers :: Connection.headers()
        ) ::
          :ok
  def delete!(config, params \\ %{}, headers \\ []) do
    delete(config, params, headers)
    |> bang!()
  end

  @doc since: "0.4.0"
  @spec update(
          config :: t(),
          params :: Connection.params(),
          body :: Connection.body(),
          headers :: Connection.headers()
        ) ::
          :ok | {:error, Error.t()}
  def update(config, params \\ %{}, body \\ nil, headers \\ []) do
    Connection.post(config.connection, path_for(config, :update), params, body, headers)
    |> handle_no_response()
  end

  @doc since: "0.4.0"
  @spec update!(
          config :: t(),
          params :: Connection.params(),
          body :: Connection.body(),
          headers :: Connection.headers()
        ) ::
          :ok
  def update!(config, params \\ %{}, body \\ nil, headers \\ []) do
    update(config, params, body, headers)
    |> bang!()
  end
end
