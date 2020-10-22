defmodule DockerAPI.Config do
  @moduledoc false

  alias DockerAPI.{Connection, Config}

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

  def inspect(config = %Config{}) do
    Connection.get(config.connection, path_for(config))
  end

  def inspect!(config = %Config{}) do
    Connection.get!(config.connection, path_for(config))
  end

  def delete(config = %Config{}) do
    Connection.delete(config.connection, path_for(config))
  end

  def delete!(config = %Config{}) do
    Connection.delete!(config.connection, path_for(config))
  end

  def update(config = %Config{}, params \\ [], body \\ %{})
      when is_list(params) and is_map(body) do
    Connection.post(config.connection, path_for(config, "update"), params, body)
  end

  def update!(config = %Config{}, params \\ [], body \\ %{})
      when is_list(params) and is_map(body) do
    Connection.post!(config.connection, path_for(config, "update"), params, body)
  end

  defp new(json, conn) do
    %Config{
      id: json["ID"],
      connection: conn
    }
  end

  defp path_for do
    "/configs"
  end

  defp path_for(path) when is_binary(path) do
    "/configs/#{path}"
  end

  defp path_for(config = %Config{}) do
    "/configs/#{config.id}"
  end

  defp path_for(config = %Config{}, path) do
    "/configs/#{config.id}/#{path}"
  end
end
