defmodule DockerAPI.Endpoints.Service do
  use DockerAPI.Base, "/services"

  alias DockerAPI.{Connection, Error}

  @moduledoc since: "0.4.0"
  @moduledoc """
  Services are the definitions of tasks to run on a swarm. Swarm mode must be enabled for these endpoints to work.

  ## Official document

  https://docs.docker.com/engine/api/v1.41/#tag/Service
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
  @spec list(
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
        {:ok, new(json["ID"], conn)}

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
          service :: t(),
          params :: Connection.params(),
          headers :: Connection.headers()
        ) ::
          {:ok, term()} | {:error, Error.t()}
  def inspect(service, params \\ %{}, headers \\ []) do
    Connection.get(service.connection, path_for(service), params, headers)
    |> handle_json_response()
  end

  @doc since: "0.4.0"
  @spec inspect!(
          service :: t(),
          params :: Connection.params(),
          headers :: Connection.headers()
        ) ::
          term()
  def inspect!(service, params \\ %{}, headers \\ []) do
    inspect(service, params, headers)
    |> bang!()
  end

  @doc since: "0.4.0"
  @spec delete(
          service :: t(),
          params :: Connection.params(),
          headers :: Connection.headers()
        ) ::
          :ok | {:error, Error.t()}
  def delete(service, params \\ %{}, headers \\ []) do
    Connection.delete(service.connection, path_for(service), params, headers)
    |> handle_no_response()
  end

  @doc since: "0.4.0"
  @spec delete(
          service :: t(),
          params :: Connection.params(),
          headers :: Connection.headers()
        ) ::
          :ok
  def delete!(service, params \\ %{}, headers \\ []) do
    delete(service, params, headers)
    |> bang!()
  end

  @doc since: "0.4.0"
  @spec update(
          service :: t(),
          params :: Connection.params(),
          body :: Connection.body(),
          headers :: Connection.headers()
        ) ::
          {:ok, term()} | {:error, Error.t()}
  def update(service, params \\ %{}, body \\ nil, headers \\ []) do
    Connection.post(service.connection, path_for(service, :update), params, body, headers)
    |> handle_json_response()
  end

  @doc since: "0.4.0"
  @spec update!(
          service :: t(),
          params :: Connection.params(),
          body :: Connection.body(),
          headers :: Connection.headers()
        ) ::
          term()
  def update!(service, params \\ %{}, body \\ nil, headers \\ []) do
    update(service, params, body, headers)
    |> bang!()
  end

  @doc false
  @spec logs(
          _service :: t(),
          _params :: Connection.params(),
          _headers :: Connection.headers()
        ) ::
          :none
  def logs(_service, _params, _headers) do
    :none
  end

  @doc false
  @spec logs!(
          _service :: t(),
          _params :: Connection.params(),
          _headers :: Connection.headers()
        ) :: :none
  def logs!(_service, _params, _headers) do
    :none
  end
end
