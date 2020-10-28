defmodule DockerAPI.Exec do
  @moduledoc """
  Run new commands inside running containers. Refer to the command-line reference for more information.

  ## Official document

  https://docs.docker.com/engine/api/v1.40/#tag/Exec
  """

  alias DockerAPI.{Connection, Exec}

  defstruct id: nil, connection: nil

  @doc """
  Create an exec instance

  ## Official document

  https://docs.docker.com/engine/api/v1.40/#operation/ContainerExec

  ## Example

  DockerAPI.Connection.new() |> DockerAPI.Container.create!([], %{image: "ubuntu", tty: true}) |> DockerAPI.Container.start!() |> DockerAPI.Exec.create(%{"Cmd": ["now"]})
  {:ok,
  %DockerAPI.Exec{
   connection: %DockerAPI.Connection{
     headers: [],
     identity_token: nil,
     options: [],
     url: "http+unix://%2Fvar%2Frun%2Fdocker.sock",
     version: nil
   },
   id: "0785ff143b5eb5c624e1c3a2e1aad5afca2e2314ed1375d14b97ace1fb190bc9"
  }}

  """

  def create(container, body \\ %{}) do
    case Connection.post(container.connection, "/containers/#{container.id}/exec", [], body) do
      {:ok, json} ->
        {:ok, new(json, container.connection)}

      error ->
        error
    end
  end

  @doc """
  `DockerAPI.Exec.create/2`
  """

  def create!(container, body \\ %{}) do
    Connection.post!(container.connection, "/containers/#{container.id}/exec", [], body)
    |> new(container.connection)
  end

  @doc """
  Start an exec instance

  ## Official document

  https://docs.docker.com/engine/api/v1.40/#operation/ExecStart

  ## Example

  DockerAPI.Connection.new() |> DockerAPI.Container.create!([], %{image: "ubuntu", tty: true}) |> DockerAPI.Container.start!() |> DockerAPI.Exec.create!(%{"Cmd": ["date"]}) |> DockerAPI.Exec.start()
  :ok

  """

  def start(exec, body \\ %{}) do
    case Connection.post(exec.connection, path_for(exec, :start), [], body) do
      :ok ->
        exec

      error ->
        error
    end
  end

  @doc """
  `DockerAPI.Exec.start/2`
  """

  def start!(exec, body \\ %{}) do
    Connection.post!(exec.connection, path_for(exec, :start), [], body)
    exec
  end

  @doc """
  Resize an exec instance

  ## Official document

  https://docs.docker.com/engine/api/v1.40/#operation/ExecResize

  ## Example

  Please help!
  """

  def resize(exec, params \\ []) do
    case Connection.post(exec.connection, path_for(exec, :resize), params) do
      :ok ->
        exec

      error ->
        error
    end
  end

  @doc """
  `DockerAPI.Exec.resize/2`
  """

  def resize!(exec, params \\ []) do
    Connection.post!(exec.connection, path_for(exec, :resize), params)
    exec
  end

  @doc """
  Inspect an exec instance

  ## Official document

  https://docs.docker.com/engine/api/v1.40/#operation/ExecInspect

  ## Example

  DockerAPI.Connection.new("http+unix://%2Fvar%2Frun%2Fdocker.sock", [], [recv_timeout: :infinity]) |> DockerAPI.Container.create!([], %{image: "ubuntu", tty: true}) |> DockerAPI.Container.start!() |> DockerAPI.Exec.create!(%{"Cmd": ["date"], tty: true}) |> DockerAPI.Exec.inspect()
  {:ok,
  %{
   "CanRemove" => false,
   "ContainerID" => "06e465ea63ea586171cf3bced58b5127190eec7a3b9d8f1d107cb00f96f7f9ac",
   "DetachKeys" => "",
   "ExitCode" => nil,
   "ID" => "3da59eb80146d3c978fe662728dea8d17529f03543882e20128c1c0d79b71f7a",
   "OpenStderr" => false,
   "OpenStdin" => false,
   "OpenStdout" => false,
   "Pid" => 0,
   "ProcessConfig" => %{
     "arguments" => [],
     "entrypoint" => "date",
     "privileged" => false,
     "tty" => true
   },
   "Running" => false
  }}

  """

  def inspect(exec) do
    Connection.get(exec.connection, path_for(exec, :json))
  end

  @doc """
  `DockerAPI.Exec.inspect/1`
  """

  def inspect!(exec) do
    Connection.get!(exec.connection, path_for(exec, :json))
  end

  defp new(json, conn) do
    %Exec{
      id: json["Id"],
      connection: conn
    }
  end

  defp path_for(exec, path) do
    "/exec/#{exec.id}/#{path}"
  end
end
