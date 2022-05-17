defmodule DockerAPI.Endpoints.Plugin do
  use DockerAPI.Base, "/plugins"

  alias DockerAPI.{Connection, Error}

  @moduledoc since: "0.4.0"
  @moduledoc """
  Plugins

  ## Official document

  https://docs.docker.com/engine/api/v1.41/#tag/Plugin
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
        {:ok, Enum.map(json, &new(&1["Name"], conn))}

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
  @spec privileges(
          conn :: Connection.t(),
          params :: Connection.params(),
          headers :: Connection.headers()
        ) ::
          {:ok, term()} | {:error, Error.t()}
  def privileges(conn, params \\ %{}, headers \\ []) do
    Connection.get(conn, path_for(), params, headers)
    |> handle_json_response()
  end

  @doc since: "0.4.0"
  @spec privileges!(
          conn :: Connection.t(),
          params :: Connection.params(),
          headers :: Connection.headers()
        ) ::
          term()
  def privileges!(conn, params \\ %{}, headers \\ []) do
    privileges(conn, params, headers)
    |> bang!()
  end

  @doc since: "0.4.0"
  @spec install(
          conn :: Connection.t(),
          params :: Connection.params(),
          body :: Connection.body(),
          headers :: Connection.headers()
        ) ::
          :ok | {:error, Error.t()}
  def install(conn, params \\ %{}, body \\ nil, headers \\ []) do
    Connection.post(conn, path_for(:pull), params, body, headers)
    |> handle_no_response()
  end

  @doc since: "0.4.0"
  @spec install!(
          conn :: Connection.t(),
          params :: Connection.params(),
          body :: Connection.body(),
          headers :: Connection.headers()
        ) ::
          :ok
  def install!(conn, params \\ %{}, body \\ nil, headers \\ []) do
    install(conn, params, body, headers)
    |> bang!()
  end

  @doc since: "0.4.0"
  @spec inspect(
          plugin :: t(),
          params :: Connection.params(),
          headers :: Connection.headers()
        ) ::
          {:ok, term()} | {:error, Error.t()}
  def inspect(plugin, params \\ %{}, headers \\ []) do
    Connection.get(plugin.connection, path_for(plugin, :json), params, headers)
    |> handle_json_response()
  end

  @doc since: "0.4.0"
  @spec inspect!(
          plugin :: t(),
          params :: Connection.params(),
          headers :: Connection.headers()
        ) ::
          term()
  def inspect!(plugin, params \\ %{}, headers \\ []) do
    inspect(plugin, params, headers)
    |> bang!()
  end

  @doc since: "0.4.0"
  @spec remove(
          plugin :: t(),
          params :: Connection.params(),
          headers :: Connection.headers()
        ) ::
          {:ok, term()} | {:error, Error.t()}
  def remove(plugin, params \\ %{}, headers \\ []) do
    Connection.delete(plugin.connection, path_for(plugin), params, headers)
    |> handle_json_response()
  end

  @doc since: "0.4.0"
  @spec remove!(
          plugin :: t(),
          params :: Connection.params()
        ) ::
          term()
  def remove!(plugin, params \\ %{}, headers \\ []) do
    remove(plugin, params, headers)
    |> bang!()
  end

  @doc since: "0.4.0"
  @spec enable(
          plugin :: t(),
          params :: Connection.params(),
          body :: Connection.body(),
          headers :: Connection.headers()
        ) ::
          :ok | {:error, Error.t()}
  def enable(plugin, params \\ %{}, body \\ nil, headers \\ []) do
    Connection.post(plugin.connection, path_for(plugin, :enable), params, body, headers)
    |> handle_no_response()
  end

  @doc since: "0.4.0"
  @spec enable!(
          plugin :: t(),
          params :: Connection.params(),
          body :: Connection.body(),
          headers :: Connection.headers()
        ) ::
          :ok
  def enable!(plugin, params \\ %{}, body \\ nil, headers \\ []) do
    enable(plugin, params, body, headers)
    |> bang!()
  end

  @doc since: "0.4.0"
  @spec disable(
          plugin :: t(),
          params :: Connection.params(),
          body :: Connection.body(),
          headers :: Connection.headers()
        ) ::
          :ok | {:error, Error.t()}
  def disable(plugin, params \\ %{}, body \\ nil, headers \\ []) do
    Connection.post(plugin.connection, path_for(plugin, :disable), params, body, headers)
    |> handle_no_response()
  end

  @doc since: "0.4.0"
  @spec disable!(
          plugin :: t(),
          params :: Connection.params(),
          body :: Connection.body(),
          headers :: Connection.headers()
        ) ::
          :ok
  def disable!(plugin, params \\ %{}, body \\ nil, headers \\ []) do
    disable(plugin, params, body, headers)
    |> bang!()
  end

  @doc since: "0.4.0"
  @spec upgrade(
          plugin :: t(),
          params :: Connection.params(),
          body :: Connection.body(),
          headers :: Connection.headers()
        ) ::
          :ok | {:error, Error.t()}
  def upgrade(plugin, params \\ %{}, body \\ nil, headers \\ []) do
    Connection.post(plugin.connection, path_for(plugin, :upgrade), params, body, headers)
    |> handle_no_response()
  end

  @doc since: "0.4.0"
  @spec upgrade!(
          plugin :: t(),
          params :: Connection.params(),
          body :: Connection.body(),
          headers :: Connection.headers()
        ) ::
          :ok
  def upgrade!(plugin, params \\ %{}, body \\ nil, headers \\ []) do
    upgrade(plugin, params, body, headers)
    |> bang!()
  end

  @doc since: "0.4.0"
  @spec create(
          conn :: Connection.t(),
          params :: Connection.params(),
          body :: Connection.body(),
          headers :: Connection.headers()
        ) ::
          :ok | {:error, Error.t()}
  def create(conn, params \\ %{}, body \\ nil, headers \\ []) do
    Connection.post(conn, path_for(:create), params, body, headers)
    |> handle_no_response()
  end

  @doc since: "0.4.0"
  @spec create!(
          conn :: Connection.t(),
          params :: Connection.params(),
          body :: Connection.body(),
          headers :: Connection.headers()
        ) ::
          :ok
  def create!(conn, params \\ %{}, body \\ nil, headers \\ []) do
    create(conn, params, body, headers)
    |> bang!()
  end

  @doc since: "0.4.0"
  @spec push(
          plugin :: t(),
          params :: Connection.params(),
          body :: Connection.body(),
          headers :: Connection.headers()
        ) ::
          :ok | {:error, Error.t()}
  def push(plugin, params \\ %{}, body \\ nil, headers \\ []) do
    Connection.post(plugin.connection, path_for(plugin, :push), params, body, headers)
    |> handle_no_response()
  end

  @doc since: "0.4.0"
  @spec push!(
          plugin :: t(),
          params :: Connection.params(),
          body :: Connection.body(),
          headers :: Connection.headers()
        ) ::
          :ok
  def push!(plugin, params \\ %{}, body \\ nil, headers \\ []) do
    push(plugin, params, body, headers)
    |> bang!()
  end

  @doc since: "0.4.0"
  @spec configure(
          plugin :: t(),
          params :: Connection.params(),
          body :: Connection.body(),
          headers :: Connection.headers()
        ) ::
          :ok | {:error, Error.t()}
  def configure(plugin, params \\ %{}, body \\ nil, headers \\ []) do
    Connection.post(plugin.connection, path_for(plugin, :set), params, body, headers)
    |> handle_no_response()
  end

  @doc since: "0.4.0"
  @spec configure!(
          plugin :: t(),
          params :: Connection.params(),
          body :: Connection.body(),
          headers :: Connection.headers()
        ) ::
          :ok
  def configure!(plugin, params \\ %{}, body \\ nil, headers \\ []) do
    configure(plugin, params, body, headers)
    |> bang!()
  end
end
