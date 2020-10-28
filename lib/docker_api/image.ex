defmodule DockerAPI.Image do
  @moduledoc """
  Images

  ## Official document

  https://docs.docker.com/engine/api/v1.40/#tag/Image
  """

  alias DockerAPI.{Connection, Image}

  defstruct id: nil, connection: nil

  @doc """

  List Images

  ## Official document

  https://docs.docker.com/engine/api/v1.40/#operation/ImageList

  ## Example

  ```elixir
  DockerAPI.Connection.new() |> DockerAPI.Image.list()
  {:ok,
  [
   %DockerAPI.Image{
     connection: %DockerAPI.Connection{
       headers: [],
       identity_token: nil,
       options: [],
       url: "http+unix://%2Fvar%2Frun%2Fdocker.sock",
       version: nil
     },
     id: "sha256:bf756fb1ae65adf866bd8c456593cd24beb6a0a061dedf42b26a993176745f6b"
   }
  ]}
  ```
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
  `DockerAPI.Image.list/2`, raising an exception in case of failure.
  """

  def list!(conn, params \\ []) do
    Connection.get!(conn, path_for(:json), params)
    |> Enum.map(&new(&1, conn))
  end

  @doc """
  Build an image

  ## Official document

  https://docs.docker.com/engine/api/v1.40/#operation/ImageBuild

  ## Example

  Please help!
  """

  def build(conn, params \\ [], body \\ "") do
    conn
    |> Connection.add_header(:"Content-type", "application/x-tar")
    |> Connection.add_header(:"X-Registry-Auth", conn.identity_token)
    |> Connection.post("/build", params, body)
  end

  @doc """
  `DockerAPI.Image.build/3`, raising an exception in case of failure.
  """

  def build!(conn, params \\ [], body \\ "") do
    conn
    |> Connection.add_header(:"Content-type", "application/x-tar")
    |> Connection.add_header(:"X-Registry-Auth", conn.identity_token)
    |> Connection.post!("/build", params, body)
  end

  @doc """
  Delete builder cache

  ## Official document

  https://docs.docker.com/engine/api/v1.40/#operation/BuildPrune

  ## Example

  DockerAPI.Connection.new() |> DockerAPI.Image.prune_build()
  {:ok, %{"CachesDeleted" => nil, "SpaceReclaimed" => 0}}
  """

  def prune_build(conn) do
    Connection.post(conn, "/build/prune")
  end

  @doc """
  `DockerAPI.Image.prune_build/1`, raising an exception in case of failure.
  """

  def prune_build!(conn) do
    Connection.post!(conn, "/build/prune")
  end

  @doc """
  Create an image

  ## Official document

  https://docs.docker.com/engine/api/v1.40/#operation/ImageCreate

  ## Example

  Please help!
  """

  def create(conn, params \\ [], body \\ "") do
    conn
    |> Connection.add_header(:"X-Registry-Auth", conn.identity_token)
    |> Connection.post(path_for(:create), params, body)
  end

  @doc """
  `DockerAPI.Image.create/3`, raising an exception in case of failure.
  """

  def create!(conn, params \\ [], body \\ "") do
    conn
    |> Connection.add_header(:"X-Registry-Auth", conn.identity_token)
    |> Connection.post!(path_for(:create), params, body)
  end

  @doc """
  Inspect an image

  ## Official document

  https://docs.docker.com/engine/api/v1.40/#operation/ImageInspect

  ## Example

  DockerAPI.Connection.new() |> DockerAPI.Image.list!() |> Enum.map(&DockerAPI.Image.inspect()/1)
  [
    ok: %{
      "Architecture" => "amd64",
      "Author" => "",
      "Comment" => "",
      "Config" => %{
        "ArgsEscaped" => true,
        "AttachStderr" => false,
        "AttachStdin" => false,
        "AttachStdout" => false,
        "Cmd" => ["/hello"],
        "Domainname" => "",
        "Entrypoint" => nil,
        "Env" => ["PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"],
        "Hostname" => "",
        "Image" => "sha256:eb850c6a1aedb3d5c62c3a484ff01b6b4aade130b950e3bf3e9c016f17f70c34",
        "Labels" => nil,
        "OnBuild" => nil,
        "OpenStdin" => false,
        "StdinOnce" => false,
        "Tty" => false,
        "User" => "",
        "Volumes" => nil,
        "WorkingDir" => ""
      },
      "Container" => "71237a2659e6419aee44fc0b51ffbd12859d1a50ba202e02c2586ed999def583",
      "ContainerConfig" => %{
        "ArgsEscaped" => true,
        "AttachStderr" => false,
        "AttachStdin" => false,
        "AttachStdout" => false,
        "Cmd" => ["/bin/sh", "-c", "#(nop) ", "CMD [\"/hello\"]"],
        "Domainname" => "",
        "Entrypoint" => nil,
        "Env" => ["PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"],
        "Hostname" => "71237a2659e6",
        "Image" => "sha256:eb850c6a1aedb3d5c62c3a484ff01b6b4aade130b950e3bf3e9c016f17f70c34",
        "Labels" => %{},
        "OnBuild" => nil,
        "OpenStdin" => false,
        "StdinOnce" => false,
        "Tty" => false,
        "User" => "",
        "Volumes" => nil,
        "WorkingDir" => ""
      },
      "Created" => "2020-01-03T01:21:37.263809283Z",
      "DockerVersion" => "18.06.1-ce",
      "GraphDriver" => %{
        "Data" => %{
          "MergedDir" => "/var/lib/docker/overlay2/2d9b7f038b1595d500d450ea943dd008108e0ee90593c2d4aafbd2fb76aa1775/merged",
          "UpperDir" => "/var/lib/docker/overlay2/2d9b7f038b1595d500d450ea943dd008108e0ee90593c2d4aafbd2fb76aa1775/diff",
          "WorkDir" => "/var/lib/docker/overlay2/2d9b7f038b1595d500d450ea943dd008108e0ee90593c2d4aafbd2fb76aa1775/work"
        },
        "Name" => "overlay2"
      },
      "Id" => "sha256:bf756fb1ae65adf866bd8c456593cd24beb6a0a061dedf42b26a993176745f6b",
      "Metadata" => %{"LastTagTime" => "0001-01-01T00:00:00Z"},
      "Os" => "linux",
      "Parent" => "",
      "RepoDigests" => ["hello-world@sha256:7f0a9f93b4aa3022c3a4c147a449bf11e0941a1fd0bf4a8e6c9408b2600777c5"],
      "RepoTags" => ["hello-world:latest"],
      "RootFS" => %{
        "Layers" => ["sha256:9c27e219663c25e0f28493790cc0b88bc973ba3b1686355f221c38a36978ac63"],
        "Type" => "layers"
      },
      "Size" => 13336,
      "VirtualSize" => 13336
    }
  ]
  """

  def inspect(image) do
    Connection.get(image.connection, path_for(image, :json))
  end

  @doc """
  `DockerAPI.Image.inspect/1`, raising an exception in case of failure.
  """

  def inspect!(image) do
    Connection.get!(image.connection, path_for(image, :json))
  end

  @doc """
  Get the history of an image

  ## Official document

  https://docs.docker.com/engine/api/v1.40/#operation/ImageHistory

  ## Example

  DockerAPI.Connection.new() |> DockerAPI.Image.list!() |> Enum.map(&DockerAPI.Image.history/1)
  [
    ok: [
      %{
        "Comment" => "",
        "Created" => 1578014497,
        "CreatedBy" => "/bin/sh -c #(nop)  CMD [\"/hello\"]",
        "Id" => "sha256:bf756fb1ae65adf866bd8c456593cd24beb6a0a061dedf42b26a993176745f6b",
        "Size" => 0,
        "Tags" => ["hello-world:latest"]
      },
      %{
        "Comment" => "",
        "Created" => 1578014497,
        "CreatedBy" => "/bin/sh -c #(nop) COPY file:7bf12aab75c3867a023fe3b8bd6d113d43a4fcc415f3cc27cbcf0fff37b65a02 in / ",
        "Id" => "<missing>",
        "Size" => 13336,
        "Tags" => nil
      }
    ]
  ]
  """

  def history(image) do
    Connection.get(image.connection, path_for(image, :history))
  end

  @doc """
  `DockerAPI.Image.history/1`, raising an exception in case of failure.
  """

  def history!(image) do
    Connection.get!(image.connection, path_for(image, :history))
  end

  @doc """
  Push an image

  ## Official document

  https://docs.docker.com/engine/api/v1.40/#operation/ImagePush

  ## Example

  Please help!
  """

  def push(image, params \\ []) do
    image.connection
    |> Connection.add_header(:"X-Registry-Auth", image.connection.identity_token)
    |> Connection.post(path_for(image, :push), params)
  end

  @doc """
  `DockerAPI.Image.push/2`, raising an exception in case of failure.
  """

  def push!(image, params \\ []) do
    image.connection
    |> Connection.add_header(:"X-Registry-Auth", image.connection.identity_token)
    |> Connection.post!(path_for(image, :push), params)
  end

  @doc """
  Tag an image

  ## Official document

  https://docs.docker.com/engine/api/v1.40/#operation/ImageTag

  ## Example

  Please help!
  """

  def tag(image, params \\ []) do
    Connection.post(image.connection, path_for(image, :tag), params)
  end

  @doc """
  `DockerAPI.Image.tag/2`, raising an exception in case of failure.
  """

  def tag!(image, params \\ []) do
    Connection.post!(image.connection, path_for(image, :tag), params)
  end

  @doc """
  Remove an image

  ## Official document

  https://docs.docker.com/engine/api/v1.40/#operation/ImageDelete

  ## Example

  TODO: Write later
  """

  def remove(image, params \\ []) do
    Connection.delete(image.connection, path_for(image), params)
  end

  @doc """
  `DockerAPI.Image.remove/2`, raising an exception in case of failure.
  """

  def remove!(image, params \\ []) do
    Connection.delete!(image.connection, path_for(image), params)
  end

  @doc """
  Search images

  ## Official document

  https://docs.docker.com/engine/api/v1.40/#operation/ImageSearch

  ## Example

  DockerAPI.Connection.new() |> DockerAPI.Image.search([term: "ubuntu", limit: 3])
  {:ok,
  [
   %{
     "description" => "Ubuntu is a Debian-based Linux operating system based on free software.",
     "is_automated" => false,
     "is_official" => true,
     "name" => "ubuntu",
     "star_count" => 11438
   },
   %{
     "description" => "debootstrap --variant=minbase --components=main,universe --include=inetutils-ping,iproute2 <suite> /",
     "is_automated" => false,
     "is_official" => true,
     "name" => "ubuntu-debootstrap",
     "star_count" => 44
   },
   %{
     "description" => "Upstart is an event-based replacement for the /sbin/init daemon which starts processes at boot",
     "is_automated" => false,
     "is_official" => true,
     "name" => "ubuntu-upstart",
     "star_count" => 110
   }
  ]}
  """

  def search(conn, params \\ []) do
    Connection.get(conn, path_for(:search), params)
  end

  @doc """
  `DockerAPI.Image.search/2`, raising an exception in case of failure.
  """

  def search!(conn, params \\ []) do
    Connection.get!(conn, path_for(:search), params)
  end

  @doc """
  Delete unused images

  ## Official document

  https://docs.docker.com/engine/api/v1.40/#operation/ImagePrune

  ## Example

  DockerAPI.Connection.new() |> DockerAPI.Image.prune_image()
  {:ok, %{"ImagesDeleted" => nil, "SpaceReclaimed" => 0}}
  """

  def prune_image(conn, params \\ []) do
    Connection.post(conn, path_for(:prune), params)
  end

  @doc """
  `DockerAPI.Image.prune_image/2`, raising an exception in case of failure.
  """

  def prune_image!(conn, params \\ []) do
    Connection.post!(conn, path_for(:prune), params)
  end

  @doc """
  Create a new image from a container

  ## Official document

  https://docs.docker.com/engine/api/v1.40/#operation/ImageCommit

  ## Example

  Please help!
  """

  def commit(conn, params \\ [], body \\ %{}) do
    Connection.post(conn, "/commit", params, body)
  end

  @doc """
  `DockerAPI.Image.commit/3`, raising an exception in case of failure.
  """

  def commit!(conn, params \\ [], body \\ %{}) do
    Connection.post!(conn, "/commit", params, body)
  end

  @doc """
  Export an image

  ## Official document

  https://docs.docker.com/engine/api/v1.40/#operation/ImageGet

  ## Example

  DockerAPI.Connection.new() |> DockerAPI.Image.list!() |> Enum.at(0) |> DockerAPI.Image.export()
  {:ok,
  <<98, 102, 55, 53, 54, 102, 98, 49, 97, 101, 54, 53, 97, 100, 102, 56, 54, 54,
   98, 100, 56, 99, 52, 53, 54, 53, 57, 51, 99, 100, 50, 52, 98, 101, 98, 54,
   97, 48, 97, 48, 54, 49, 100, 101, 100, 102, 52, 50, ...>>}
  """

  def export(image = %Image{}) do
    Connection.get(image.connection, path_for(image, :get))
  end

  @doc """
  `DockerAPI.Image.export/1`, raising an exception in case of failure.
  """

  def export!(image = %Image{}) do
    Connection.get!(image.connection, path_for(image, :get))
  end

  @doc """
  Export several images

  ## Official document

  https://docs.docker.com/engine/api/v1.40/#operation/ImageGetAll

  ## Example

  DockerAPI.Connection.new() |> DockerAPI.Image.export()
  {:ok,
  <<109, 97, 110, 105, 102, 101, 115, 116, 46, 106, 115, 111, 110, 0, 0, 0, 0, 0,
   0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
   0, 0, 0, 0, ...>>}
  """

  def export(conn = %Connection{}, params \\ []) do
    Connection.get(conn, path_for(:get), params)
  end

  @doc """
  `DockerAPI.Image.export/2`, raising an exception in case of failure.
  """

  def export!(conn = %Connection{}, params \\ []) do
    Connection.get!(conn, path_for(:get), params)
  end

  @doc """
  Import images

  ## Official document

  https://docs.docker.com/engine/api/v1.40/#operation/ImageLoad

  ## Example

  Please help!
  """

  def load(conn, params \\ [], body \\ "") do
    Connection.post(conn, path_for(:load), params, body)
  end

  @doc """
  `DockerAPI.Image.load/3`, raising an exception in case of failure.
  """

  def load!(conn, params \\ [], body \\ "") do
    Connection.post!(conn, path_for(:load), params, body)
  end

  defp new(json, conn) do
    %Image{
      id: json["Id"],
      connection: conn
    }
  end

  defp path_for(path) when is_atom(path) do
    "/images/#{path}"
  end

  defp path_for(image) do
    "/images/#{image.id}"
  end

  defp path_for(image, path) do
    "/images/#{image.id}/#{path}"
  end
end
