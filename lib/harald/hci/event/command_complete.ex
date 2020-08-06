defmodule Harald.HCI.Event.CommandComplete do
  @moduledoc """
  > The Command Complete event is used by the Controller for most commands to
  > transmit return status of a command and the other event parameters that are
  > specified for the issued HCI command.

  Reference: Version 5.0, Vol 2, Part E, 7.7.14
  """

  alias Harald.Serializable

  @behaviour Serializable

  @type t :: %__MODULE__{}

  defstruct [
    :num_hci_command_packets,
    :opcode,
    :return_parameters
  ]

  @event_code 0x0E

  @doc """
  Returns the Inquiry Complete event code.
  """
  def event_code, do: @event_code

  @impl Serializable
  def serialize(%__MODULE__{} = data) do
    {:ok,
     <<
       data.num_hci_command_packets::8,
       data.opcode::16,
       data.return_parameters::binary
     >>}
  end

  @impl Serializable
  def deserialize(<<num_hci_command_packets::8, opcode::little-16, return_parameters::binary>>) do
    {:ok,
     %__MODULE__{
       num_hci_command_packets: num_hci_command_packets,
       opcode: opcode,
       return_parameters: return_parameters
     }}
  end

  def deserialize(bin), do: {:error, bin}
end
