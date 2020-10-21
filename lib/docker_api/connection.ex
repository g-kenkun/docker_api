defmodule DockerAPI.Connection do
  @moduledoc false

  alias DockerAPI.{Connection, Error}

  defstruct url: "", headers: [], options: [], identity_token: ""

  def new(url \\ "http+unix://%2Fvar%2Frun%2Fdocker.sock", headers \\ [], options \\ [])
      when is_binary(url) and is_list(headers) and is_list(options) do
    %Connection{url: url, headers: headers, options: options}
  end

  def get(conn = %Connection{}, path, params \\ []) do
    url = conn.url <> path

    HTTPoison.get(url, conn.headers, Keyword.merge(conn.options, params: params))
    |> handle_response()
  end

  def get!(conn = %Connection{}, path, params \\ []) do
    get(conn, path, params)
    |> handle_response!
  end

  def post(conn = %Connection{}, path, params \\ [], body \\ "") do
    url = conn.url <> path

    HTTPoison.post(url, body, conn.headers, Keyword.merge(conn.options, params: params))
    |> handle_response()
  end

  def post!(conn = %Connection{}, path, params \\ [], body \\ "") do
    post(conn, path, params, body)
    |> handle_response!()
  end

  def delete(conn = %Connection{}, path, params) do
    url = conn.url <> path

    HTTPoison.delete(url, conn.headers, Keyword.merge(conn.options, params: params))
    |> handle_response()
  end

  def delete!(conn = %Connection{}, path, params) do
    delete(conn, path, params)
    |> handle_response!()
  end

  defp build_url(conn, path) do
    conn.url <> path
  end

  defp handle_response(resp_tuple) do
    case resp_tuple do
      {:ok, %HTTPoison.Response{status_code: status_code, body: body}}
      when status_code in [200, 201] ->
        case Jason.decode(body) do
          {:ok, json} ->
            {:ok, json}

          {:error, _} ->
            {:ok, body}
        end

      {:ok, %HTTPoison.Response{status_code: _, body: body}} ->
        json = Jason.decode!(body)
        {:error, %Error{reason: json["message"]}}

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, %Error{reason: reason}}
    end
  end

  defp handle_response!(resp_tuple) do
    case resp_tuple do
      {:ok, resp} ->
        resp

      {:error, error} ->
        raise(Error, error.reason)
    end
  end
end
