defmodule DockerAPI.Swarm do
  @moduledoc """
  Engines can be clustered together in a swarm. Refer to the swarm mode documentation for more information.

  ## Official document

  https://docs.docker.com/engine/api/v1.40/#tag/Swarm
  """

  alias DockerAPI.Connection

  @doc """
  Inspect swarm

  ## Official document

  https://docs.docker.com/engine/api/v1.40/#operation/SwarmInspect

  ## Example

  Please help!
  """

  def inspect(conn) do
    Connection.get(conn, path_for())
  end

  @doc """
  `DockerAPI.Swarm.inspect/1`
  """

  def inspect!(conn) do
    Connection.get!(conn, path_for())
  end

  @doc """
  Initialize a new swarm

  ## Official document

  https://docs.docker.com/engine/api/v1.40/#operation/SwarmInit

  ## Example

  Please help!
  """

  def initialize(conn, body \\ %{}) do
    Connection.post(conn, path_for(:init), [], body)
  end

  @doc """
  `DockerAPI.Swarm.initialize/2`
  """

  def initialize!(conn, body \\ %{}) do
    Connection.post!(conn, path_for(:init), [], body)
  end

  @doc """
  Join an existing swarm

  ## Official document

  https://docs.docker.com/engine/api/v1.40/#operation/SwarmJoin

  ## Example

  Please help!
  """

  def join(conn, body \\ %{}) do
    Connection.post(conn, path_for(:join), [], body)
  end

  @doc """
  `DockerAPI.Swarm.join/2`
  """

  def join!(conn, body \\ %{}) do
    Connection.post!(conn, path_for(:join), [], body)
  end

  @doc """
  Leave a swarm

  ## Official document

  https://docs.docker.com/engine/api/v1.40/#operation/SwarmLeave

  ## Example

  Please help!
  """

  def leave(conn, params \\ []) do
    Connection.get(conn, path_for(:leave), params)
  end

  @doc """
  `DockerAPI.Swarm.leave/2`
  """

  def leave!(conn, params \\ []) do
    Connection.get!(conn, path_for(:leave), params)
  end

  @doc """
  Update a swarm

  ## Official document

  https://docs.docker.com/engine/api/v1.40/#operation/SwarmUpdate

  ## Example

  Please help!
  """

  def update(conn, params \\ [], body \\ %{}) do
    Connection.post(conn, path_for(:update), params, body)
  end

  @doc """
  `DockerAPI.Swarm.update/3`
  """

  def update!(conn, params \\ [], body \\ %{}) do
    Connection.post!(conn, path_for(:update), params, body)
  end

  @doc """
  Get the unlock key

  ## Official document

  https://docs.docker.com/engine/api/v1.40/#operation/SwarmUnlockkey

  ## Example

  Please help!
  """

  def unlock_key(conn) do
    Connection.get(conn, path_for(:unlockkey))
  end

  @doc """
  `DockerAPI.Swarm.unlock_key/1`
  """

  def unlock_key!(conn) do
    Connection.get!(conn, path_for(:unlockkey))
  end

  @doc """
  Unlock a locked manager

  ## Official document

  https://docs.docker.com/engine/api/v1.40/#operation/SwarmUnlock

  ## Example

  Please help!
  """

  def unlock(conn, body \\ %{}) do
    Connection.post(conn, path_for(:unlock), [], body)
  end

  @doc """
  `DockerAPI.Swarm.unlock/2`
  """

  def unlock!(conn, body \\ %{}) do
    Connection.post!(conn, path_for(:unlock), [], body)
  end

  defp path_for do
    "/swarm"
  end

  defp path_for(path) do
    "/swarm/#{path}"
  end
end
