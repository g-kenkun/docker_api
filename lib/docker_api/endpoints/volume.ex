defmodule DockerAPI.Endpoints.Volume do
  use DockerAPI.Base, "/volumes"

  alias DockerAPI.{Connection, Error}

  @moduledoc since: "0.4.0"
  @moduledoc """
  Create and manage persistent storage that can be attached to containers.

  ## Official document

  https://docs.docker.com/engine/api/v1.41/#tag/Volume
  """

  @type id() :: String.t()

  @type t() :: %__MODULE__{id: id(), connection: Connection.t()}

  @doc since: "0.4.0"
  @spec list(
          conn :: Connection.t(),
          params :: Connection.params(),
          headers :: Connection.headers()
        ) ::
          {:ok, term()} | {:error, Error.t()}
  def list(conn, params \\ %{}, headers \\ []) do
    Connection.get(conn, path_for(), params, headers)
    |> handle_json_response()
    |> case do
      {:ok, json} ->
        {:ok,
         Map.update!(
           json,
           "Volumes",
           &Enum.map(&1, fn volume ->
             new(volume["Name"], conn)
           end)
         )}

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
          term()
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
        {:ok, new(json["Name"], conn)}

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
          volume :: t(),
          params :: Connection.params(),
          headers :: Connection.headers()
        ) ::
          {:ok, term()} | {:error, Error.t()}
  def inspect(volume, params \\ %{}, headers \\ []) do
    Connection.get(volume.connection, path_for(volume), params, headers)
    |> handle_json_response()
  end

  @doc since: "0.4.0"
  @spec inspect!(
          volume :: t(),
          params :: Connection.params(),
          headers :: Connection.headers()
        ) ::
          term()
  def inspect!(volume, params \\ %{}, headers \\ []) do
    inspect(volume, params, headers)
    |> bang!()
  end

  @doc since: "0.4.0"
  @spec remove(
          volume :: t(),
          params :: Connection.params(),
          headers :: Connection.headers()
        ) ::
          :ok | {:error, Error.t()}
  def remove(volume, params \\ %{}, headers \\ []) do
    Connection.delete(volume.connection, path_for(volume), params, headers)
    |> handle_no_response()
  end

  @doc since: "0.4.0"
  @spec remove!(
          volume :: t(),
          params :: Connection.params(),
          headers :: Connection.headers()
        ) ::
          :ok
  def remove!(volume, params \\ %{}, headers \\ []) do
    remove(volume, params, headers)
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
          term() | no_return()
  def prune!(conn, params \\ %{}, body \\ nil, headers \\ []) do
    prune(conn, params, body, headers)
    |> bang!()
  end
end
