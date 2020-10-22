defmodule DockerAPI.Secret do
  @moduledoc false

  alias DockerAPI.{Connection, Secret}

  defstruct id: nil, connection: nil

  def list(conn = %Connection{}, params \\ []) when is_list(params) do
    case Connection.get(conn, path_for(), params) do
      {:ok, json} ->
        {:ok, Enum.map(json, &new(&1, conn))}

      {:error, error} ->
        {:error, error}
    end
  end

  def list!(conn = %Connection{}, params \\ []) when is_list(params) do
    Connection.get(conn, path_for(), params)
    |> Enum.map(&new(&1, conn))
  end

  def create(conn = %Connection{}, body \\ %{}) when is_map(body) do
    case Connection.post(conn, path_for("create"), [], body) do
      {:ok, json} ->
        {:ok, new(json, conn)}

      {:error, error} ->
        {:error, error}
    end
  end

  def create!(conn = %Connection{}, body \\ %{}) when is_map(body) do
    Connection.post!(conn, path_for("create"), [], body)
    |> new(conn)
  end

  def inspect(secret = %Secret{}) do
    Connection.get(secret.connection, path_for(secret))
  end

  def inspect!(secret = %Secret{}) do
    Connection.get!(secret.connection, path_for(secret))
  end

  def delete(secret = %Secret{}) do
    Connection.delete(secret.connection, path_for(secret))
  end

  def delete!(secret = %Secret{}) do
    Connection.delete!(secret.connection, path_for(secret))
  end

  def update(secret = %Secret{}, params \\ [], body \\ %{})
      when is_list(params) and is_map(body) do
    Connection.post(secret.connection, path_for(secret, "update"), params, body)
  end

  def update!(secret = %Secret{}, params \\ [], body \\ %{}) do
    Connection.post!(secret.connection, path_for(secret, "update"), params, body)
  end

  defp new(json, conn) do
    %Secret{
      id: json["ID"],
      connection: conn
    }
  end

  defp path_for do
    "/secrets"
  end

  defp path_for(path) when is_binary(path) do
    "/secrets/#{path}"
  end

  defp path_for(secret = %Secret{}) do
    "/secrets/#{secret.id}}"
  end

  defp path_for(secret = %Secret{}, path) do
    "/secrets/#{secret.id}/#{path}"
  end
end
