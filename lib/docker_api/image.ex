defmodule DockerAPI.Image do
  @moduledoc false

  import DockerAPI.Util

  alias DockerAPI.{Connection, Image}

  defstruct id: nil, connection: nil

  def list(conn, params \\ []) do
    case Connection.get(conn, path_for(:json), params) do
      {:ok, json} ->
        {:ok, Enum.map(json, &new(&1, conn))}

      {:error, error} ->
        {:error, error}
    end
  end

  def list!(conn, params \\ []) do
    Connection.get!(conn, path_for(:json), params)
    |> Enum.map(&new(&1, conn))
  end

  def build(conn, params \\ [], body \\ "") do
    conn
    |> add_header("Content-type", "application/x-tar")
    |> add_header("X-Registry-Auth", conn.identity_token)
    |> Connection.post("/build", params, body)
  end

  def build!(conn, params \\ [], body \\ "") do
    conn
    |> add_header("Content-type", "application/x-tar")
    |> add_header("X-Registry-Auth", conn.identity_token)
    |> Connection.post!("/build", params, body)
  end

  def prune_build(conn) do
    Connection.post(conn, "/build/prune")
  end

  def prune_build!(conn) do
    Connection.post!(conn, "/build/prune")
  end

  def create(conn, params \\ [], body \\ "") do
    conn
    |> add_header("X-Registry-Auth", conn.identity_token)
    |> Connection.post(path_for(:create), params, body)
  end

  def create!(conn, params \\ [], body \\ "") do
    conn
    |> add_header("X-Registry-Auth", conn.identity_token)
    |> Connection.post!(path_for(:create), params, body)
  end

  def inspect(image) do
    Connection.get(image.connection, path_for(image, :json))
  end

  def inspect!(image) do
    Connection.get!(image.connection, path_for(image, :json))
  end

  def history(image) do
    Connection.get(image.connection, path_for(image, :history))
  end

  def history!(image) do
    Connection.get!(image.connection, path_for(image, :history))
  end

  def push(image, params \\ []) do
    conn = add_header(image.connection, "X-Registry-Auth", image.connection.identity_token)
    Connection.post(conn, path_for(image, :push), params)
  end

  def push!(image = %Image{}, params \\ []) do
    conn = add_header(image.connection, "X-Registry-Auth", image.connection.identity_token)
    Connection.post!(conn, path_for(image, :push), params)
  end

  def tag(image = %Image{}, params \\ []) do
    Connection.post(image.connection, path_for(image, :tag), params)
  end

  def tag!(image = %Image{}, params \\ []) do
    Connection.post!(image.connection, path_for(image, :tag), params)
  end

  def remove(image = %Image{}, params \\ []) do
    Connection.delete(image.connection, path_for(image), params)
  end

  def remove!(image = %Image{}, params \\ []) do
    Connection.delete!(image.connection, path_for(image), params)
  end

  def search(conn = %Connection{}, params \\ []) do
    Connection.get(conn, path_for(:search), params)
  end

  def search!(conn = %Connection{}, params \\ []) do
    Connection.get!(conn, path_for(:search), params)
  end

  def prune_image(conn = %Connection{}, params \\ []) do
    Connection.post(conn, path_for(:prune), params)
  end

  def prune_image!(conn = %Connection{}, params \\ []) do
    Connection.post!(conn, path_for(:prune), params)
  end

  def commit(conn = %Connection{}, params \\ [], body \\ %{}) do
    Connection.post(conn, "/commit", params, body)
  end

  def commit!(conn = %Connection{}, params \\ [], body \\ %{}) do
    Connection.post!(conn, "/commit", params, body)
  end

  def export(image = %Image{}) do
    Connection.get(image.connection, path_for(image, :get))
  end

  def export!(image = %Image{}) do
    Connection.get!(image.connection, path_for(image, :get))
  end

  def export(conn = %Connection{}, params \\ []) do
    Connection.get(conn, path_for(:get), params)
  end

  def export!(conn = %Connection{}, params \\ []) do
    Connection.get!(conn, path_for(:get), params)
  end

  def load(conn = %Connection{}, params \\ [], body \\ "") do
    Connection.post(conn, path_for(:load), params, body)
  end

  def load!(conn = %Connection{}, params \\ [], body \\ "") do
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

  defp path_for(image = %Image{}) do
    "/images/#{image.id}"
  end

  defp path_for(image = %Image{}, path) do
    "/images/#{image.id}/#{path}"
  end
end
