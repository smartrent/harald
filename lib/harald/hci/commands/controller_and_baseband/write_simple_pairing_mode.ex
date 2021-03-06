defmodule Harald.HCI.Command.ControllerAndBaseband.WriteSimplePairingMode do
  use Harald.HCI.Command.ControllerAndBaseband, ocf: 0x0056

  @moduledoc """
  This command enables Simple Pairing mode in the BR/EDR Controller.

  * OGF: `#{inspect(@ogf, base: :hex)}`
  * OCF: `#{inspect(@ocf, base: :hex)}`
  * Opcode: `#{inspect(@opcode)}`

  Bluetooth Spec v5.2, Vol 4, Part E, section 7.3.59

  When Simple Pairing Mode is set to 'enabled' the Link Manager shall respond to
  an LMP_IO_CAPABILITY_REQ PDU with an LMP_IO_CAPABILITY_RES PDU and continue
  with the subsequent pairing procedure. When Simple Pairing mode is set to
  'disabled', the Link Manager shall reject an IO capability request. A Host
  shall not set the Simple Pairing Mode to ‘disabled.’

  Until Write_Simple_Pairing_Mode is received by the BR/EDR Controller, it shall
  not support any Simple Pairing sequences, and shall return the error code
  Simple Pairing not Supported by Host (0x37). This command shall be written
  before initiating page scan or paging procedures.

  The Link Manager Secure Simple Pairing (Host Support) feature bit shall be set
  to the Simple_Pairing_Mode parameter. The default value for
  Simple_Pairing_Mode shall be 'disabled.' When Simple_Pairing_Mode is set to
  'enabled,' the bit in the LMP features mask indicating support for Secure
  Simple Pairing (Host Support) shall be set to enabled in subsequent responses
  to an LMP_FEATURES_REQ from a remote device.

  ## Command Parameters
  * `enabled` - boolean to set if pairing mode enabled. Default `false`

  ## Return Parameters
  * `:status` - see `Harald.ErrorCode`
  """

  defparameters enabled: false

  defimpl HCI.Serializable do
    def serialize(%{opcode: opcode, enabled: enabled?}) do
      val = if enabled?, do: <<1>>, else: <<0>>
      <<opcode::binary, 1, val::binary>>
    end
  end

  @impl Harald.HCI.Command
  def deserialize(<<@opcode::binary, 1, enabled::binary>>) do
    val = if enabled == <<1>>, do: true, else: false
    {:ok, new(enabled: val)}
  end

  @impl Harald.HCI.Command
  def return_parameters(<<status::8>>) do
    %{status: Harald.ErrorCode.name!(status)}
  end
end
