defmodule Harald.HCI.Command.ControllerAndBaseband.WriteClassOfDevice do
  use Harald.HCI.Command.ControllerAndBaseband, ocf: 0x0024

  @moduledoc """
  This command writes the value for the Class_Of_Device parameter.

  * OGF: `#{inspect(@ogf, base: :hex)}`
  * OCF: `#{inspect(@ocf, base: :hex)}`
  * Opcode: `#{inspect(@opcode)}`

  Bluetooth Spec v5.2, Vol 4, Part E, section 7.3.26

  ## Command Parameters
  * `class` - integer for class of devic

  ## Return Parameters
  * `:status` - see `Harald.ErrorCode`
  """

  defparameters class: 0x00

  defimpl HCI.Serializable do
    def serialize(%{opcode: opcode, class: class}) do
      <<opcode::binary, 3, class::24>>
    end
  end

  @impl Harald.HCI.Command
  def deserialize(<<@opcode::binary, 3, class::24>>) do
    {:ok, new(class: class)}
  end

  @impl Harald.HCI.Command
  def return_parameters(<<status::8>>) do
    %{status: Harald.ErrorCode.name!(status)}
  end
end
