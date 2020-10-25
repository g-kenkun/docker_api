defmodule DockerAPI.Base do
  @moduledoc false

  alias DockerAPI.Connection

  defmacro __using__(base_path) do
    quote do
      import unquote(__MODULE__)
      import DockerAPI.{Util, Connection}
      defstruct id: nil, connection: nil
      Module.put_attribute(__MODULE__, :base_path, unquote(base_path))
      @before_compile unquote(__MODULE__)
    end
  end

  defmacro __before_compile__(_env) do
    quote do
      def path_for, do: "/#{@base_path}"
      def path_for(path) when is_binary(path), do: "/#{@base_path}/#{path}}"
      def path_for(struct_) when is_struct(struct_), do: "/#{@base_path}/#{struct_.id}}"

      def path_for(struct_, path) when is_struct(struct_) and is_binary(path),
        do: "/#{@base_path}/#{struct_.id}/#{path}}"

      def new(json, conn = %Connection{}) do
        %__MODULE__{
          id: json["ID"] || json["Id"],
          connection: conn
        }
      end
    end
  end
end
