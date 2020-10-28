defmodule DockerAPI.Secret do
  @moduledoc """
  Secrets are sensitive data that can be used by services. Swarm mode must be enabled for these endpoints to work.
  """

  alias DockerAPI.{Connection, Secret}

  defstruct id: nil, connection: nil

  @doc """
  List secrets

  ## Official document

  https://docs.docker.com/engine/api/v1.40/#operation/SecretList

  ## Example

  Please help!
  """

  def list(conn, params \\ []) do
    case Connection.get(conn, path_for(), params) do
      {:ok, json} ->
        {:ok, Enum.map(json, &new(&1, conn))}

      error ->
        error
    end
  end

  @doc """
  `DockerAPI.Secret.list/2`
  """

  def list!(conn, params \\ []) do
    Connection.get(conn, path_for(), params)
    |> Enum.map(&new(&1, conn))
  end

  @doc """
  Create a secret

  ## Official document

  https://docs.docker.com/engine/api/v1.40/#operation/SecretCreate

  ## Example

  Please help!
  """

  def create(conn, body \\ %{}) do
    case Connection.post(conn, path_for(:create), [], body) do
      {:ok, json} ->
        {:ok, new(json, conn)}

      error ->
        error
    end
  end

  @doc """
  `DockerAPI.Secret.create/2`
  """

  def create!(conn, body \\ %{}) do
    Connection.post!(conn, path_for(:create), [], body)
    |> new(conn)
  end

  @doc """
  Inspect a secret

  ## Official document

  https://docs.docker.com/engine/api/v1.40/#operation/SecretInspect

  ## Example

  Please help!
  """

  def inspect(secret) do
    Connection.get(secret.connection, path_for(secret))
  end

  @doc """
  `DockerAPI.Secret.inspect/1`
  """

  def inspect!(secret) do
    Connection.get!(secret.connection, path_for(secret))
  end

  @doc """
  Delete a secret

  ## Official document

  https://docs.docker.com/engine/api/v1.40/#operation/SecretDelete

  ## Example

  Please help!
  """

  def delete(secret) do
    Connection.delete(secret.connection, path_for(secret))
  end

  @doc """
  `DockerAPI.Secret.delete/1`
  """

  def delete!(secret) do
    Connection.delete!(secret.connection, path_for(secret))
  end

  @doc """
  Update a Secret

  ## Official document

  https://docs.docker.com/engine/api/v1.40/#operation/SecretUpdate

  ## Example

  Please help!
  """

  def update(secret, params \\ [], body \\ %{})
      when is_list(params) and is_map(body) do
    case Connection.post(secret.connection, path_for(secret, :update), params, body) do
      :ok ->
        {:ok, secret}

      error ->
        error
    end
  end

  @doc """
  `DockerAPI.Secret.update/3`
  """

  def update!(secret, params \\ [], body \\ %{}) do
    Connection.post!(secret.connection, path_for(secret, :update), params, body)
    secret
  end

  defp new(json, conn) do
    %Secret{
      id: json["ID"],
      connection: conn
    }
  end

  defp path_for do
    "/secrets"
  end

  defp path_for(path) when is_atom(path) do
    "/secrets/#{path}"
  end

  defp path_for(secret = %Secret{}) do
    "/secrets/#{secret.id}}"
  end

  defp path_for(secret = %Secret{}, path) do
    "/secrets/#{secret.id}/#{path}"
  end
end
