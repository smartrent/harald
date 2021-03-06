defmodule Harald.HCI.Command.ControllerAndBaseband.ReadLocalName do
  use Harald.HCI.Command.ControllerAndBaseband, ocf: 0x0014

  @moduledoc """
  The Read_Local_Name command provides the ability to read the stored user-friendly name for
  the BR/EDR Controller. See Section 6.23 and 7.3.12 for more details

  * OGF: `#{inspect(@ogf, base: :hex)}`
  * OCF: `#{inspect(@ocf, base: :hex)}`
  * Opcode: `#{inspect(@opcode)}`

  ## Command Parameters
  > None

  ## Return Parameters
  * `:status` - see `Harald.ErrorCode`
  * `:local_name` - A UTF-8 encoded User Friendly Descriptive Name for the device
  """

  defparameters []

  defimpl HCI.Serializable do
    def serialize(%{opcode: opcode}) do
      <<opcode::binary, 0::8, "">>
    end
  end

  @impl true
  def deserialize(<<@opcode::binary, 0::8, "">>) do
    # This is a pretty useless function because there aren't
    # any parameters to actually parse out of this, but we
    # can at least assert its correct with matching
    {:ok, %__MODULE__{}}
  end

  @impl true
  def return_parameters(<<status::8, local_name::binary>>) do
    %{
      status: Harald.ErrorCode.name!(status),
      # The local name field will fill any remainder of the
      # 248 bytes with null bytes. So just trim those.
      local_name: String.trim(local_name, <<0>>)
    }
  end
end
