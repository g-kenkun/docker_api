defmodule DockerAPI.Image do
  @moduledoc false

  alias DockerAPI.{Connection, Image}

  defstruct id: nil, connection: nil

  def list(conn = %Connection{}, params \\ []) when is_list(params) do
    case Connection.get(conn, "/images/json", params) do
      {:ok, json} ->
        {:ok, Enum.map(json, &new(&1, conn))}

      {:error, error} ->
        {:error, error}
    end
  end

  def list!(conn = %Connection{}, params \\ []) when is_list(params) do
    Connection.get!(conn, "/images/json", params)
    |> Enum.map(&new(&1, conn))
  end

  def build(conn = %Connection{}, params \\ [], body \\ "")
      when is_list(params) and is_binary(body) do
    conn =
      conn
      |> add_header("Content-type", "application/x-tar")
      |> add_header("X-Registry-Auth", conn.identity_token)

    Connection.post(conn, "/build", params, body)
  end

  def build!(conn = %Connection{}, params \\ [], body \\ "")
      when is_list(params) and is_binary(body) do
    conn =
      conn
      |> add_header("Content-type", "application/x-tar")
      |> add_header("X-Registry-Auth", conn.identity_token)

    Connection.post!(conn, "/build", params, body)
  end

  def prune_build(conn = %Connection{}) do
    Connection.post(conn, "/build/prune")
  end

  def prune_build!(conn = %Connection{}) do
    Connection.post!(conn, "/build/prune")
  end

  def create(conn = %Connection{}, params \\ [], body \\ "")
      when is_list(params) and is_binary(body) do
    conn = add_header(conn, "X-Registry-Auth", conn.identity_token)

    Connection.post(conn, "/images/create", params, body)
  end

  def create!(conn = %Connection{}, params \\ [], body \\ "")
      when is_list(params) and is_binary(body) do
    conn = add_header(conn, "X-Registry-Auth", conn.identity_token)

    Connection.post!(conn, "/images/create", params, body)
  end

  def inspect(image = %Image{}) do
    Connection.get(image.connection, path_for(image, :json))
  end

  def inspect!(image = %Image{}) do
    Connection.get!(image.connection, path_for(image, :json))
  end

  def history(image = %Image{}) do
    Connection.get(image.connection, path_for(image, :history))
  end

  def history!(image = %Image{}) do
    Connection.get!(image.connection, path_for(image, :history))
  end

  def push(image = %Image{}, params \\ []) when is_list(params) do
    conn = add_header(image.connection, "X-Registry-Auth", image.connection.identity_token)
    Connection.post(conn, path_for(image, :push), params)
  end

  def push!(image = %Image{}, params \\ []) when is_list(params) do
    conn = add_header(image.connection, "X-Registry-Auth", image.connection.identity_token)
    Connection.post!(conn, path_for(image, :push), params)
  end

  def tag(image = %Image{}, params \\ []) when is_list(params) do
    Connection.post(image.connection, path_for(image, :tag), params)
  end

  def tag!(image = %Image{}, params \\ []) when is_list(params) do
    Connection.post!(image.connection, path_for(image, :tag), params)
  end

  def remove(image = %Image{}, params \\ []) when is_list(params) do
    Connection.delete(image.connection, path_for(image), params)
  end

  def remove!(image = %Image{}, params \\ []) when is_list(params) do
    Connection.delete!(image.connection, path_for(image), params)
  end

  def search(conn = %Connection{}, params \\ []) when is_list(params) do
    Connection.get(conn, "/images/search", params)
  end

  def search!(conn = %Connection{}, params \\ []) when is_list(params) do
    Connection.get!(conn, "/images/search", params)
  end

  def prune_image(conn = %Connection{}, params \\ []) when is_list(params) do
    Connection.post(conn, "/images/prune", params)
  end

  def prune_image!(conn = %Connection{}, params \\ []) when is_list(params) do
    Connection.post!(conn, "/images/prune", params)
  end

  def commit(conn = %Connection{}, params \\ [], body \\ %{})
      when is_list(params) and is_map(body) do
    Connection.post(conn, "/commit", params, body)
  end

  def commit!(conn = %Connection{}, params \\ [], body \\ %{})
      when is_list(params) and is_map(body) do
    Connection.post!(conn, "/commit", params, body)
  end

  def export(image = %Image{}) do
    Connection.get(image.connection, path_for(image, "get"))
  end

  def export!(image = %Image{}) do
    Connection.get!(image.connection, path_for(image, "get"))
  end

  def export(conn = %Connection{}, params \\ []) when is_list(params) do
    Connection.get(conn, "/images/get", params)
  end

  def export!(conn = %Connection{}, params \\ []) when is_list(params) do
    Connection.get!(conn, "/images/get", params)
  end

  def load(conn = %Connection{}, params \\ [], body \\ "")
      when is_list(params) and is_binary(body) do
    Connection.post(conn, "/images/load", params, body)
  end

  def load!(conn = %Connection{}, params \\ [], body \\ "")
      when is_list(params) and is_binary(body) do
    Connection.post!(conn, "/images/load", params, body)
  end

  defp new(json, conn) do
    %Image{
      id: json["Id"],
      connection: conn
    }
  end

  defp add_header(conn, key, value) do
    %Connection{
      conn
      | headers: Keyword.put(conn.headers, key, value)
    }
  end

  defp path_for(image = %Image{}) do
    "/images/#{image.id}"
  end

  defp path_for(image = %Image{}, path) do
    "/images/#{image.id}/#{path}"
  end
end
