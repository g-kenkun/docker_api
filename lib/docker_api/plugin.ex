defmodule DockerAPI.Plugin do
  @moduledoc """
  Plugins

  ## Official document

  https://docs.docker.com/engine/api/v1.40/#tag/Plugin
  """

  alias DockerAPI.{Connection, Plugin}

  defstruct id: nil, connection: nil

  @doc """
  List plugins

  ## Official document

  https://docs.docker.com/engine/api/v1.40/#operation/PluginList

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
  `DockerAPI.Plugin.list/2`
  """

  def list!(conn, params \\ []) do
    Connection.get!(conn, path_for(), params)
    |> Enum.map(&new(&1, conn))
  end

  @doc """
  Get plugin privileges

  ## Official document

  https://docs.docker.com/engine/api/v1.40/#operation/GetPluginPrivileges

  ## Example

  Please help!
  """

  def privileges(conn, params \\ []) do
    Connection.get(conn, path_for(), params)
  end

  @doc """
  `DockerAPI.Plugin.privileges/2`
  """

  def privileges!(conn, params \\ []) do
    Connection.get!(conn, path_for(), params)
  end

  @doc """
  Install a plugin

  ## Official document

  https://docs.docker.com/engine/api/v1.40/#operation/PluginPull

  ## Example

  Please help!
  """

  def install(conn, params \\ [], body \\ []) do
    conn
    |> Connection.add_header("X-Registry-Auth", conn.identity_token)
    |> Connection.post(path_for(:pull), params, body)
  end

  @doc """
  `DockerAPI.Plugin.install/3`
  """

  def install!(conn, params \\ [], body \\ []) do
    conn
    |> Connection.add_header("X-Registry-Auth", conn.identity_token)
    |> Connection.post!(path_for(:pull), params, body)
  end

  @doc """
  Inspect a plugin

  ## Official document

  https://docs.docker.com/engine/api/v1.40/#operation/PluginInspect

  ## Example

  Please help!
  """

  def inspect(plugin) do
    Connection.get(plugin.connection, path_for(plugin, :json))
  end

  @doc """
  `DockerAPI.Plugin.inspect/1`
  """

  def inspect!(plugin) do
    Connection.get!(plugin.connection, path_for(plugin, :json))
  end

  @doc """
  Remove a plugin

  ## Official document

  https://docs.docker.com/engine/api/v1.40/#operation/PluginDelete

  ## Example

  Please help!
  """

  def remove(plugin, params \\ []) do
    Connection.delete(plugin.connection, path_for(plugin), params)
  end

  @doc """
  `DockerAPI.Plugin.remove/2`
  """

  def remove!(plugin, params \\ []) do
    Connection.delete(plugin.connection, path_for(plugin), params)
  end

  @doc """
  Enable a plugin

  ## Official document

  https://docs.docker.com/engine/api/v1.40/#operation/PluginEnable

  ## Example

  Please help!
  """

  def enable(plugin, params \\ []) do
    Connection.post(plugin.connection, path_for(plugin, :enable), params)
  end

  @doc """
  `DockerAPI.Plugin.enable/2`
  """

  def enable!(plugin, params \\ []) do
    Connection.post!(plugin.connection, path_for(plugin, :enable), params)
  end

  @doc """
  Disable a plugin

  ## Official document

  https://docs.docker.com/engine/api/v1.40/#operation/PluginDisable

  ## Example

  Please help!
  """

  def disable(plugin) do
    Connection.post(plugin.connection, path_for(plugin, :disable))
  end

  @doc """
  `DockerAPI.Plugin.disable/1`
  """

  def disable!(plugin) do
    Connection.post!(plugin.connection, path_for(plugin, :disable))
  end

  @doc """
  Upgrade a plugin

  ## Official document

  https://docs.docker.com/engine/api/v1.40/#operation/PluginUpgrade

  ## Example

  Please help!
  """

  def upgrade(plugin, params \\ [], body \\ []) do
    case Connection.post(plugin.connection, path_for(plugin, :upgrade), params, body) do
      :ok ->
        {:ok, plugin}

      error ->
        error
    end
  end

  @doc """
  `DockerAPI.Plugin.upgrade/3`
  """

  def upgrade!(plugin, params \\ [], body \\ []) do
    Connection.post!(plugin.connection, path_for(plugin, :upgrade), params, body)
    plugin
  end

  @doc """
  Create a plugin

  ## Official document

  https://docs.docker.com/engine/api/v1.40/#operation/PluginCreate

  ## Example

  Please help!
  """

  def create(conn, body \\ "") do
    Connection.post(conn, path_for(:create), [], body)
  end

  @doc """
  `DockerAPI.Plugin.create/2`
  """

  def create!(conn, body \\ "") do
    Connection.post!(conn, path_for(:create), [], body)
  end

  @doc """
  Push a plugin

  ## Official document

  https://docs.docker.com/engine/api/v1.40/#operation/PluginPush

  ## Example

  Please help!
  """

  def push(plugin) do
    case Connection.post(plugin.connection, path_for(plugin, :push)) do
      :ok ->
        {:ok, plugin}

      error ->
        error
    end
  end

  @doc """
  `DockerAPI.Plugin.push/1`
  """

  def push!(plugin) do
    Connection.post!(plugin.connection, path_for(plugin, :push))
    plugin
  end

  @doc """
  Configure a plugin

  ## Official document

  https://docs.docker.com/engine/api/v1.40/#operation/PluginSet

  ## Example

  Please help!
  """

  def configure(plugin, body \\ []) do
    case Connection.post(plugin.connection, path_for(plugin, :set), [], body) do
      :ok ->
        {:ok, plugin}

      error ->
        error
    end
  end

  @doc """
  `DockerAPI.Plugin.configure/2`
  """

  def configure!(plugin, body \\ []) do
    Connection.post!(plugin.connection, path_for(plugin, :set), [], body)
  end

  defp new(json, conn) do
    %Plugin{
      id: json["Id"],
      connection: conn
    }
  end

  defp path_for do
    "/plugins"
  end

  defp path_for(path) when is_atom(path) do
    "/plugins/#{path}"
  end

  defp path_for(plugin = %Plugin{}) do
    "/plugins/#{plugin.id}"
  end

  defp path_for(plugin = %Plugin{}, path) do
    "/plugins/#{plugin.id}/#{path}"
  end
end
