defmodule Harald.HCI.Event.DisconnectionComplete do
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
    :status,
    :connection_handle,
    :reason
  ]

  @event_code 0x05

  @doc """
  Returns the Inquiry Complete event code.
  """
  def event_code, do: @event_code

  @impl Serializable
  def serialize(%__MODULE__{} = dc) do
    {:ok,
     <<
       Harald.ErrorCode.error_code!(dc.status),
       dc.connection_handle::little-16,
       Harald.ErrorCode.error_code!(dc.reason)
     >>}
  end

  @impl Serializable
  def deserialize(<<status::8, connection_handle::little-16, reason::8>>) do
    dc = %__MODULE__{
      status: Harald.ErrorCode.name!(status),
      connection_handle: connection_handle,
      reason: Harald.ErrorCode.name!(reason)
    }

    {:ok, dc}
  end

  def deserialize(bin), do: {:error, bin}
end
