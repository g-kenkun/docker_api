defmodule DockerAPI.Volume do
  @moduledoc """
  Create and manage persistent storage that can be attached to containers.

  ## Official document

  https://docs.docker.com/engine/api/v1.40/#tag/Volume
  """

  alias DockerAPI.{Connection, Volume}

  defstruct name: nil, connection: nil

  @doc """
  List volumes

  ## Official document

  https://docs.docker.com/engine/api/v1.40/#operation/VolumeList

  ## Example

  DockerAPI.Connection.new() |> DockerAPI.Volume.list()
  {:ok,
  %{
   "Volumes" => [
     %DockerAPI.Volume{
       connection: %DockerAPI.Connection{
         headers: [],
         identity_token: nil,
         options: [],
         url: "http+unix://%2Fvar%2Frun%2Fdocker.sock",
         version: nil
       },
       name: "4bc26b8879909eea7352997773a24ab5d691a3bbb6153758046a655b8f6774b3"
     }
   ],
   "Warnings" => nil
  }}

  """

  def list(conn, params \\ []) do
    case Connection.get(conn, path_for(), params) do
      {:ok, json} ->
        {:ok, Map.put(json, "Volumes", Enum.map(json["Volumes"], &new(&1, conn)))}

      error ->
        error
    end
  end

  @doc """
  `DockerAPI.Volume.list/2`
  """

  def list!(conn, params \\ []) do
    json = Connection.get!(conn, path_for(), params)
    Map.put(json, "Volumes", Enum.map(json["Volumes"], &new(&1, conn)))
  end

  @doc """
  Create a volume

  ## Official document

  https://docs.docker.com/engine/api/v1.40/#operation/VolumeCreate

  ## Example

  DockerAPI.Connection.new() |> DockerAPI.Volume.create()
  %DockerAPI.Volume{
  connection: %DockerAPI.Connection{
    headers: [],
    identity_token: nil,
    options: [],
    url: "http+unix://%2Fvar%2Frun%2Fdocker.sock",
    version: nil
  },
  name: "4bc26b8879909eea7352997773a24ab5d691a3bbb6153758046a655b8f6774b3"
  }

  """

  def create(conn, body \\ %{}) do
    case Connection.post(conn, path_for(:create), [], body) do
      {:ok, json} ->
        new(json, conn)

      error ->
        error
    end
  end

  @doc """
  `DockerAPI.Volume.create/2`
  """

  def create!(conn, body \\ %{}) do
    Connection.post!(conn, path_for(:create), [], body)
    |> new(conn)
  end

  @doc """
  Inspect a volume

  ## Official document

  https://docs.docker.com/engine/api/v1.40/#operation/VolumeInspect

  ## Example

  DockerAPI.Connection.new() |> DockerAPI.Volume.list!() |> Map.get("Volumes") |> Enum.map(&DockerAPI.Volume.inspect/1)
  [
  ok: %{
    "CreatedAt" => "2020-10-27T23:10:20+09:00",
    "Driver" => "local",
    "Labels" => nil,
    "Mountpoint" => "/var/lib/docker/volumes/4bc26b8879909eea7352997773a24ab5d691a3bbb6153758046a655b8f6774b3/_data",
    "Name" => "4bc26b8879909eea7352997773a24ab5d691a3bbb6153758046a655b8f6774b3",
    "Options" => nil,
    "Scope" => "local"
  }
  ]

  """

  def inspect(volume) do
    Connection.get(volume.connection, path_for(volume))
  end

  @doc """
  `DockerAPI.Volume.inspect/1`
  """

  def inspect!(volume) do
    Connection.get!(volume.connection, path_for(volume))
  end

  @doc """
  Remove a volume

  ## Official document

  https://docs.docker.com/engine/api/v1.40/#operation/VolumeDelete

  ## Example

  DockerAPI.Connection.new() |> DockerAPI.Volume.create!() |> DockerAPI.Volume.remove()
  :ok

  """

  def remove(volume) do
    Connection.delete(volume.connection, path_for(volume))
  end

  @doc """
  `DockerAPI.Volume.remove/1`
  """

  def remove!(volume) do
    Connection.delete!(volume.connection, path_for(volume))
  end

  @doc """
  Delete unused volumes

  ## Official document

  https://docs.docker.com/engine/api/v1.40/#operation/VolumePrune

  ## Example

  DockerAPI.Connection.new() |> DockerAPI.Volume.prune()
  {:ok,
  %{
   "SpaceReclaimed" => 0,
   "VolumesDeleted" => ["4bc26b8879909eea7352997773a24ab5d691a3bbb6153758046a655b8f6774b3"]
  }}

  """

  def prune(conn, params \\ []) do
    Connection.post(conn, path_for(:prune), params)
  end

  @doc """
  `DockerAPI.Volume.prune/2`
  """

  def prune!(conn, params \\ []) do
    Connection.post!(conn, path_for(:prune), params)
  end

  defp new(json, conn) do
    %Volume{
      name: json["Name"],
      connection: conn
    }
  end

  defp path_for do
    "/volumes"
  end

  defp path_for(path) when is_atom(path) do
    "/volumes/#{path}"
  end

  defp path_for(volume) do
    "/volumes/#{volume.name}"
  end
end
