defmodule DockerAPI.Config do
  @moduledoc false

  alias DockerAPI.{Connection, Config}

  defstruct id: nil, connection: nil

  def list(conn, params \\ []) do
    case Connection.get(conn, path_for(), params) do
      {:ok, json} ->
        {:ok, Enum.map(json, &new(&1, conn))}

      {:error, error} ->
        {:error, error}
    end
  end

  def list!(conn, params \\ []) do
    Connection.get(conn, path_for(), params)
    |> Enum.map(&new(&1, conn))
  end

  def create(conn, body \\ %{}) do
    case Connection.post(conn, path_for(:create), [], body) do
      {:ok, json} ->
        {:ok, new(json, conn)}

      {:error, error} ->
        {:error, error}
    end
  end

  def create!(conn, body \\ %{}) do
    Connection.post!(conn, path_for(:create), [], body)
    |> new(conn)
  end

  def inspect(config) do
    Connection.get(config.connection, path_for(config))
  end

  def inspect!(config) do
    Connection.get!(config.connection, path_for(config))
  end

  def delete(config) do
    Connection.delete(config.connection, path_for(config))
  end

  def delete!(config) do
    Connection.delete!(config.connection, path_for(config))
  end

  def update(config, params \\ [], body \\ %{}) do
    Connection.post(config.connection, path_for(config, :update), params, body)
  end

  def update!(config, params \\ [], body \\ %{}) do
    Connection.post!(config.connection, path_for(config, :update), params, body)
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

  defp path_for(path) when is_atom(path) do
    "/configs/#{path}"
  end

  defp path_for(config) do
    "/configs/#{config.id}"
  end

  defp path_for(config, path) do
    "/configs/#{config.id}/#{path}"
  end
end
