defmodule DockerAPI.Util do
  @moduledoc false

  alias DockerAPI.Connection

  def add_header(conn, key, value) do
    %Connection{
      conn
      | headers: Keyword.put(conn.headers, key, value)
    }
  end
end
