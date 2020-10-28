defmodule DockerAPI.Container do
  @moduledoc """
  Create and manage containers.

  ## Official document

  Create and manage containers.
  """

  alias DockerAPI.{Connection, Container}

  defstruct id: nil, connection: nil

  @doc """
  List containers

  ## Official document

  https://docs.docker.com/engine/api/v1.40/#operation/ContainerList

  ## Example

  DockerAPI.Connection.new() |> DockerAPI.Container.list(all: true)
  {:ok,
  [
   %DockerAPI.Container{
     connection: %DockerAPI.Connection{
       headers: [],
       identity_token: nil,
       options: [],
       url: "http+unix://%2Fvar%2Frun%2Fdocker.sock",
       version: nil
     },
     id: "62433636d75e96be51a5fadea777b92460bbb0e8ae2c3099949ab59bfb972f87"
   },
   %DockerAPI.Container{
     connection: %DockerAPI.Connection{
       headers: [],
       identity_token: nil,
       options: [],
       url: "http+unix://%2Fvar%2Frun%2Fdocker.sock",
       version: nil
     },
     id: "dbaa6fe1d1d3f8355bffc92e505eb0cf24ec1a78e33de3bc26d639db8ed9b8db"
   }
  ]}
  """

  def list(conn, params \\ []) do
    case Connection.get(conn, path_for(:json), params) do
      {:ok, json} ->
        {:ok, Enum.map(json, &new(&1, conn))}

      error ->
        error
    end
  end

  @doc """
  `DockerAPI.Container.list/2`
  """
  def list!(conn, params \\ []) do
    Connection.get!(conn, path_for(:json), params)
    |> Enum.map(&new(&1, conn))
  end

  @doc """
  Create a container

  ## Official document

  https://docs.docker.com/engine/api/v1.40/#operation/ContainerCreate

  ## Example

  DockerAPI.Connection.new() |> DockerAPI.Container.create([], %{image: "sha256:bf756fb1ae65adf866bd8c456593cd24beb6a0a061dedf42b26a993176745f6b"})
  {:ok,
  %DockerAPI.Container{
   connection: %DockerAPI.Connection{
     headers: [],
     identity_token: nil,
     options: [],
     url: "http+unix://%2Fvar%2Frun%2Fdocker.sock",
     version: nil
   },
   id: "a8ad731b791dc8b97d819cfaafb7c13c882760d01afed0508bfe447e253c7a17"
  }}
  """

  def create(conn, params \\ [], body \\ %{}) do
    case Connection.post(conn, path_for(:create), params, body) do
      {:ok, json} ->
        {:ok, new(json, conn)}

      error ->
        error
    end
  end

  @doc """
  `DockerAPI.Container.create/3`
  """

  def create!(conn, params \\ [], body \\ %{}) do
    Connection.post!(conn, path_for(:create), params, body)
    |> new(conn)
  end

  @doc """
  Inspect a container

  ## Official document

  https://docs.docker.com/engine/api/v1.40/#operation/ContainerInspect

  ## Example

  DockerAPI.Connection.new() |> DockerAPI.Container.create!([], %{image: "sha256:bf756fb1ae65adf866bd8c456593cd24beb6a0a061dedf42b26a993176745f6b"}) |> DockerAPI.Container.inspect()
  {:ok,
  %{
   "AppArmorProfile" => "",
   "Args" => [],
   "Config" => %{
     "AttachStderr" => false,
     "AttachStdin" => false,
     "AttachStdout" => false,
     "Cmd" => ["/hello"],
     "Domainname" => "",
     "Entrypoint" => nil,
     "Env" => ["PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"],
     "Hostname" => "a18e04b8f932",
     "Image" => "sha256:bf756fb1ae65adf866bd8c456593cd24beb6a0a061dedf42b26a993176745f6b",
     "Labels" => %{},
     "OnBuild" => nil,
     "OpenStdin" => false,
     "StdinOnce" => false,
     "Tty" => false,
     "User" => "",
     "Volumes" => nil,
     "WorkingDir" => ""
   },
   "Created" => "2020-10-25T13:50:35.675842414Z",
   "Driver" => "overlay2",
   "ExecIDs" => nil,
   "GraphDriver" => %{
     "Data" => %{
       "LowerDir" => "/var/lib/docker/overlay2/84b8d39bd43f00d803d1e77d8e8b68bb771e700b5509c7a764e389b6476bef5b-init/diff:/var/lib/docker/overlay2/2d9b7f038b1595d500d450ea943dd008108e0ee90593c2d4aafbd2fb76aa1775/diff",
       "MergedDir" => "/var/lib/docker/overlay2/84b8d39bd43f00d803d1e77d8e8b68bb771e700b5509c7a764e389b6476bef5b/merged",
       "UpperDir" => "/var/lib/docker/overlay2/84b8d39bd43f00d803d1e77d8e8b68bb771e700b5509c7a764e389b6476bef5b/diff",
       "WorkDir" => "/var/lib/docker/overlay2/84b8d39bd43f00d803d1e77d8e8b68bb771e700b5509c7a764e389b6476bef5b/work"
     },
     "Name" => "overlay2"
   },
   "HostConfig" => %{
     "Capabilities" => nil,
     "CpusetMems" => "",
     "ShmSize" => 67108864,
     "AutoRemove" => false,
     "NetworkMode" => "default",
     "Dns" => nil,
     "DnsSearch" => nil,
     "CpuQuota" => 0,
     "PidMode" => "",
     "Memory" => 0,
     "OomKillDisable" => false,
     "CgroupParent" => "",
     "ReadonlyPaths" => ["/proc/bus", "/proc/fs", "/proc/irq", "/proc/sys",
      "/proc/sysrq-trigger"],
     "Privileged" => false,
     "DnsOptions" => nil,
     "Cgroup" => "",
     "MemorySwappiness" => nil,
     "ExtraHosts" => nil,
     "UsernsMode" => "",
     "CpuCount" => 0,
     "OomScoreAdj" => 0,
     "Ulimits" => nil,
     "KernelMemory" => 0,
     "MemorySwap" => 0,
     "UTSMode" => "",
     "BlkioWeightDevice" => nil,
     "CpusetCpus" => "",
     "Devices" => nil,
     "VolumesFrom" => nil,
     "CpuRealtimeRuntime" => 0,
     "NanoCpus" => 0,
     "BlkioWeight" => 0,
     "CpuRealtimePeriod" => 0,
     "Isolation" => "",
     "PortBindings" => nil,
     "BlkioDeviceWriteIOps" => nil,
     "BlkioDeviceWriteBps" => nil,
     "IOMaximumBandwidth" => 0,
     "PublishAllPorts" => false,
     "ReadonlyRootfs" => false,
     ...
   },
   "HostnamePath" => "",
   "HostsPath" => "",
   "Id" => "a18e04b8f9320756480eb3c390d77386152cba18e33f8f07b91c5de28135d54a",
   "Image" => "sha256:bf756fb1ae65adf866bd8c456593cd24beb6a0a061dedf42b26a993176745f6b",
   "LogPath" => "",
   "MountLabel" => "",
   "Mounts" => [],
   "Name" => "/dreamy_lewin",
   "NetworkSettings" => %{
     "Bridge" => "",
     "EndpointID" => "",
     "Gateway" => "",
     "GlobalIPv6Address" => "",
     "GlobalIPv6PrefixLen" => 0,
     "HairpinMode" => false,
     "IPAddress" => "",
     "IPPrefixLen" => 0,
     "IPv6Gateway" => "",
     "LinkLocalIPv6Address" => "",
     "LinkLocalIPv6PrefixLen" => 0,
     "MacAddress" => "",
     "Networks" => %{
       "bridge" => %{
         "Aliases" => nil,
         "DriverOpts" => nil,
         "EndpointID" => "",
         "Gateway" => "",
         "GlobalIPv6Address" => "",
         "GlobalIPv6PrefixLen" => 0,
         "IPAMConfig" => nil,
         "IPAddress" => "",
         "IPPrefixLen" => 0,
         "IPv6Gateway" => "",
         "Links" => nil,
         "MacAddress" => "",
         "NetworkID" => ""
       }
     },
     "Ports" => %{},
     "SandboxID" => "",
     "SandboxKey" => "",
     "SecondaryIPAddresses" => nil,
     "SecondaryIPv6Addresses" => nil
   },
   "Path" => "/hello",
   "Platform" => "linux",
   "ProcessLabel" => "",
   "ResolvConfPath" => "",
   "RestartCount" => 0,
   "State" => %{
     "Dead" => false,
     "Error" => "",
     "ExitCode" => 0,
     "FinishedAt" => "0001-01-01T00:00:00Z",
     "OOMKilled" => false,
     "Paused" => false,
     "Pid" => 0,
     "Restarting" => false,
     "Running" => false,
     "StartedAt" => "0001-01-01T00:00:00Z",
     "Status" => "created"
   }
  }}
  """

  def inspect(container, params \\ []) do
    Connection.get(container.connection, path_for(container, :json), params)
  end

  @doc """
  `DockerAPI.Container.inspect/2`
  """

  def inspect!(container, params \\ []) do
    Connection.get!(container.connection, path_for(container, :json), params)
  end

  @doc """
  List processes running inside a container

  ## Official document

  https://docs.docker.com/engine/api/v1.40/#operation/ContainerTop

  ## Example

  DockerAPI.Connection.new() |> DockerAPI.Container.create!([], %{image: "ubuntu"}) |> DockerAPI.Container.start!() |> DockerAPI.Container.top()
  {:ok,
  %{
   "Processes" => [
     ["root", "6240", "6218", "2", "23:04", "?", "00:00:00", "[bash]"]
   ],
   "Titles" => ["UID", "PID", "PPID", "C", "STIME", "TTY", "TIME", "CMD"]
  }}

  """

  def top(container, params \\ []) do
    Connection.get(container.connection, path_for(container, :top), params)
  end

  @doc """
  `DockerAPI.Container.top/2`
  """

  def top!(container, params \\ []) do
    Connection.get!(container.connection, path_for(container, :top), params)
  end

  @doc """
  Unimplemented: Get container logs
  """

  def logs(_container, _params \\ []) do
    :none
  end

  @doc """
  `DockerAPI.Container.logs/2`
  """

  def logs!(_container, _params \\ []) do
    :none
  end

  @doc """
  Get changes on a container’s filesystem

  ## Official document

  https://docs.docker.com/engine/api/v1.40/#operation/ContainerChanges

  ## Example

  DockerAPI.Connection.new() |> DockerAPI.Container.list!(all: true) |> List.first() |> DockerAPI.Container.changes()
  {:ok,
  [
   %{"Kind" => 0, "Path" => "/root"},
   %{"Kind" => 1, "Path" => "/root/.bash_history"},
   %{"Kind" => 1, "Path" => "/root/hoge"},
   %{"Kind" => 1, "Path" => "/root/hoge/test"}
  ]}

  """

  def changes(container) do
    Connection.get(container.connection, path_for(container, :changes))
  end

  @doc """
  `DockerAPI.Container.changes/1`
  """

  def changes!(container) do
    Connection.get!(container.connection, path_for(container, :changes))
  end

  @doc """
  Export a container

  ## Official document

  https://docs.docker.com/engine/api/v1.40/#operation/ContainerExport

  ## Example

  {:ok,
  <<46, 100, 111, 99, 107, 101, 114, 101, 110, 118, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
   0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
   0, 0, ...>>}
  """

  def export(container) do
    Connection.get(container.connection, path_for(container, :export))
  end

  @doc """
  `DockerAPI.Container.export/1`
  """

  def export!(container) do
    Connection.get!(container.connection, path_for(container, :export))
  end

  @doc """
  Get container stats based on resource usage

  ## Official document

  https://docs.docker.com/engine/api/v1.40/#operation/ContainerStats

  ## Example

  DockerAPI.Connection.new() |> DockerAPI.Container.list!(all: true) |> List.first() |> DockerAPI.Container.stats(stream: false)
  {:ok,
  %{
   "blkio_stats" => %{
     "io_merged_recursive" => nil,
     "io_queue_recursive" => nil,
     "io_service_bytes_recursive" => nil,
     "io_service_time_recursive" => nil,
     "io_serviced_recursive" => nil,
     "io_time_recursive" => nil,
     "io_wait_time_recursive" => nil,
     "sectors_recursive" => nil
   },
   "cpu_stats" => %{
     "cpu_usage" => %{
       "total_usage" => 0,
       "usage_in_kernelmode" => 0,
       "usage_in_usermode" => 0
     },
     "throttling_data" => %{
       "periods" => 0,
       "throttled_periods" => 0,
       "throttled_time" => 0
     }
   },
   "id" => "7102b72513806a281b569e604403f32ed66e0f8e7abf5b71a7547fba1a5e5f0d",
   "memory_stats" => %{},
   "name" => "/unruffled_tharp",
   "num_procs" => 0,
   "pids_stats" => %{},
   "precpu_stats" => %{
     "cpu_usage" => %{
       "total_usage" => 0,
       "usage_in_kernelmode" => 0,
       "usage_in_usermode" => 0
     },
     "throttling_data" => %{
       "periods" => 0,
       "throttled_periods" => 0,
       "throttled_time" => 0
     }
   },
   "preread" => "0001-01-01T00:00:00Z",
   "read" => "0001-01-01T00:00:00Z",
   "storage_stats" => %{}
  }}
  """

  def stats(container, params \\ []) do
    Connection.get(container.connection, path_for(container, :stats), params)
  end

  @doc """
  `DockerAPI.Container.stats/2`
  """

  def stats!(container, params \\ []) do
    Connection.get!(container.connection, path_for(container, :stats), params)
  end

  @doc """
  Resize a container TTY

  ## Official document

  https://docs.docker.com/engine/api/v1.40/#operation/ContainerResize

  ## Example

  DockerAPI.Connection.new() |> DockerAPI.Container.list!(all: true) |> List.first() |> DockerAPI.Container.resize(h: 110, w: 110)
  {:ok,
  %DockerAPI.Container{
   connection: %DockerAPI.Connection{
     headers: [],
     identity_token: nil,
     options: [],
     url: "http+unix://%2Fvar%2Frun%2Fdocker.sock",
     version: nil
   },
   id: "7102b72513806a281b569e604403f32ed66e0f8e7abf5b71a7547fba1a5e5f0d"
  }}
  """

  def resize(container, params \\ []) do
    case Connection.post(container.connection, path_for(container, :resize), params) do
      :ok ->
        {:ok, container}

      error ->
        error
    end
  end

  @doc """
  `DockerAPI.Container.resize/2`
  """

  def resize!(container, params \\ []) do
    Connection.post!(container.connection, path_for(container, :resize), params)
    container
  end

  @doc """
  Start a container

  ## Official document

  https://docs.docker.com/engine/api/v1.40/#operation/ContainerStart

  ## Example

  DockerAPI.Connection.new() |> DockerAPI.Container.create!([], %{image: "ubuntu:latest"}) |> DockerAPI.Container.start()
  {:ok,
  %DockerAPI.Container{
   connection: %DockerAPI.Connection{
     headers: [],
     identity_token: nil,
     options: [],
     url: "http+unix://%2Fvar%2Frun%2Fdocker.sock",
     version: nil
   },
   id: "08c635bb1667c963cbff8191cbd2144f6e78cb504ed8618285de4a19137ece7f"
  }}
  """

  def start(container, params \\ []) do
    case Connection.post(container.connection, path_for(container, :start), params) do
      :ok ->
        {:ok, container}

      error ->
        error
    end
  end

  @doc """
  `DockerAPI.Container.start/2`
  """

  def start!(container, params \\ []) do
    Connection.post!(container.connection, path_for(container, :start), params)
    container
  end

  @doc """
  Stop a container

  ## Official document

  https://docs.docker.com/engine/api/v1.40/#operation/ContainerStop

  ## Example

  DockerAPI.Connection.new() |> DockerAPI.Container.list!(all: true) |> List.first() |> DockerAPI.Container.start!() |> DockerAPI.Container.stop()
  {:ok,
  %DockerAPI.Container{
   connection: %DockerAPI.Connection{
     headers: [],
     identity_token: nil,
     options: [],
     url: "http+unix://%2Fvar%2Frun%2Fdocker.sock",
     version: nil
   },
   id: "08c635bb1667c963cbff8191cbd2144f6e78cb504ed8618285de4a19137ece7f"
  }}
  """

  def stop(container, params \\ []) do
    case Connection.post(container.connection, path_for(container, :stop), params) do
      :ok ->
        {:ok, container}

      error ->
        error
    end
  end

  @doc """
  `DockerAPI.Container.stop/2`
  """

  def stop!(container, params \\ []) do
    Connection.post!(container.connection, path_for(container, :stop), params)
    container
  end

  @doc """
  Restart a container

  ## Official document

  https://docs.docker.com/engine/api/v1.40/#operation/ContainerRestart

  ## Example

  DockerAPI.Connection.new() |> DockerAPI.Container.list!(all: true) |> List.first() |> DockerAPI.Container.start!() |> DockerAPI.Container.restart()
  {:ok,
  %DockerAPI.Container{
   connection: %DockerAPI.Connection{
     headers: [],
     identity_token: nil,
     options: [],
     url: "http+unix://%2Fvar%2Frun%2Fdocker.sock",
     version: nil
   },
   id: "08c635bb1667c963cbff8191cbd2144f6e78cb504ed8618285de4a19137ece7f"
  }}
  """

  def restart(container, params \\ []) do
    case Connection.post(container.connection, path_for(container, :restart), params) do
      :ok ->
        {:ok, container}

      error ->
        error
    end
  end

  @doc """
  `DockerAPI.Container.restart/2`
  """

  def restart!(container, params \\ []) do
    Connection.post!(container.connection, path_for(container, :restart), params)
    container
  end

  @doc """
  Kill a container

  ## Official document

  https://docs.docker.com/engine/api/v1.40/#operation/ContainerKill

  ## Example

  DockerAPI.Connection.new() |> DockerAPI.Container.list!(all: true) |> List.first() |> DockerAPI.Container.start!() |> DockerAPI.Container.kill!()
  %DockerAPI.Container{
  connection: %DockerAPI.Connection{
    headers: [],
    identity_token: nil,
    options: [],
    url: "http+unix://%2Fvar%2Frun%2Fdocker.sock",
    version: nil
  },
  id: "08c635bb1667c963cbff8191cbd2144f6e78cb504ed8618285de4a19137ece7f"
  }

  """

  def kill(container, params \\ []) do
    case Connection.post(container.connection, path_for(container, :kill), params) do
      :ok ->
        {:ok, container}

      {:error, error} ->
        {:error, error}
    end
  end

  @doc """
  `DockerAPI.Container.kill/2`
  """

  def kill!(container, params \\ []) do
    Connection.post!(container.connection, path_for(container, :kill), params)
    container
  end

  @doc """
  Update a container

  ## Official document

  https://docs.docker.com/engine/api/v1.40/#operation/ContainerUpdate

  ## Example

  DockerAPI.Connection.new() |> DockerAPI.Container.create!([], %{image: "ubuntu:latest"}) |> DockerAPI.Container.update()
  {:ok, %{"Warnings" => nil}}

  """

  def update(container, params \\ [], body \\ %{}) do
    Connection.post(container.connection, path_for(container, :update), params, body)
  end

  @doc """
  `DockerAPI.Container.update/3`
  """

  def update!(container, params \\ [], body \\ %{}) do
    Connection.post!(container.connection, path_for(container, :update), params, body)
  end

  @doc """
  Rename a container

  ## Official document

  https://docs.docker.com/engine/api/v1.40/#operation/ContainerRename

  ## Example

  DockerAPI.Connection.new() |> DockerAPI.Container.list!(all: true) |> List.first() |> DockerAPI.Container.rename(name: "huga")
  {:ok,
  %DockerAPI.Container{
   connection: %DockerAPI.Connection{
     headers: [],
     identity_token: nil,
     options: [],
     url: "http+unix://%2Fvar%2Frun%2Fdocker.sock",
     version: nil
   },
   id: "cc85a837a3ee85014c75dabfb867422378d81c8694e062aaa986693998185920"
  }}
  """

  def rename(container, params \\ []) do
    case Connection.post(container.connection, path_for(container, :rename), params) do
      :ok ->
        {:ok, container}

      error ->
        error
    end
  end

  @doc """
  `DockerAPI.Container.rename/2`
  """

  def rename!(container, params \\ []) do
    Connection.post!(container.connection, path_for(container, :rename), params)
    container
  end

  @doc """
  Pause a container

  ## Official document

  https://docs.docker.com/engine/api/v1.40/#operation/ContainerPause

  ## Example

  DockerAPI.Connection.new() |> DockerAPI.Container.list!(all: true) |> List.first() |> DockerAPI.Container.start!() |> DockerAPI.Container.pause()
  {:ok,
  %DockerAPI.Container{
   connection: %DockerAPI.Connection{
     headers: [],
     identity_token: nil,
     options: [],
     url: "http+unix://%2Fvar%2Frun%2Fdocker.sock",
     version: nil
   },
   id: "cc85a837a3ee85014c75dabfb867422378d81c8694e062aaa986693998185920"
  }}

  """

  def pause(container, params \\ []) do
    case Connection.post(container.connection, path_for(container, :pause), params) do
      :ok ->
        {:ok, container}

      error ->
        error
    end
  end

  @doc """
  `DockerAPI.Container.pause/2`
  """

  def pause!(container, params \\ []) do
    Connection.post!(container.connection, path_for(container, :pause), params)
    container
  end

  @doc """
  Unpause a container

  ## Official document

  https://docs.docker.com/engine/api/v1.40/#operation/ContainerUnpause

  ## Example

  DockerAPI.Connection.new() |> DockerAPI.Container.create!([], %{image: "ubuntu:latest", tty: true}) |> DockerAPI.Container.start!() |> DockerAPI.Container.pause!() |> DockerAPI.Container.unpause()
  {:ok,
  %DockerAPI.Container{
   connection: %DockerAPI.Connection{
     headers: [],
     identity_token: nil,
     options: [],
     url: "http+unix://%2Fvar%2Frun%2Fdocker.sock",
     version: nil
   },
   id: "ca0bb6334db05fada7a296f6655f793a4645eea9d0dbe465a1a06c74ebc33129"
  }}
  """

  def unpause(container, params \\ []) do
    case Connection.post(container.connection, path_for(container, :unpause), params) do
      :ok ->
        {:ok, container}

      error ->
        error
    end
  end

  @doc """
  `DockerAPI.Container.unpause/2`
  """

  def unpause!(container, params \\ []) do
    Connection.post!(container.connection, path_for(container, :unpause), params)
    container
  end

  @doc """
  Unimplemented: Attach to a container/2
  """

  def attach(_container, _params \\ []) do
    :none
  end

  @doc """
  `DockerAPI.Container.attach/2`
  """

  def attach!(_container, _params \\ []) do
    :none
  end

  @doc """
  Wait for a container

  ## Official document

  https://docs.docker.com/engine/api/v1.40/#operation/ContainerWait

  ## Example

  ```elixir
  # shell 1
  DockerAPI.Connection.new("http+unix://%2Fvar%2Frun%2Fdocker.sock", [], [recv_timeout: :infinity]) |> DockerAPI.Container.list!() |> List.first() |> DockerAPI.Container.wait()

  # shell 2
  DockerAPI.Connection.new() |> DockerAPI.Container.list!() |> List.first() |> DockerAPI.Container.stop()
  {:ok,
  %DockerAPI.Container{
   connection: %DockerAPI.Connection{
     headers: [],
     identity_token: nil,
     options: [],
     url: "http+unix://%2Fvar%2Frun%2Fdocker.sock",
     version: nil
   },
   id: "ed5294d35613dd2417b295285490302b388ecb22555c8994042cbe14875af923"
  }}

  # shell 1
  {:ok, %{"Error" => nil, "StatusCode" => 0}}
  ```
  """

  def wait(container, params \\ []) do
    Connection.post(container.connection, path_for(container, :wait), params)
  end

  @doc """
  `DockerAPI.Container.wait/2`
  """

  def wait!(container, params \\ []) do
    Connection.post!(container.connection, path_for(container, :wait), params)
  end

  @doc """
  Remove a container

  ## Official document

  https://docs.docker.com/engine/api/v1.40/#operation/ContainerDelete

  ## Example

  DockerAPI.Connection.new() |> DockerAPI.Container.list!(all: true) |> List.first() |> DockerAPI.Container.remove()
  :ok
  """

  def remove(container, params \\ []) do
    Connection.delete(container.connection, path_for(container), params)
  end

  @doc """
  `DockerAPI.Container.remove/2`
  """

  def remove!(container, params \\ []) do
    Connection.delete!(container.connection, path_for(container), params)
  end

  @doc """
  Get information about files in a container

  ## Official document

  https://docs.docker.com/engine/api/v1.40/#operation/ContainerArchiveInfo

  ## Example

  DockerAPI.Connection.new() |> DockerAPI.Container.list!(all: true) |> List.first() |> DockerAPI.Container.archive_head!([path: "/"]) |> Enum.find(fn {key, _} -> key == "X-Docker-Container-Path-Stat" end) |> elem(1) |> :base64.decode() |> Jason.decode!
  %{
  "linkTarget" => "",
  "mode" => 2147484141,
  "mtime" => "2020-10-26T00:15:19.947559356+09:00",
  "name" => "/",
  "size" => 4096
  }
  """

  def archive_head(container, params \\ []) do
    Connection.head(container.connection, path_for(container, :archive), params)
  end

  @doc """
  `DockerAPI.Container.archive_head/2`
  """

  def archive_head!(container, params \\ []) do
    Connection.head!(container.connection, path_for(container, :archive), params)
  end

  @doc """
  Get an archive of a filesystem resource in a container

  ## Official document

  https://docs.docker.com/engine/api/v1.40/#operation/ContainerArchive

  ## Example

  DockerAPI.Connection.new() |> DockerAPI.Container.list!(all: true) |> List.first() |> DockerAPI.Container.archive_get([path: "/"])
  {:ok,
  <<47, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
   0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, ...>>}
  """

  def archive_get(container, params \\ []) do
    Connection.get(container.connection, path_for(container, :archive), params)
  end

  @doc """
  `DockerAPI.Container.archive_get/2`
  """

  def archive_get!(container, params \\ []) do
    Connection.get!(container.connection, path_for(container, :archive), params)
  end

  @doc """
  Extract an archive of files or folders to a directory in a container

  ## Official document

  https://docs.docker.com/engine/api/v1.40/#operation/PutContainerArchive

  ## Example

  binary = File.read!("/home/riki/Desktop/hoge.tar")
  <<104, 111, 103, 101, 46, 116, 120, 116, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
  0, 0, 0, ...>>

  DockerAPI.Connection.new() |> DockerAPI.Container.list!(all: true) |> List.first() |> DockerAPI.Container.archive_put([path: "/tmp"], binary)
  {:ok,
  %DockerAPI.Container{
   connection: %DockerAPI.Connection{
     headers: [],
     identity_token: nil,
     options: [],
     url: "http+unix://%2Fvar%2Frun%2Fdocker.sock",
     version: nil
   },
   id: "fcd73c521d3145f7167518cdceeb993e42f5bc77f0ed1a2707928d0f1501addc"
  }}

  """

  def archive_put(container, params \\ [], body \\ "") do
    case Connection.put(container.connection, path_for(container, :archive), params, body) do
      :ok ->
        {:ok, container}

      error ->
        error
    end
  end

  @doc """
  `DockerAPI.Container.archive_put/3`
  """

  def archive_put!(container, params \\ [], body \\ "") do
    Connection.put!(container.connection, path_for(container, :archive), params, body)
    container
  end

  @doc """
  Delete stopped containers

  ## Official document

  https://docs.docker.com/engine/api/v1.40/#operation/ContainerPrune

  ## Example

  DockerAPI.Connection.new() |> DockerAPI.Container.prune()
  {:ok,
  %{
   "ContainersDeleted" => ["918396d894b9231290b34a3cb844c261a67a64fca9e57f2149c55334fb9618ae"],
   "SpaceReclaimed" => 0
  }}

  """

  def prune(conn, params \\ []) do
    Connection.post(conn, path_for(:prune), params)
  end

  @doc """
  `DockerAPI.Container.prune/2`
  """

  def prune!(conn, params \\ []) do
    Connection.post!(conn, path_for(:prune), params)
  end

  defp new(json, conn) do
    %Container{
      id: json["Id"],
      connection: conn
    }
  end

  defp path_for(path) when is_atom(path) do
    "/containers/#{path}"
  end

  defp path_for(container) do
    "/containers/#{container.id}"
  end

  defp path_for(container, path) do
    "/containers/#{container.id}/#{path}"
  end
end
