defmodule DockerAPITest do
  use ExUnit.Case
  doctest DockerAPI

  test "greets the world" do
    assert DockerAPI.hello() == :world
  end
end
