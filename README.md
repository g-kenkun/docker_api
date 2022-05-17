# DockerAPI

Docker remote API wrapper. This library support Containers, Images, Network, Volumes, etc...

## Warning!

v0.3 -> v0.4 で破壊的変更があります。

v0.3 -> v0.4 contains destructive changes.

## Please Help Me!

開発環境を WSL に移行して Docker API が利用できなくなったためドキュメントがありません！ どなたが v0.3 を参考にドキュメントを書いてください！

Since we have migrated my development environment to WSL and the Docker API is not available, there is no documentation for each module! Please someone write documentation based on v0.3!

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `docker_api` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:docker_api, "~> 0.4.0"}
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

## Contribute

本ライブラリには未実装の関数があり、モジュールによってはサンプルが不足しています。

また、私が動作を確認できていない関数もあります。もしバグを見つけたら教えてください。

There are some functions in this library that are not yet implemented, and some modules lack samples.

Also, some functions I have not been able to verify their operation. If you find any bugs, please let me know.
