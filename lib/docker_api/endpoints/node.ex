defmodule DockerAPI.Endpoints.Node do
  use DockerAPI.Base, "/nodes"

  alias DockerAPI.{Connection, Error}

  @moduledoc since: "0.4.0"
  @moduledoc """
  Nodes are instances of the Engine participating in a swarm. Swarm mode must be enabled for these endpoints to work.

  ## Official document

  https://docs.docker.com/engine/api/v1.41/#tag/Node
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
    Connection.get(conn, path_for(), params, headers)
    |> handle_json_response()
    |> case do
      {:ok, json} ->
        {:ok, Enum.map(json, &new(&1["ID"], conn))}

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
  @spec inspect(
          conn :: Connection.t(),
          params :: Connection.params(),
          headers :: Connection.headers()
        ) ::
          {:ok, term()} | {:error, Error.t()}
  def inspect(node, params \\ %{}, headers \\ []) do
    Connection.get(node.connection, path_for(node), params, headers)
    |> handle_json_response()
  end

  @doc since: "0.4.0"
  @spec inspect(
          conn :: Connection.t(),
          params :: Connection.params(),
          headers :: Connection.headers()
        ) ::
          term()
  def inspect!(node, params \\ %{}, headers \\ []) do
    inspect(node, params, headers)
    |> bang!()
  end

  @doc since: "0.4.0"
  @spec delete(
          node :: t(),
          params :: Connection.params(),
          headers :: Connection.headers()
        ) ::
          :ok | {:error, Error.t()}
  def delete(node, params \\ %{}, headers \\ []) do
    Connection.delete(node.connection, path_for(node), params, headers)
    |> handle_no_response()
  end

  @doc since: "0.4.0"
  @spec delete(
          node :: t(),
          params :: Connection.params(),
          headers :: Connection.headers()
        ) ::
          :ok
  def delete!(node, params \\ %{}, headers \\ []) do
    delete(node, params, headers)
    |> bang!()
  end

  @doc since: "0.4.0"
  @spec update(
          node :: t(),
          params :: Connection.params(),
          body :: Connection.body(),
          headers :: Connection.headers()
        ) ::
          :ok | {:error, Error.t()}
  def update(node, params \\ %{}, body \\ nil, headers \\ []) do
    Connection.post(node.connection, path_for(node, :update), params, body, headers)
    |> handle_no_response()
  end

  @doc since: "0.4.0"
  @spec update!(
          node :: t(),
          params :: Connection.params(),
          body :: Connection.body(),
          headers :: Connection.headers()
        ) ::
          :ok
  def update!(node, params \\ %{}, body \\ nil, headers \\ []) do
    update(node, params, body, headers)
    |> bang!()
  end
end
