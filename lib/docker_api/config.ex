defmodule DockerAPI.Config do
  @moduledoc """
  Configs are application configurations that can be used by services. Swarm mode must be enabled for these endpoints to work.

  ## Official document

  https://docs.docker.com/engine/api/v1.40/#tag/Config
  """

  alias DockerAPI.{Connection, Config}

  defstruct id: nil, connection: nil

  @doc """
  List configs

  ## Official document

  https://docs.docker.com/engine/api/v1.40/#operation/ConfigList

  ## Example

  Please help!
  """

  def list(conn, params \\ []) do
    case Connection.get(conn, path_for(), params) do
      {:ok, json} ->
        {:ok, Enum.map(json, &new(&1, conn))}

      error ->
        error
    end
  end

  @doc """
  `DockerAPI.Config.list/2`
  """

  def list!(conn, params \\ []) do
    Connection.get!(conn, path_for(), params)
    |> Enum.map(&new(&1, conn))
  end

  @doc """
  Create a config

  ## Official document

  https://docs.docker.com/engine/api/v1.40/#operation/ConfigCreate

  ## Example

  Please help!
  """

  def create(conn, body \\ %{}) do
    case Connection.post(conn, path_for(:create), [], body) do
      {:ok, json} ->
        {:ok, new(json, conn)}

      error ->
        error
    end
  end

  @doc """
  `DockerAPI.Config.create/2`
  """

  def create!(conn, body \\ %{}) do
    Connection.post!(conn, path_for(:create), [], body)
    |> new(conn)
  end

  @doc """
  Inspect a config

  ## Official document

  https://docs.docker.com/engine/api/v1.40/#operation/ConfigInspect

  ## Example

  Please help!
  """

  def inspect(config) do
    Connection.get(config.connection, path_for(config))
  end

  @doc """
  `DockerAPI.Config.inspect/1`
  """

  def inspect!(config) do
    Connection.get!(config.connection, path_for(config))
  end

  @doc """
  Delete a config

  ## Official document

  https://docs.docker.com/engine/api/v1.40/#operation/ConfigDelete

  ## Example

  Please help!
  """

  def delete(config) do
    Connection.delete(config.connection, path_for(config))
  end

  @doc """
  `DockerAPI.Config.delete/1`
  """

  def delete!(config) do
    Connection.delete!(config.connection, path_for(config))
  end

  @doc """
  Update a Config

  ## Official document

  https://docs.docker.com/engine/api/v1.40/#operation/ConfigUpdate

  ## Example

  Please help!
  """

  def update(config, params \\ [], body \\ %{}) do
    case Connection.post(config.connection, path_for(config, :update), params, body) do
      :ok ->
        {:ok, config}

      error ->
        error
    end
  end

  @doc """
  `DockerAPI.Config.update/3`
  """

  def update!(config, params \\ [], body \\ %{}) do
    Connection.post!(config.connection, path_for(config, :update), params, body)
    config
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
