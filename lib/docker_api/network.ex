defmodule DockerAPI.Network do
  @moduledoc """
  Networks are user-defined networks that containers can be attached to. See the networking documentation for more information.

  ## Official document

  https://docs.docker.com/engine/api/v1.40/#tag/Network
  """

  alias DockerAPI.{Connection, Network}

  defstruct id: nil, connection: nil

  @doc """
  List networks

  ## Official document

  https://docs.docker.com/engine/api/v1.40/#operation/NetworkList

  ## Example

  DockerAPI.Connection.new() |> DockerAPI.Network.list()
  {:ok,
  [
   %DockerAPI.Network{
     connection: %DockerAPI.Connection{
       headers: [],
       identity_token: nil,
       options: [],
       url: "http+unix://%2Fvar%2Frun%2Fdocker.sock",
       version: nil
     },
     id: "6e844ca35e6de6e6c0b77c003a3efe9d7d21adc4859e447bc8a9b2fa28aa6e82"
   },
   %DockerAPI.Network{
     connection: %DockerAPI.Connection{
       headers: [],
       identity_token: nil,
       options: [],
       url: "http+unix://%2Fvar%2Frun%2Fdocker.sock",
       version: nil
     },
     id: "99ff59264e20f58b03a4749dab95cff417ad987c2959dfaba286348db0447a11"
   },
   %DockerAPI.Network{
     connection: %DockerAPI.Connection{
       headers: [],
       identity_token: nil,
       options: [],
       url: "http+unix://%2Fvar%2Frun%2Fdocker.sock",
       version: nil
     },
     id: "9017157857f5aa28f07dcbad7fdab9e43a4e874926d1129529da3237c8606ff6"
   }
  ]}
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
  `DockerAPI.Network.list/2`
  """

  def list!(conn, params \\ []) do
    Connection.get!(conn, path_for(), params)
    |> Enum.map(&new(&1, conn))
  end

  @doc """
  Inspect a network

  ## Official document

  https://docs.docker.com/engine/api/v1.40/#operation/NetworkInspect

  ## Example

  DockerAPI.Connection.new() |> DockerAPI.Network.list!() |> Enum.map(&DockerAPI.Network.inspect/1)
  [
  ok: %{
    "Attachable" => false,
    "ConfigFrom" => %{"Network" => ""},
    "ConfigOnly" => false,
    "Containers" => %{},
    "Created" => "2020-09-07T09:34:53.091003674+09:00",
    "Driver" => "host",
    "EnableIPv6" => false,
    "IPAM" => %{"Config" => [], "Driver" => "default", "Options" => nil},
    "Id" => "6e844ca35e6de6e6c0b77c003a3efe9d7d21adc4859e447bc8a9b2fa28aa6e82",
    "Ingress" => false,
    "Internal" => false,
    "Labels" => %{},
    "Name" => "host",
    "Options" => %{},
    "Scope" => "local"
  },
  ok: %{
    "Attachable" => false,
    "ConfigFrom" => %{"Network" => ""},
    "ConfigOnly" => false,
    "Containers" => %{},
    "Created" => "2020-09-07T09:34:53.07417508+09:00",
    "Driver" => "null",
    "EnableIPv6" => false,
    "IPAM" => %{"Config" => [], "Driver" => "default", "Options" => nil},
    "Id" => "99ff59264e20f58b03a4749dab95cff417ad987c2959dfaba286348db0447a11",
    "Ingress" => false,
    "Internal" => false,
    "Labels" => %{},
    "Name" => "none",
    "Options" => %{},
    "Scope" => "local"
  },
  ok: %{
    "Attachable" => false,
    "ConfigFrom" => %{"Network" => ""},
    "ConfigOnly" => false,
    "Containers" => %{},
    "Created" => "2020-10-28T06:08:55.294907253+09:00",
    "Driver" => "bridge",
    "EnableIPv6" => false,
    "IPAM" => %{
      "Config" => [%{"Gateway" => "172.17.0.1", "Subnet" => "172.17.0.0/16"}],
      "Driver" => "default",
      "Options" => nil
    },
    "Id" => "9017157857f5aa28f07dcbad7fdab9e43a4e874926d1129529da3237c8606ff6",
    "Ingress" => false,
    "Internal" => false,
    "Labels" => %{},
    "Name" => "bridge",
    "Options" => %{
      "com.docker.network.bridge.default_bridge" => "true",
      "com.docker.network.bridge.enable_icc" => "true",
      "com.docker.network.bridge.enable_ip_masquerade" => "true",
      "com.docker.network.bridge.host_binding_ipv4" => "0.0.0.0",
      "com.docker.network.bridge.name" => "docker0",
      "com.docker.network.driver.mtu" => "1500"
    },
    "Scope" => "local"
  }
  ]
  """

  def inspect(network, params \\ []) do
    Connection.get(network.connection, path_for(network), params)
  end

  @doc """
  `DockerAPI.Network.inspect/2`
  """

  def inspect!(network, params \\ []) do
    Connection.get!(network.connection, path_for(network), params)
  end

  @doc """
  Remove a network

  ## Official document

  https://docs.docker.com/engine/api/v1.40/#operation/NetworkDelete

  ## Example

  DockerAPI.Connection.new() |> DockerAPI.Network.create!(%{name: "hoge"}) |> DockerAPI.Network.remove()
  :ok
  """

  def remove(network) do
    Connection.delete(network.connection, path_for(network))
  end

  @doc """
  `DockerAPI.Network.remove/1`
  """

  def remove!(network) do
    Connection.delete!(network.connection, path_for(network))
  end

  @doc """
  Create a network

  ## Official document

  https://docs.docker.com/engine/api/v1.40/#operation/NetworkCreate

  ## Example

  {:ok,
  %DockerAPI.Network{
   connection: %DockerAPI.Connection{
     headers: [],
     identity_token: nil,
     options: [],
     url: "http+unix://%2Fvar%2Frun%2Fdocker.sock",
     version: nil
   },
   id: "edb404330f46bcebef8dfb29a3af5e8054431e20202fa0eabd7f6eaace17aa2b"
  }}

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
  `DockerAPI.Network.create/2`
  """

  def create!(conn, body \\ %{}) do
    Connection.post!(conn, path_for(:create), [], body)
    |> new(conn)
  end

  @doc """
  Connect a container to a network

  ## Official document

  https://docs.docker.com/engine/api/v1.40/#operation/NetworkConnect

  ## Example

  DockerAPI.Connection.new() |> DockerAPI.Network.create!(%{name: "hoge"}) |> DockerAPI.Network.connect(%{"Container": "fcd73c521d3145f7167518cdceeb993e42f5bc77f0ed1a2707928d0f1501addc"})
  :ok
  """

  def connect(network, body \\ %{}) do
    Connection.post(network.connection, path_for(network, :connect), [], body)
  end

  @doc """
  `DockerAPI.Network.connect/2`
  """

  def connect!(network, body \\ %{}) do
    Connection.post!(network.connection, path_for(network, :connect), [], body)
  end

  @doc """
  Disconnect a container from a network

  ## Official document

  https://docs.docker.com/engine/api/v1.40/#operation/NetworkDisconnect

  ## Example

  DockerAPI.Connection.new() |> DockerAPI.Network.create!(%{name: "hoge"}) |> DockerAPI.Network.disconnect(%{"Container": "fcd73c521d3145f7167518cdceeb993e42f5bc77f0ed1a2707928d0f1501addc"})
  :ok

  """

  def disconnect(network, body \\ %{}) when is_map(body) do
    Connection.post(network.connection, path_for(network, :disconnect), [], body)
  end

  @doc """
  `DockerAPI.Network.disconnect/2`
  """

  def disconnect!(network, body \\ %{}) when is_map(body) do
    Connection.post!(network.connection, path_for(network, :disconnect), [], body)
  end

  @doc """
  Delete unused networks

  ## Official document

  https://docs.docker.com/engine/api/v1.40/#operation/NetworkPrune

  ## Example

  DockerAPI.Connection.new() |> DockerAPI.Network.prune()
  {:ok,
  %{
   "NetworksDeleted" => ["hoge", "hoge", "hoge", "hoge", "hoge", "hoge", "hoge",
    "hoge", "hoge"]
  }}

  """

  def prune(conn, params \\ []) do
    Connection.post(conn, path_for(:prune), params)
  end

  @doc """
  `DockerAPI.Network.prune/2`
  """

  def prune!(conn, params \\ []) do
    Connection.post!(conn, path_for(:prune), params)
  end

  defp new(json, conn) do
    %Network{
      id: json["Id"],
      connection: conn
    }
  end

  defp path_for do
    "/networks"
  end

  defp path_for(path) when is_atom(path) do
    "/networks/#{path}"
  end

  defp path_for(network) do
    "/networks/#{network.id}"
  end

  defp path_for(network, path) do
    "/networks/#{network.id}/#{path}"
  end
end
