defmodule DockerAPI.Connection do
  alias DockerAPI.{Connection, Error}

  defstruct endpoint: "http://localhost",
            unix_socket: "/var/run/docker.sock",
            identity_token: nil

  @type endpoint() :: String.t()

  @type unix_socket() :: String.t()

  @type identity_token() :: String.t()

  @type t() :: %__MODULE__{
          endpoint: endpoint(),
          unix_socket: unix_socket() | nil,
          identity_token: identity_token() | nil
        }

  @type path() :: String.t()

  @type params() :: map() | list() | String.t()

  @type headers() :: [{header_name :: String.t(), header_value :: String.t()}, ...]

  @type body() :: map() | list() | String.t() | nil

  @spec new(
          endpoint :: endpoint(),
          unix_socket :: unix_socket(),
          identity_token :: identity_token()
        ) :: t()
  def new(
        endpoint \\ "http://localhost/",
        unix_socket \\ "/var/run/docker.sock",
        identity_token \\ nil
      ) do
    %Connection{
      endpoint: endpoint,
      unix_socket: unix_socket,
      identity_token: identity_token
    }
  end

  @spec get(conn :: t(), path :: path(), params :: params(), headers :: headers()) ::
          {:ok, binary()} | {:error, Exception.t()}
  def get(conn, path, params, headers) do
    build_request(:get, conn, path, params, headers)
    |> Finch.request(DockerAPI.Finch)
    |> handle_get_response()
  end

  @spec head(conn :: t(), path :: path(), params :: params(), headers :: headers()) ::
          {:ok, headers()} | {:error, Exception.t()}
  def head(conn, path, params, headers) do
    build_request(:head, conn, path, params, headers)
    |> Finch.request(DockerAPI.Finch)
    |> handle_head_response()
  end

  @spec post(
          conn :: t(),
          path :: path(),
          params :: params(),
          body :: body(),
          headers :: headers()
        ) ::
          {:ok, binary()} | {:error, Exception.t()}
  def post(conn, path, params, body, headers) do
    build_request(:post, conn, path, params, headers, body)
    |> Finch.request(DockerAPI.Finch)
    |> handle_post_response()
  end

  @spec put(
          conn :: t(),
          path :: path(),
          params :: params(),
          body :: body(),
          headers :: headers()
        ) ::
          {:ok, binary()} | {:error, Exception.t()}
  def put(conn, path, params, body, headers) do
    build_request(:put, conn, path, params, headers, body)
    |> Finch.request(DockerAPI.Finch)
    |> handle_put_response()
  end

  @spec delete(
          conn :: t(),
          path :: path(),
          params :: params(),
          headers :: headers()
        ) ::
          {:ok, binary()} | {:error, Exception.t()}
  def delete(conn, path, params, headers) do
    build_request(:delete, conn, path, params, headers)
    |> Finch.request(DockerAPI.Finch)
    |> handle_delete_response()
  end

  @spec build_request(
          method :: Finch.Request.method(),
          conn :: t(),
          path :: path(),
          params :: params(),
          headers :: headers(),
          body :: body()
        ) :: Finch.Request.t()
  def build_request(method, conn, path, params, headers, body \\ nil)

  def build_request(method, conn, path, params, headers, body) when is_map(body) or is_list(body),
    do: build_request(method, conn, path, params, headers, Jason.encode!(body))

  def build_request(method, conn, path, params, headers, body) do
    query_string = URI.encode_query(params, :rfc3986)
    url = URI.parse(conn.endpoint) |> URI.merge(%URI{path: path, query: query_string})

    opts = if conn.unix_socket, do: [socket_path: conn.unix_socket], else: []

    Finch.build(method, url, headers, body, opts)
  end

  defp handle_get_response({:ok, %Finch.Response{body: body, status: status}})
       when status in 200..399 do
    body
  end

  defp handle_get_response({:ok, _} = res) do
    handle_bad_response(res)
  end

  defp handle_get_response({:error, _} = res) do
    handle_bad_response(res)
  end

  defp handle_head_response({:ok, %Finch.Response{headers: headers, status: status}})
       when status in 200..399 do
    headers
  end

  defp handle_head_response({:ok, _} = res) do
    handle_bad_response(res)
  end

  defp handle_head_response({:error, _} = res) do
    handle_bad_response(res)
  end

  defp handle_post_response({:ok, %Finch.Response{body: body, status: status}})
       when status in 200..399 do
    body
  end

  defp handle_post_response({:ok, _} = res) do
    handle_bad_response(res)
  end

  defp handle_post_response({:error, _} = res) do
    handle_bad_response(res)
  end

  defp handle_put_response({:ok, %Finch.Response{body: body, status: status}})
       when status in 200..399 do
    body
  end

  defp handle_put_response({:ok, _} = res) do
    handle_bad_response(res)
  end

  defp handle_put_response({:error, _} = res) do
    handle_bad_response(res)
  end

  defp handle_delete_response({:ok, %Finch.Response{body: body, status: status}})
       when status in 200..399 do
    body
  end

  defp handle_delete_response({:ok, _} = res) do
    handle_bad_response(res)
  end

  defp handle_delete_response({:error, _} = res) do
    handle_bad_response(res)
  end

  defp handle_bad_response({:ok, %Finch.Response{body: body, status: status}}) do
    json = Jason.decode!(body)
    {:error, %Error{status_code: status, message: json["message"]}}
  end

  defp handle_bad_response({:error, exception}) do
    {:error, %Error{message: Exception.message(exception)}}
  end
end
