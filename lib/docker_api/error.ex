defmodule DockerAPI.Error do
  @type t() :: %__MODULE__{message: String.t(), status_code: Mint.Types.status()}
  defexception message: nil, status_code: nil
end
