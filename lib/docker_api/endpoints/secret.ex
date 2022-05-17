defmodule DockerAPI.Endpoints.Secret do
  use DockerAPI.Base, "/secrets"

  alias DockerAPI.{Connection, Error}

  @moduledoc since: "0.4.0"
  @moduledoc """
  Secrets are sensitive data that can be used by services. Swarm mode must be enabled for these endpoints to work.
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
        {:ok, Enum.map(json, &new(&1, conn))}

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
          secret :: t(),
          params :: Connection.params(),
          headers :: Connection.headers()
        ) ::
          {:ok, term()} | {:error, Error.t()}
  def inspect(secret, params \\ %{}, headers \\ []) do
    Connection.get(secret.connection, path_for(secret), params, headers)
    |> handle_json_response()
  end

  @doc since: "0.4.0"
  @spec inspect(
          secret :: t(),
          params :: Connection.params(),
          headers :: Connection.headers()
        ) ::
          term()
  def inspect!(secret, params \\ %{}, headers \\ []) do
    inspect(secret, params, headers)
    |> bang!()
  end

  @doc since: "0.4.0"
  @spec delete(
          secret :: t(),
          params :: Connection.params(),
          headers :: Connection.headers()
        ) ::
          :ok | {:error, Error.t()}
  def delete(secret, params \\ %{}, headers \\ []) do
    Connection.delete(secret.connection, path_for(secret), params, headers)
    |> handle_no_response()
  end

  @doc since: "0.4.0"
  @spec delete(
          secret :: t(),
          params :: Connection.params(),
          headers :: Connection.headers()
        ) ::
          :ok
  def delete!(secret, params \\ %{}, headers \\ []) do
    delete(secret, params, headers)
    |> bang!()
  end

  @doc since: "0.4.0"
  @spec update(
          secret :: t(),
          params :: Connection.params(),
          body :: Connection.body(),
          headers :: Connection.headers()
        ) ::
          :ok | {:error, Error.t()}
  def update(secret, params \\ %{}, body \\ nil, headers \\ []) do
    Connection.post(secret.connection, path_for(secret, :update), params, body, headers)
    |> handle_no_response()
  end

  @doc since: "0.4.0"
  @spec update!(
          secret :: t(),
          params :: Connection.params(),
          body :: Connection.body(),
          headers :: Connection.headers()
        ) ::
          :ok
  def update!(secret, params \\ %{}, body \\ nil, headers \\ []) do
    update(secret, params, body, headers)
    |> bang!()
  end
end
