defmodule DockerAPI.Endpoints.System do
  use DockerAPI.Base, "/exec"

  alias DockerAPI.{Connection, Error}

  @moduledoc since: "0.4.0"
  @moduledoc """
  System

  ## Official document

  https://docs.docker.com/engine/api/v1.41/#tag/System
  """

  @doc since: "0.4.0"
  @spec auth(
          conn :: Connection.t(),
          params :: Connection.params(),
          body :: Connection.body(),
          headers :: Connection.headers()
        ) ::
          {:ok, Connection.t()} | {:error, Error.t()}
  def auth(conn, params \\ %{}, body \\ nil, headers \\ []) do
    Connection.post(conn, "/auth", params, body, headers)
    |> case do
      {:ok, nil} ->
        {:ok, conn}

      {:ok, body} ->
        json = Jason.decode!(body)

        Map.fetch(json, "IdentityToken")
        |> case do
          {:ok, identity_token} ->
            {:ok, %Connection{conn | identity_token: identity_token}}

          {:error, _} ->
            {:error, %Error{message: json["Status"]}}
        end

      error ->
        error
    end
  end

  @doc since: "0.4.0"
  @spec auth(
          conn :: Connection.t(),
          params :: Connection.params(),
          body :: Connection.body(),
          headers :: Connection.headers()
        ) ::
          Connection.t()
  def auth!(conn, params \\ %{}, body \\ nil, headers \\ []) do
    auth(conn, params, body, headers)
    |> bang!()
  end

  @doc since: "0.4.0"
  @spec info(
          conn :: Connection.t(),
          params :: Connection.params(),
          headers :: Connection.headers()
        ) ::
          {:ok, term()} | {:error, Error.t()}
  def info(conn, params \\ %{}, headers \\ []) do
    Connection.get(conn, "/info", params, headers)
    |> handle_json_response()
  end

  @doc since: "0.4.0"
  @spec info!(
          conn :: Connection.t(),
          params :: Connection.params(),
          headers :: Connection.headers()
        ) ::
          term()
  def info!(conn, params \\ %{}, headers \\ []) do
    info(conn, params, headers)
    |> bang!()
  end

  @doc since: "0.4.0"
  @spec version(
          conn :: Connection.t(),
          params :: Connection.params(),
          headers :: Connection.headers()
        ) ::
          {:ok, term()} | {:error, Error.t()}
  def version(conn, params \\ %{}, headers \\ []) do
    Connection.get(conn, "/version", params, headers)
    |> handle_json_response()
  end

  @doc since: "0.4.0"
  @spec version!(
          conn :: Connection.t(),
          params :: Connection.params(),
          headers :: Connection.headers()
        ) ::
          term()
  def version!(conn, params \\ %{}, headers \\ []) do
    version(conn, params, headers)
    |> bang!()
  end

  @doc since: "0.4.0"
  @spec ping_by_get(
          conn :: Connection.t(),
          params :: Connection.params(),
          headers :: Connection.headers()
        ) ::
          {:ok, String.t()} | {:error, Error.t()}
  def ping_by_get(conn, params \\ %{}, headers \\ []) do
    Connection.get(conn, "/_ping", params, headers)
  end

  @doc since: "0.4.0"
  @spec ping_by_get!(
          conn :: Connection.t(),
          params :: Connection.params(),
          headers :: Connection.headers()
        ) ::
          String.t()
  def ping_by_get!(conn, params \\ %{}, headers \\ []) do
    ping_by_get(conn, params, headers)
    |> bang!()
  end

  @doc since: "0.4.0"
  @spec ping_by_head(
          conn :: Connection.t(),
          params :: Connection.params(),
          headers :: Connection.headers()
        ) ::
          {:ok, Connection.headers()} | {:error, Error.t()}
  def ping_by_head(conn, params \\ %{}, headers \\ []) do
    Connection.head(conn, "/_ping", params, headers)
  end

  @doc since: "0.4.0"
  @spec ping_by_head!(
          conn :: Connection.t(),
          params :: Connection.params(),
          headers :: Connection.headers()
        ) ::
          Connection.headers()
  def ping_by_head!(conn, params \\ %{}, headers \\ []) do
    ping_by_head(conn, params, headers)
    |> bang!()
  end

  @doc false
  def events(_conn, _params, _headers) do
    :none
  end

  @doc false
  def events!(_conn, _params, _headers) do
    :none
  end

  @doc since: "0.4.0"
  @spec data_usage(
          conn :: Connection.t(),
          params :: Connection.params(),
          headers :: Connection.headers()
        ) ::
          {:ok, term()} | {:error, Error.t()}
  def data_usage(conn, params \\ %{}, headers \\ []) do
    Connection.get(conn, "/system/df", params, headers)
    |> handle_json_response()
  end

  @doc since: "0.4.0"
  @spec data_usage!(
          conn :: Connection.t(),
          params :: Connection.params(),
          headers :: Connection.headers()
        ) ::
          term()
  def data_usage!(conn, params \\ %{}, headers \\ []) do
    data_usage(conn, params, headers)
    |> bang!()
  end
end
