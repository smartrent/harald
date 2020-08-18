defmodule Harald.HCI.Command do
  @callback return_parameters(binary()) :: map() | binary()
  @callback deserialize(binary()) :: {:ok, term()} | {:error, term()}

  alias __MODULE__.{ControllerAndBaseband, LEController}

  @modules [
    ControllerAndBaseband.ReadLocalName,
    ControllerAndBaseband.Reset,
    ControllerAndBaseband.SetEventMask,
    ControllerAndBaseband.WriteClassOfDevice,
    ControllerAndBaseband.WriteLocalName,
    ControllerAndBaseband.WritePageTimeout,
    ControllerAndBaseband.WriteSimplePairingMode,
    LEController.CreateConnection
  ]

  def __modules__(), do: @modules

  defmacro defparameters(fields) do
    quote location: :keep, bind_quoted: [fields: fields] do
      fields =
        if Keyword.keyword?(fields) do
          fields
        else
          for key <- fields, do: {key, nil}
        end

      # This is odd, but defparameters/1 is only intended to be used
      # in modules with Harald.HCI.Command.__using__/1 macro which will
      # have these attributes defined. If not, let it fail
      fields = Keyword.merge(fields, ogf: @ogf, ocf: @ocf, opcode: @opcode)
      defstruct fields
    end
  end

  defmacro __using__(opts) do
    quote location: :keep, bind_quoted: [opts: opts] do
      ogf =
        Keyword.get_lazy(opts, :ogf, fn ->
          raise ":ogf key required when defining HCI.Command.__using__/1"
        end)

      @behaviour Harald.HCI.Command
      import Harald.HCI.Command, only: [defparameters: 1]

      @ogf ogf

      def __ogf__(), do: @ogf

      def new(args \\ []), do: struct(__MODULE__, args)
    end
  end
end
