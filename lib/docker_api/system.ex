defmodule DockerAPI.System do
  @moduledoc false

  alias DockerAPI.Connection

  def auth(conn = %Connection{}, body \\ %{}) when is_map(body) do
    case Connection.post(conn, "/auth", [], body) do
      {:ok, ""} ->
        {:ok, conn}

      {:ok, json} ->
        {:ok, %Connection{conn | identity_token: json["IdentityToken"]}}

      {:error, error} ->
        {:error, error}
    end
  end

  def auth!(conn = %Connection{}, body \\ %{}) when is_map(body) do
    case Connection.post!(conn, "/auth", [], body) do
      "" ->
        conn

      json ->
        %Connection{conn | identity_token: json["IdentityToken"]}
    end
  end

  def info(conn = %Connection{}) do
    Connection.get(conn, "/info")
  end

  def info!(conn = %Connection{}) do
    Connection.get!(conn, "/info")
  end

  def version(conn = %Connection{}) do
    Connection.get(conn, "/version")
  end

  def version!(conn = %Connection{}) do
    Connection.get!(conn, "/version")
  end

  def ping_get(conn = %Connection{}) do
    Connection.get(conn, "_ping")
  end

  def ping_get!(conn = %Connection{}) do
    Connection.get!(conn, "_ping")
  end

  def ping_head(conn = %Connection{}) do
    Connection.head(conn, "_ping")
  end

  def ping_head!(conn = %Connection{}) do
    Connection.head!(conn, "_ping")
  end

  def events(_conn = %Connection{}) do
    :none
  end

  def data_usage(conn = %Connection{}) do
    Connection.get(conn, "/system/df")
  end

  def data_usage!(conn = %Connection{}) do
    Connection.get!(conn, "/system/df")
  end
end
