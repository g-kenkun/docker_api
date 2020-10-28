defmodule DockerAPI.Error do
  @moduledoc false

  defexception [:message, :status_code]
end
