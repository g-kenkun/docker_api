defmodule DockerAPI.Container do
  @moduledoc false

  alias DockerAPI.{Connection, Container}

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

  def create(conn, params \\ [], body \\ %{}) do
    case Connection.post(conn, params, body) do
      {:ok, json} ->
        {:ok, new(json, conn)}

      {:error, error} ->
        {:error, error}
    end
  end

  def create!(conn, params \\ [], body \\ %{}) do
    Connection.post!(conn, params, body)
    |> new(conn)
  end

  def inspect(container, params \\ []) do
    Connection.get(container.connection, path_for(container, :json), params)
  end

  def inspect!(container, params \\ []) do
    Connection.get!(container.connection, path_for(container, :json), params)
  end

  def top(container, params \\ []) do
    Connection.get(container.connection, path_for(container, :top), params)
  end

  def top!(container, params \\ []) do
    Connection.get!(container.connection, path_for(container, :top), params)
  end

  def logs(_container, _params \\ []) do
    :none
  end

  def logs!(_container, _params \\ []) do
    :none
  end

  def changes(container) do
    Connection.get(container.connection, path_for(container, :changes))
  end

  def changes!(container) do
    Connection.get!(container.connection, path_for(container, :changes))
  end

  def export(container) do
    Connection.get(container.connection, path_for(container, :export))
  end

  def export!(container) do
    Connection.get!(container.connection, path_for(container, :export))
  end

  def stats(container, params \\ []) do
    Connection.get(container.connection, path_for(container, :stats), params)
  end

  def stats!(container, params \\ []) do
    Connection.get!(container.connection, path_for(container, :stats), params)
  end

  def resize(container, params \\ []) do
    Connection.post(container.connection, path_for(container, :resize), params)
  end

  def resize!(container, params \\ []) do
    Connection.post!(container.connection, path_for(container, :resize), params)
  end

  def start(container, params \\ []) do
    Connection.post(container.connection, path_for(container, :start), params)
  end

  def start!(container, params \\ []) do
    Connection.post!(container.connection, path_for(container, :start), params)
  end

  def stop(container, params \\ []) do
    Connection.post(container.connection, path_for(container, :stop), params)
  end

  def stop!(container, params \\ []) do
    Connection.post!(container.connection, path_for(container, :stop), params)
  end

  def restart(container, params \\ []) do
    Connection.post(container.connection, path_for(container, :restart), params)
  end

  def restart!(container, params \\ []) do
    Connection.post!(container.connection, path_for(container, :restart), params)
  end

  def kill(container, params \\ []) do
    Connection.post(container.connection, path_for(container, :kill), params)
  end

  def kill!(container, params \\ []) do
    Connection.post!(container.connection, path_for(container, :kill), params)
  end

  def update(container, params \\ [], body \\ %{}) do
    Connection.post(container.connection, path_for(container, :update), params, body)
  end

  def update!(container, params \\ [], body \\ %{}) do
    Connection.post!(container.connection, path_for(container, :update), params, body)
  end

  def rename(container, params \\ []) do
    Connection.post(container.connection, path_for(container, :rename), params)
  end

  def rename!(container, params \\ []) do
    Connection.post!(container.connection, path_for(container, :rename), params)
  end

  def pause(container, params \\ []) do
    Connection.post(container.connection, path_for(container, :pause), params)
  end

  def pause!(container, params \\ []) do
    Connection.post!(container.connection, path_for(container, :pause), params)
  end

  def unpause(container, params \\ []) do
    Connection.post(container.connection, path_for(container, :unpause), params)
  end

  def unpause!(container, params \\ []) do
    Connection.post!(container.connection, path_for(container, :unpause), params)
  end

  def attach(_container, _params \\ []) do
    :none
  end

  def attach!(_container, _params \\ []) do
    :none
  end

  def wait(container, params \\ []) do
    Connection.post(container.connection, path_for(container, :wait), params)
  end

  def wait!(container, params \\ []) do
    Connection.post!(container.connection, path_for(container, :wait), params)
  end

  def remove(container, params \\ []) do
    Connection.delete(container.connection, path_for(container), params)
  end

  def remove!(container, params \\ []) do
    Connection.delete!(container.connection, path_for(container), params)
  end

  def archive_head(container, params \\ []) do
    Connection.head(container.connection, path_for(container, :archive), params)
  end

  def archive_head!(container, params \\ []) do
    Connection.head!(container.connection, path_for(container, :archive), params)
  end

  def archive_get(container, params \\ []) do
    Connection.get(container.connection, path_for(container, :archive), params)
  end

  def archive_get!(container, params \\ []) do
    Connection.get!(container.connection, path_for(container, :archive), params)
  end

  def archive_put(container, params \\ [], body \\ "") do
    Connection.put(container.connection, path_for(container, :archive), params, body)
  end

  def archive_put!(container, params \\ [], body \\ "") do
    Connection.put!(container.connection, path_for(container, :archive), params, body)
  end

  def prune(conn, params \\ []) do
    Connection.post(conn, path_for(:prune), params)
  end

  def prune!(conn, params \\ []) do
    Connection.post!(conn, path_for(:prune), params)
  end

  defp new(json, conn) do
    %Container{
      id: json["Id"],
      connection: conn
    }
  end

  defp path_for(path) when is_atom(path) do
    "/containers/#{path}"
  end

  defp path_for(container) do
    "/containers/#{container.id}"
  end

  defp path_for(container, path) do
    "/containers/#{container.id}/#{path}"
  end
end
