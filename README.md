# DockerAPI

Docker remote API wrapper. This library support Containers, Images, Network, Volumes, etc...

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `docker_api` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:docker_api, "~> 0.3.0"}
  ]
end
```

## Usage

It's simple to use. Basically, it follows the official reference, so use it while reading.

```elixir
iex> DockerAPI.Connection.new() |> DockerAPI.Image.list!() |> Enum.map(&DockerAPI.Image.inspect!/1) |> Enum.map(&Map.get(&1, "RepoTags"))
[["ubuntu:latest"], ["bash:latest"], ["hello-world:latest"]]

iex> DockerAPI.Connection.new() |> DockerAPI.Container.create!([name: "sample"],%{"Image": "ubuntu"}) |> DockerAPI.Container.start()
{:ok,
 %DockerAPI.Container{
   connection: %DockerAPI.Connection{
     headers: [],
     identity_token: nil,
     options: [],
     url: "http+unix://%2Fvar%2Frun%2Fdocker.sock",
     version: nil
   },
   id: "9b0d0dc1d473c6a2608a48e5d99e7f80adb702b2b9e2d3cd72323f2f457a64b4"
 }}
```

### Options

This library uses the `HTTPoison` (to support the Unix domain docket).

So you can use the same options as HTTPoison (and hackney by extension).

```elixir
DockerAPI.Connection.new(url, headers, options)  
```

For example, a simple one is to set up a timeout

```elixir
DockerAPI.Connection.new("http+unix://%2Fvar%2Frun%2Fdocker.sock", [], [recv_timeout: :inifinity])

```

And then there's the SSL settings.

```elixir
DockerAPI.Connection.new("http+unix://%2Fvar%2Frun%2Fdocker.sock", [], [ssl: [certfile: "certs/client.crt"]]) 
```

## Contribute

There are some unimplemented functions in this library and examples are missing in some modules.

Also, there are some functions that I have not been able to verify the behavior of. So if you find a bug, please feel free to contribute.

I don't know much about licensing, so please help me out!

Thank you.