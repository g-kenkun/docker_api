defmodule DockerAPI.Connection do
  @moduledoc false

  alias DockerAPI.{Connection, Error}

  defstruct url: nil, headers: [], options: [], version: nil, identity_token: nil

  defguard is_success_status_code(status_code) when 200 <= status_code and status_code < 300
  defguard is_redirect_status_code(status_code) when 300 <= status_code and status_code < 400
  defguard is_client_error_status_code(status_code) when 400 <= status_code and status_code < 500
  defguard is_server_error_status_code(status_code) when 500 <= status_code and status_code < 600

  defguard is_no_problem_status_code(status_code)
           when is_success_status_code(status_code) or is_redirect_status_code(status_code)

  defguard is_error_status_code(status_code)
           when is_client_error_status_code(status_code) or
                  is_server_error_status_code(status_code)

  def new(
        url \\ "http+unix://%2Fvar%2Frun%2Fdocker.sock",
        headers \\ [],
        options \\ [],
        version \\ nil
      ) do
    %Connection{url: url, headers: headers, options: options, version: version}
  end

  def get(conn, path, params \\ []) do
    build_url(conn, path)
    |> HTTPoison.get(conn.headers, Keyword.merge(conn.options, params: params))
    |> handle_response()
  end

  def get!(conn, path, params \\ []) do
    Connection.get(conn, path, params)
    |> handle_response!()
  end

  def head(conn, path, params \\ []) do
    build_url(conn, path)
    |> HTTPoison.head(conn.headers, Keyword.merge(conn.options, params: params))
    |> handle_response()
  end

  def head!(conn, path, params \\ []) do
    Connection.head(conn, path, params)
    |> handle_response!
  end

  def post(conn, path, params \\ []) do
    Connection.post(conn, path, params, "")
  end

  def post(conn, path, params, body) when is_map(body) do
    case Jason.encode(body) do
      {:ok, body} ->
        conn
        |> add_header(:"Content-Type", "application/json")
        |> Connection.post(path, params, body)

      {:error, error = %Jason.EncodeError{}} ->
        %Error{message: error.message}
    end
  end

  def post(conn, path, params, body) do
    build_url(conn, path)
    |> HTTPoison.post(body, conn.headers, Keyword.merge(conn.options, params: params))
    |> handle_response()
  end

  def post!(conn, path, params \\ []) do
    Connection.post!(conn, path, params, "")
  end

  def post!(conn, path, params, body) when is_map(body) do
    case Jason.encode(body) do
      {:ok, body} ->
        conn
        |> add_header(:"Content-Type", "application/json")
        |> Connection.post!(path, params, body)

      {:error, error = %Jason.EncodeError{}} ->
        %Error{message: error.message}
    end
  end

  def post!(conn, path, params, body) do
    Connection.post(conn, path, params, body)
    |> handle_response!()
  end

  def put(conn, path, params \\ [], body \\ "") do
    build_url(conn, path)
    |> HTTPoison.put(body, conn.headers, Keyword.merge(conn.options, params: params))
    |> handle_response()
  end

  def put!(conn, path, params \\ [], body \\ "") do
    Connection.put(conn, path, params, body)
    |> handle_response!()
  end

  def delete(conn, path, params \\ []) do
    build_url(conn, path)
    |> HTTPoison.delete(conn.headers, Keyword.merge(conn.options, params: params))
    |> handle_response()
  end

  def delete!(conn, path, params \\ []) do
    Connection.delete(conn, path, params)
    |> handle_response!()
  end

  def add_header(conn, key, value) do
    %Connection{
      conn
    | headers: Keyword.put(conn.headers, key, value)
    }
  end

  defp build_url(%Connection{version: nil} = conn, path) do
    conn.url <> path
  end

  defp build_url(conn, path) do
    conn.url <> "/" <> conn.version <> path
  end

  defp handle_response(resp_tuple) do
    case resp_tuple do
      {:ok, resp} ->
        case resp do
          %HTTPoison.Response{
            status_code: status_code,
            request: %HTTPoison.Request{method: method}
          }
          when is_no_problem_status_code(status_code) and method in [:get, :post, :delete, :put] ->
            case resp.body do
              "" ->
                :ok

              body ->
                case Jason.decode(body) do
                  {:ok, json} ->
                    {:ok, json}

                  {:error, _} ->
                    {:ok, body}
                end
            end

          %HTTPoison.Response{
            status_code: status_code,
            request: %HTTPoison.Request{method: :head}
          }
          when is_no_problem_status_code(status_code) ->
            {:ok, resp.headers}

          %HTTPoison.Response{
            status_code: status_code
          }
          when is_error_status_code(status_code) ->
            case resp.body do
              "" ->
                {:error, %Error{status_code: status_code}}

              body ->
                case Jason.decode(body) do
                  {:ok, json} ->
                    {:error, %Error{status_code: status_code, message: json["message"]}}

                  {:error, _} ->
                    {:error, %Error{status_code: status_code, message: body}}
                end
            end
        end

      {:error, error} ->
        case error do
          error when is_struct(error, HTTPoison.Error) ->
            {:error, %Error{message: error.reason}}
        end
    end
  end

  defp handle_response!(resp_tuple) do
    case resp_tuple do
      :ok ->
        :ok

      {:ok, resp} ->
        resp

      {:error, error} ->
        raise(Error, error.message)
    end
  end
end
