defmodule DockerAPI.Endpoints.Image do
  use DockerAPI.Base, "/images"

  alias DockerAPI.{Connection, Error}

  @moduledoc since: "0.4.0"
  @moduledoc """
  Images

  ## Official document

  https://docs.docker.com/engine/api/v1.41/#tag/Image
  """

  @type id() :: String.t()

  @type t() :: %__MODULE__{id: id(), connection: Connection.t()}

  @doc since: "0.4.0"
  @spec list(
          conn :: Connection.t(),
          params :: Connection.params(),
          headers :: Connection.headers()
        ) ::
          {:ok, [t(), ...]} | {:error, Error.t()}
  def list(conn, params \\ %{}, headers \\ []) do
    Connection.get(conn, path_for(:json), params, headers)
    |> handle_json_response()
    |> case do
      {:ok, json} ->
        {:ok, Enum.map(json, &new(&1["Id"], conn))}

      error ->
        error
    end
  end

  @doc since: "0.4.0"
  @spec list!(
          conn :: Connection.t(),
          params :: Connection.params(),
          headers :: Connection.headers()
        ) ::
          [t(), ...]
  def list!(conn, params \\ %{}, headers \\ []) do
    list(conn, params, headers)
    |> bang!()
  end

  @doc since: "0.4.0"
  @spec build(
          conn :: Connection.t(),
          params :: Connection.params(),
          body :: Connection.body(),
          headers :: Connection.headers()
        ) ::
          :ok | {:error, Error.t()}
  def build(conn, params \\ %{}, body \\ nil, headers \\ []) do
    Connection.post(conn, "/build", params, body, headers)
    |> handle_no_response()
  end

  @doc since: "0.4.0"
  @spec build!(
          conn :: Connection.t(),
          params :: Connection.params(),
          body :: Connection.body(),
          headers :: Connection.headers()
        ) ::
          :ok
  def build!(conn, params \\ %{}, body \\ nil, headers \\ []) do
    build(conn, params, body, headers)
    |> bang!()
  end

  @doc since: "0.4.0"
  @spec prune_cache(
          conn :: Connection.t(),
          params :: Connection.params(),
          body :: Connection.body(),
          headers :: Connection.headers()
        ) ::
          {:ok, term()} | {:error, Error.t()}
  def prune_cache(conn, params \\ %{}, body \\ nil, headers \\ []) do
    Connection.post(conn, "/build/prune", params, body, headers)
    |> handle_json_response()
  end

  @doc since: "0.4.0"
  @spec prune_cache!(
          conn :: Connection.t(),
          params :: Connection.params(),
          body :: Connection.body(),
          headers :: Connection.headers()
        ) ::
          term()
  def prune_cache!(conn, params \\ %{}, body \\ nil, headers \\ []) do
    prune_cache(conn, params, body, headers)
    |> bang!()
  end

  @doc since: "0.4.0"
  @spec create(
          conn :: Connection.t(),
          params :: Connection.params(),
          body :: Connection.body(),
          headers :: Connection.headers()
        ) ::
          :ok | {:error, Error.t()}
  def create(conn, params \\ %{}, body \\ nil, headers \\ []) do
    Connection.post(conn, path_for(:create), params, body, headers)
    |> handle_no_response()
  end

  @doc since: "0.4.0"
  @spec create!(
          conn :: Connection.t(),
          params :: Connection.params(),
          body :: Connection.body(),
          headers :: Connection.headers()
        ) ::
          :ok
  def create!(conn, params \\ %{}, body \\ nil, headers \\ []) do
    create(conn, params, body, headers)
    |> bang!()
  end

  @doc since: "0.4.0"
  @spec inspect(
          image :: t(),
          params :: Connection.params(),
          headers :: Connection.headers()
        ) ::
          {:ok, term()} | {:error, Error.t()}
  def inspect(image, params \\ %{}, headers \\ []) do
    Connection.get(image.connection, path_for(image, :json), params, headers)
    |> handle_json_response()
  end

  @doc since: "0.4.0"
  @spec inspect!(
          image :: t(),
          params :: Connection.params(),
          headers :: Connection.headers()
        ) ::
          term()
  def inspect!(image, params \\ %{}, headers \\ []) do
    inspect(image, params, headers)
    |> bang!()
  end

  @doc since: "0.4.0"
  @spec history(
          image :: t(),
          params :: Connection.params(),
          headers :: Connection.headers()
        ) ::
          {:ok, term()} | {:error, Error.t()}
  def history(image, params \\ %{}, headers \\ []) do
    Connection.get(image.connection, path_for(image, :history), params, headers)
    |> handle_json_response()
  end

  @doc since: "0.4.0"
  @spec history!(
          image :: t(),
          params :: Connection.params(),
          headers :: Connection.headers()
        ) ::
          term()
  def history!(image, params \\ %{}, headers \\ []) do
    history(image, params, headers)
    |> bang!()
  end

  @doc since: "0.4.0"
  @spec push(
          image :: t(),
          params :: Connection.params(),
          body :: Connection.body(),
          headers :: Connection.headers()
        ) ::
          :ok | {:error, Error.t()}
  def push(image, params \\ %{}, body \\ nil, headers \\ []) do
    Connection.post(image.connection, path_for(image, :push), params, body, headers)
    |> handle_no_response()
  end

  @doc since: "0.4.0"
  @spec push!(
          image :: t(),
          params :: Connection.params(),
          body :: Connection.body(),
          headers :: Connection.headers()
        ) ::
          :ok
  def push!(image, params \\ %{}, body \\ nil, headers \\ []) do
    push(image, params, body, headers)
    |> bang!()
  end

  @doc since: "0.4.0"
  @spec tag(
          image :: t(),
          params :: Connection.params(),
          body :: Connection.body(),
          headers :: Connection.headers()
        ) ::
          :ok | {:error, Error.t()}
  def tag(image, params \\ %{}, body \\ nil, headers \\ []) do
    Connection.post(image.connection, path_for(image, :tag), params, body, headers)
    |> handle_no_response()
  end

  @doc since: "0.4.0"
  @spec tag(
          image :: t(),
          params :: Connection.params(),
          body :: Connection.body(),
          headers :: Connection.headers()
        ) ::
          :ok
  def tag!(image, params \\ %{}, body \\ nil, headers \\ []) do
    tag(image, params, body, headers)
    |> bang!()
  end

  @doc since: "0.4.0"
  @spec remove(
          image :: t(),
          params :: Connection.params(),
          headers :: Connection.headers()
        ) ::
          {:ok, term()} | {:error, Error.t()}
  def remove(image, params \\ %{}, headers \\ []) do
    Connection.delete(image.connection, path_for(image), params, headers)
    |> handle_json_response()
  end

  @doc since: "0.4.0"
  @spec remove(
          image :: t(),
          params :: Connection.params(),
          headers :: Connection.headers()
        ) ::
          term()
  def remove!(image, params \\ %{}, headers \\ []) do
    remove(image, params, headers)
    |> bang!()
  end

  @doc since: "0.4.0"
  @spec search(
          conn :: Connection.t(),
          params :: Connection.params(),
          headers :: Connection.headers()
        ) ::
          {:ok, term()} | {:error, Error.t()}
  def search(conn, params \\ %{}, headers \\ []) do
    Connection.get(conn, path_for(:search), params, headers)
    |> handle_json_response()
  end

  @doc since: "0.4.0"
  @spec search(
          conn :: Connection.t(),
          params :: Connection.params(),
          headers :: Connection.headers()
        ) ::
          term()
  def search!(conn, params \\ %{}, headers \\ []) do
    search(conn, params, headers)
    |> bang!()
  end

  @doc since: "0.4.0"
  @spec prune_image(
          conn :: Connection.t(),
          params :: Connection.params(),
          body :: Connection.body(),
          headers :: Connection.headers()
        ) ::
          {:ok, term()} | {:error, Error.t()}
  def prune_image(conn, params \\ %{}, body \\ nil, headers \\ []) do
    Connection.post(conn, path_for(:prune), params, body, headers)
    |> handle_json_response()
  end

  @doc since: "0.4.0"
  @spec prune_image(
          conn :: Connection.t(),
          params :: Connection.params(),
          body :: Connection.body(),
          headers :: Connection.headers()
        ) ::
          term()
  def prune_image!(conn, params \\ %{}, body \\ nil, headers \\ []) do
    prune_image(conn, params, body, headers)
    |> bang!()
  end

  @doc since: "0.4.0"
  @spec commit(
          conn :: Connection.t(),
          params :: Connection.params(),
          body :: Connection.body(),
          headers :: Connection.headers()
        ) ::
          {:ok, t()} | {:error, Error.t()}
  def commit(conn, params \\ %{}, body \\ nil, headers \\ []) do
    Connection.post(conn, "/commit", params, body, headers)
    |> handle_json_response()
    |> case do
      {:ok, json} ->
        {:ok, new(json["Id"], conn)}

      error ->
        error
    end
  end

  @doc since: "0.4.0"
  @spec commit!(
          conn :: Connection.t(),
          params :: Connection.params(),
          body :: Connection.body(),
          headers :: Connection.headers()
        ) ::
          t()
  def commit!(conn, params \\ %{}, body \\ nil, headers \\ []) do
    commit(conn, params, body, headers)
    |> bang!()
  end

  @doc false
  def export(struct, params, headers)

  @doc since: "0.4.0"
  @spec export(
          image :: t(),
          params :: Connection.params(),
          headers :: Connection.headers()
        ) ::
          {:ok, binary()} | {:error, Error.t()}
  def export(image, params, headers) when is_struct(image, __MODULE__) do
    Connection.get(image.connection, path_for(image, :get), params, headers)
  end

  @doc since: "0.4.0"
  @spec export(
          conn :: Connection.t(),
          params :: Connection.params(),
          headers :: Connection.headers()
        ) ::
          {:ok, binary()} | {:error, Error.t()}
  def export(conn, params, headers) when is_struct(conn, Connection) do
    Connection.get(conn, path_for(:get), params, headers)
  end

  @doc false
  def export!(struct, params, headers)

  @doc since: "0.4.0"
  @spec export(
          image :: t(),
          params :: Connection.params(),
          headers :: Connection.headers()
        ) ::
          binary()
  def export!(image, params, headers) when is_struct(image, __MODULE__) do
    export(image, params, headers)
    |> bang!()
  end

  @doc since: "0.4.0"
  @spec export!(
          conn :: Connection.t(),
          params :: Connection.params(),
          headers :: Connection.headers()
        ) ::
          binary()
  def export!(conn, params, headers) when is_struct(conn, Connection) do
    export(conn, params, headers)
    |> bang!()
  end

  @doc since: "0.4.0"
  @spec load(
          conn :: Connection.t(),
          params :: Connection.params(),
          body :: Connection.body(),
          headers :: Connection.headers()
        ) ::
          :ok | {:error, Error.t()}
  def load(conn, params \\ %{}, body \\ nil, headers \\ []) do
    Connection.post(conn, path_for(:load), params, body, headers)
    |> handle_no_response()
  end

  @doc since: "0.4.0"
  @spec load(
          conn :: Connection.t(),
          params :: Connection.params(),
          body :: Connection.body(),
          headers :: Connection.headers()
        ) ::
          :ok
  def load!(conn, params \\ %{}, body \\ nil, headers \\ []) do
    load(conn, params, body, headers)
  end
end
