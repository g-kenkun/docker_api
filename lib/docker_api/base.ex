defmodule DockerAPI.Base do
  @moduledoc false

  alias DockerAPI.Connection

  defmacro __using__(base_path) do
    quote do
      import unquote(__MODULE__)

      Module.put_attribute(__MODULE__, :base_path, unquote(base_path))

      defstruct id: nil, connection: nil

      @before_compile unquote(__MODULE__)
    end
  end

  defmacro __before_compile__(_env) do
    quote do
      def path_for, do: @base_path
      def path_for(path) when is_atom(path), do: Path.join(@base_path, to_string(path))

      def path_for(struct) when is_struct(struct),
        do: Path.join(@base_path, struct.id)

      def path_for(struct, path) when is_struct(struct) and is_atom(path),
        do: Path.join([@base_path, struct.id, to_string(path)])

      def new(id, conn = %Connection{}) do
        %__MODULE__{
          id: id,
          connection: conn
        }
      end

      @spec handle_no_response({:ok, term()}) :: :ok
      def handle_no_response({:ok, _}), do: :ok

      @spec handle_no_response({:error, DockerAPI.Error.t()}) :: {:error, DockerAPI.Error.t()}
      def handle_no_response(error), do: error

      @spec handle_json_response({:ok, binary()}) :: {:ok, term()}
      def handle_json_response({:ok, body}), do: {:ok, Jason.decode!(body)}

      @spec handle_json_response({:error, DockerAPI.Error.t()}) :: {:error, DockerAPI.Error.t()}
      def handle_json_response(error), do: error

      @spec bang!(:ok) :: :ok
      def bang!(:ok), do: :ok

      @spec bang!({:ok, term()}) :: term()
      def bang!({:ok, response}), do: response

      @spec bang!({:error, DockerAPI.Error.t()}) :: no_return()
      def bang!({:error, error}), do: raise(DockerAPI.Error, error.message)
    end
  end
end
