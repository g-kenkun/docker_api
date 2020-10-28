defmodule DockerAPI.System do
  @moduledoc """
  System

  ## Official document

  https://docs.docker.com/engine/api/v1.40/#tag/System
  """

  alias DockerAPI.Connection

  @doc """
  Check auth configuration

  ## Official document

  https://docs.docker.com/engine/api/v1.40/#operation/SystemAuth

  ## Example

  Please help!
  """

  def auth(conn, body \\ %{}) do
    case Connection.post(conn, "/auth", [], body) do
      :ok ->
        {:ok, conn}

      {:ok, json} ->
        {:ok, %Connection{conn | identity_token: json["IdentityToken"]}}

      error ->
        error
    end
  end

  @doc """
  `DockerAPI.System.auth/2`
  """

  def auth!(conn, body \\ %{}) do
    case Connection.post!(conn, "/auth", [], body) do
      :ok ->
        conn

      json ->
        %Connection{conn | identity_token: json["IdentityToken"]}
    end
  end

  @doc """
  Get system information

  ## Official document

  https://docs.docker.com/engine/api/v1.40/#operation/SystemInfo

  DockerAPI.Connection.new() |> DockerAPI.System.info()
  {:ok,
  %{
   "RuncCommit" => %{
     "Expected" => "dc9208a3303feef5b3839f4323d9beb36df0a9dd",
     "ID" => "dc9208a3303feef5b3839f4323d9beb36df0a9dd"
   },
   "NGoroutines" => 175,
   "ExperimentalBuild" => false,
   "IPv4Forwarding" => true,
   "Swarm" => %{
     "ControlAvailable" => false,
     "Error" => "",
     "LocalNodeState" => "inactive",
     "NodeAddr" => "",
     "NodeID" => "",
     "RemoteManagers" => nil
   },
   "CPUShares" => true,
   "DriverStatus" => [
     ["Backing Filesystem", "extfs"],
     ["Supports d_type", "true"],
     ["Native Overlay Diff", "true"]
   ],
   "ContainersPaused" => 0,
   "OSType" => "linux",
   "Labels" => [],
   "LoggingDriver" => "json-file",
   "OperatingSystem" => "Zorin OS 15.3",
   "OomKillDisable" => true,
   "CgroupDriver" => "cgroupfs",
   "SystemTime" => "2020-10-28T01:07:36.703894481+09:00",
   "Driver" => "overlay2",
   "HttpProxy" => "",
   "Name" => "riki-desktop",
   "DockerRootDir" => "/var/lib/docker",
   "KernelMemory" => true,
   "SwapLimit" => false,
   "SystemStatus" => nil,
   "MemTotal" => 16786309120,
   "GenericResources" => nil,
   "RegistryConfig" => %{
     "AllowNondistributableArtifactsCIDRs" => [],
     "AllowNondistributableArtifactsHostnames" => [],
     "IndexConfigs" => %{
       "docker.io" => %{
         "Mirrors" => [],
         "Name" => "docker.io",
         "Official" => true,
         "Secure" => true
       }
     },
     "InsecureRegistryCIDRs" => ["127.0.0.0/8"],
     "Mirrors" => []
   },
   "Runtimes" => %{"runc" => %{"path" => "runc"}},
   "ContainerdCommit" => %{
     "Expected" => "8fba4e9a7d01810a393d5d25a3621dc101981175",
     "ID" => "8fba4e9a7d01810a393d5d25a3621dc101981175"
   },
   "ClusterStore" => "",
   "CpuCfsQuota" => true,
   "Isolation" => "",
   "NoProxy" => "",
   "NEventsListener" => 0,
   "ContainersStopped" => 5,
   "NCPU" => 16,
   "LiveRestoreEnabled" => false,
   "SecurityOptions" => ["name=apparmor", "name=seccomp,profile=default"],
   "ClusterAdvertise" => "",
   "CpuCfsPeriod" => true,
   "Debug" => false,
   "Images" => 3,
   "KernelMemoryTCP" => true,
   "ContainersRunning" => 46,
   "Warnings" => ["WARNING: No swap limit support"],
   "ServerVersion" => "19.03.13",
   "InitBinary" => "docker-init",
   "KernelVersion" => "5.4.0-52-generic",
   "Plugins" => %{"Authorization" => nil, ...},
   "HttpsProxy" => "",
   ...
  }}

  """

  def info(conn) do
    Connection.get(conn, "/info")
  end

  @doc """
  `DockerAPI.System.info/1`
  """

  def info!(conn) do
    Connection.get!(conn, "/info")
  end

  @doc """
  Get version

  ## Official document

  https://docs.docker.com/engine/api/v1.40/#operation/SystemVersion

  ## Example

  DockerAPI.Connection.new() |> DockerAPI.System.version()
  {:ok,
  %{
   "ApiVersion" => "1.40",
   "Arch" => "amd64",
   "BuildTime" => "2020-09-16T17:01:06.000000000+00:00",
   "Components" => [
     %{
       "Details" => %{
         "ApiVersion" => "1.40",
         "Arch" => "amd64",
         "BuildTime" => "2020-09-16T17:01:06.000000000+00:00",
         "Experimental" => "false",
         "GitCommit" => "4484c46d9d",
         "GoVersion" => "go1.13.15",
         "KernelVersion" => "5.4.0-52-generic",
         "MinAPIVersion" => "1.12",
         "Os" => "linux"
       },
       "Name" => "Engine",
       "Version" => "19.03.13"
     },
     %{
       "Details" => %{"GitCommit" => "8fba4e9a7d01810a393d5d25a3621dc101981175"},
       "Name" => "containerd",
       "Version" => "1.3.7"
     },
     %{
       "Details" => %{"GitCommit" => "dc9208a3303feef5b3839f4323d9beb36df0a9dd"},
       "Name" => "runc",
       "Version" => "1.0.0-rc10"
     },
     %{
       "Details" => %{"GitCommit" => "fec3683"},
       "Name" => "docker-init",
       "Version" => "0.18.0"
     }
   ],
   "GitCommit" => "4484c46d9d",
   "GoVersion" => "go1.13.15",
   "KernelVersion" => "5.4.0-52-generic",
   "MinAPIVersion" => "1.12",
   "Os" => "linux",
   "Platform" => %{"Name" => "Docker Engine - Community"},
   "Version" => "19.03.13"
  }}

  """

  def version(conn) do
    Connection.get(conn, "/version")
  end

  @doc """
  `DockerAPI.System.version/1`
  """

  def version!(conn) do
    Connection.get!(conn, "/version")
  end

  @doc """
  Ping

  ## Official document

  https://docs.docker.com/engine/api/v1.40/#operation/SystemPing

  ## Example

  DockerAPI.Connection.new() |> DockerAPI.System.ping_get()
  {:ok, "OK"}

  """

  def ping_get(conn) do
    Connection.get(conn, "/_ping")
  end

  @doc """
  `DockerAPI.System.ping_get/1`
  """

  def ping_get!(conn) do
    Connection.get!(conn, "/_ping")
  end

  @doc """
  Ping

  ## Official document

  https://docs.docker.com/engine/api/v1.40/#operation/SystemPingHead

  ## Example

  DockerAPI.Connection.new() |> DockerAPI.System.ping_head()
  {:ok,
  [
   {"Api-Version", "1.40"},
   {"Cache-Control", "no-cache, no-store, must-revalidate"},
   {"Content-Length", "0"},
   {"Content-Type", "text/plain; charset=utf-8"},
   {"Docker-Experimental", "false"},
   {"Ostype", "linux"},
   {"Pragma", "no-cache"},
   {"Server", "Docker/19.03.13 (linux)"},
   {"Date", "Tue, 27 Oct 2020 16:12:36 GMT"}
  ]}

  """

  def ping_head(conn) do
    Connection.head(conn, "/_ping")
  end

  @doc """
  `DockerAPI.System.ping_head/1`
  """

  def ping_head!(conn) do
    Connection.head!(conn, "/_ping")
  end

  @doc """
  Unimplemented: Monitor events

  ## Official document

  https://docs.docker.com/engine/api/v1.40/#operation/SystemEvents

  ## Example

  Please help!
  """

  def events(_conn) do
    :none
  end

  @doc """
  Get data usage information

  ## Official document

  https://docs.docker.com/engine/api/v1.40/#operation/SystemDataUsage

  ## Example

  DockerAPI.Connection.new() |> DockerAPI.System.data_usage()
  {:ok,
  %{
   "BuildCache" => nil,
   "BuilderSize" => 0,
   "Containers" => [],
   "Images" => [
     %{
       "Containers" => 0,
       "Created" => 1603474356,
       "Id" => "sha256:d70eaf7277eada08fca944de400e7e4dd97b1262c06ed2b1011500caa4decaf1",
       "Labels" => nil,
       "ParentId" => "",
       "RepoDigests" => ["ubuntu@sha256:fff16eea1a8ae92867721d90c59a75652ea66d29c05294e6e2f898704bdb8cf1"],
       "RepoTags" => ["ubuntu:latest"],
       "SharedSize" => 0,
       "Size" => 72879481,
       "VirtualSize" => 72879481
     },
     %{
       "Containers" => 0,
       "Created" => 1603335625,
       "Id" => "sha256:39a95ac320110ef1a6ec21e7751ad39952fdad619fe15725b182cb2e34f92fe4",
       "Labels" => nil,
       "ParentId" => "",
       "RepoDigests" => ["bash@sha256:01fad26fa8ba21bce6e8c47222acfdb54649957f1e86d53a0c8e03360271abf6"],
       "RepoTags" => ["bash:latest"],
       "SharedSize" => 0,
       "Size" => 13147898,
       "VirtualSize" => 13147898
     },
     %{
       "Containers" => 0,
       "Created" => 1578014497,
       "Id" => "sha256:bf756fb1ae65adf866bd8c456593cd24beb6a0a061dedf42b26a993176745f6b",
       "Labels" => nil,
       "ParentId" => "",
       "RepoDigests" => ["hello-world@sha256:7f0a9f93b4aa3022c3a4c147a449bf11e0941a1fd0bf4a8e6c9408b2600777c5"],
       "RepoTags" => ["hello-world:latest"],
       "SharedSize" => 0,
       "Size" => 13336,
       "VirtualSize" => 13336
     }
   ],
   "LayersSize" => 86040715,
   "Volumes" => []
  }}

  """

  def data_usage(conn) do
    Connection.get(conn, "/system/df")
  end

  @doc """
  `DockerAPI.System.data_usage/1`
  """

  def data_usage!(conn) do
    Connection.get!(conn, "/system/df")
  end
end
