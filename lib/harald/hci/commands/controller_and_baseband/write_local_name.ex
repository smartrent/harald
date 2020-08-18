defmodule Harald.HCI.Command.ControllerAndBaseband.WriteLocalName do
  use Harald.HCI.Command.ControllerAndBaseband, ocf: 0x0013

  @moduledoc """
  The HCI_Write_Local_Name command provides the ability to modify the user- friendly name for the BR/EDR Controller.

  * OGF: `#{inspect(@ogf, base: :hex)}`
  * OCF: `#{inspect(@ocf, base: :hex)}`
  * Opcode: `#{inspect(@opcode)}`

  Bluetooth Spec v5.2, Vol 4, Part E, section 7.3.11

  ## Command Parameters
  * `name` - A UTF-8 encoded User-Friendly Descriptive Name for the device. Up-to 248 bytes

  ## Return Parameters
  * `:status` - see `Harald.ErrorCode`
  """

  defparameters name: "Harald"

  defimpl HCI.Serializable do
    def serialize(%{opcode: opcode, name: name}) do
      padded = for _i <- 1..(248 - byte_size(name)), into: name, do: <<0>>
      <<opcode::binary, 248, padded::binary>>
    end
  end

  @impl Harald.HCI.Command
  def deserialize(<<@opcode::binary, 248, padded::binary>>) do
    {:ok, new(name: String.trim(padded, <<0>>))}
  end

  @impl Harald.HCI.Command
  def return_parameters(<<status::8>>) do
    %{status: Harald.ErrorCode.name!(status)}
  end
end
