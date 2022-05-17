defmodule DockerAPI.Endpoints.Distribution do
  use DockerAPI.Base, "/distribution"

  alias DockerAPI.{Connection, Error}
  alias DockerAPI.Endpoints.Image

  @moduledoc since: "0.4.0"
  @moduledoc """
  Distribution

  ## Official document

  https://docs.docker.com/engine/api/v1.41/#tag/Distribution
  """

  @doc """
  Get image information from the registry

  ## Official document

  https://docs.docker.com/engine/api/v1.41/#tag/Distribution

  ## Example

  Please help!
  """

  @type id() :: String.t()

  @type t() :: %__MODULE__{id: id(), connection: Connection.t()}

  @doc since: "0.4.0"
  @spec inspect(
          image :: Image.t(),
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
          image :: Image.t(),
          params :: Connection.params(),
          headers :: Connection.headers()
        ) ::
          term()
  def inspect!(image, params \\ %{}, headers \\ []) do
    inspect(image, params, headers)
    |> bang!()
  end
end
