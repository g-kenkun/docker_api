defmodule DockerAPI.Exec do
  @moduledoc false

  alias DockerAPI.{Connection, Container, Exec}

  defstruct id: nil, connection: nil

  def create(container = %Container{}, body \\ %{}) when is_map(body) do
    case Connection.post(container.connection, "/containers/#{container.id}/exec", [], body) do
      {:ok, json} ->
        {:ok, new(json, container.connection)}

      {:error, error} ->
        {:error, error}
    end
  end

  def create!(container = %Container{}, body \\ %{}) when is_map(body) do
    Connection.post!(container.connection, "/containers/#{container.id}/exec", [], body)
    |> new(container.connection)
  end

  def start(exec = %Exec{}, body \\ %{}) do
    Connection.post(exec.connection, path_for(exec, "start"), [], body)
  end

  def start!(exec = %Exec{}, body \\ %{}) do
    Connection.post!(exec.connection, path_for(exec, "start"), [], body)
  end

  def resize(exec = %Exec{}, body \\ %{}) do
    Connection.post(exec.connection, path_for(exec, "resize"), [], body)
  end

  def resize!(exec = %Exec{}, body \\ %{}) do
    Connection.post!(exec.connection, path_for(exec, "resize"), [], body)
  end

  def inspect(exec = %Exec{}) do
    Connection.get(exec.connection, path_for(exec, "json"))
  end

  def inspect!(exec = %Exec{}) do
    Connection.get!(exec.connection, path_for(exec, "json"))
  end

  defp new(json, conn) do
    %Exec{
      id: json["Id"],
      connection: conn
    }
  end

  defp path_for(exec = %Exec{}, path) when is_binary(path) do
    "/exec/#{exec.id}/#{path}"
  end
end
