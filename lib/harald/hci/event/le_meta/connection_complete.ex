defmodule Harald.HCI.Event.LEMeta.ConnectionComplete do
  @moduledoc """
  The HCI_LE_Connection_Complete event indicates to both of the Hosts forming
  the connection that a new connection has been created.

  Upon the creation of the connection a Connection_Handle shall be assigned by
  the Controller, and passed to the Host in this event. If the connection
  creation fails this event shall be provided to the Host that had issued the
  HCI_LE_Create_Connection command.

  This event indicates to the Host which issued an HCI_LE_Create_Connection
  command and received an HCI_Command_Status event if the connection creation
  failed or was successful.

  The Master_Clock_Accuracy parameter is only valid for a slave. On a master,
  this parameter shall be set to 0x00.

  Note: This event is not sent if the HCI_LE_Enhanced_Connection_Complete event
  (see Section 7.7.65.10) is unmasked.

  Reference: Version 5.2, Vol 4, Part E, 7.7.65.1
  """

  alias Harald.Serializable
  alias Harald.ErrorCode, as: Status

  defstruct [
    :status,
    :connection_handle,
    :role,
    :peer_address_type,
    :peer_address,
    :connection_interval,
    :connection_latency,
    :supervision_timeout,
    :master_clock_accuracy
  ]

  @type t :: %__MODULE__{}

  @behaviour Serializable

  @subevent_code 0x01

  @doc """
  See: `t:Harald.HCI.Event.LEMeta.subevent_code/0`.
  """
  def subevent_code, do: @subevent_code

  @impl Serializable
  def serialize(cc) do
    bin = <<
      Status.error_code!(cc.status),
      cc.connection_handle::little-16,
      cc.role,
      cc.peer_address_type,
      cc.peer_address::48,
      cc.connection_interval::little-16,
      cc.connection_latency::little-16,
      cc.supervision_timeout::little-16,
      cc.master_clock_accuracy
    >>

    {:ok, <<@subevent_code, bin::binary>>}
  end

  @impl Serializable
  def deserialize(<<@subevent_code, bin::binary>>) do
    <<
      status,
      connection_handle::little-16,
      role,
      peer_address_type,
      peer_address::48,
      connection_interval::little-16,
      connection_latency::little-16,
      supervision_timeout::little-16,
      master_clock_accuracy
    >> = bin

    cc = %__MODULE__{
      status: Status.name!(status),
      connection_handle: connection_handle,
      role: role,
      peer_address_type: peer_address_type,
      peer_address: peer_address,
      connection_interval: connection_interval,
      connection_latency: connection_latency,
      supervision_timeout: supervision_timeout,
      master_clock_accuracy: master_clock_accuracy
    }

    {:ok, cc}
  end

  def deserialize(bin), do: {:error, bin}
end
