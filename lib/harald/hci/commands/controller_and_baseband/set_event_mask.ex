defmodule Harald.HCI.Command.ControllerAndBaseband.SetEventMask do
  use Harald.HCI.Command.ControllerAndBaseband, ocf: 0x0001

  @moduledoc """
  Reset the baseband

  * OGF: `#{inspect(@ogf, base: :hex)}`
  * OCF: `#{inspect(@ocf, base: :hex)}`
  * Opcode: `#{inspect(@opcode)}`

  Bluetooth Spec v5.2, Vol 4, Part E, section 7.3.1

  The HCI_Set_Event_Mask command is used to control which events are generated by the HCI for the Host. If the bit in the Event_Mask is set to a one, then the event associated with that bit will be enabled. For an LE Controller, the “LE Meta event” bit in the event_Mask shall enable or disable all LE events in the LE Meta event (see Section 7.7.65). The event mask allows the Host to control how much it is interrupted.

  The Controller shall ignore those bits which are reserved for future use or represent events which it does not support. If the Host sets any of these bits to 1, the Controller shall act as if they were set to 0.

  ## Command Parameters
  Accepts a list of event identifiers as atoms to indicate whether that
  event should be included in the mask.

  see Bluetooth Spec v5.2, Vol 4, Part E, section 7.3.1, Command parameters

  ## Return Parameters
  * `:status` - see `Harald.ErrorCode`
  """

  alias __MODULE__

  @events_map %{
    0 => :inquiry_complete,
    1 => :inquiry_result,
    2 => :connection_complete,
    3 => :connection_request,
    4 => :disconnection_complete,
    5 => :authentication_complete,
    6 => :remote_name_request_complete,
    7 => :encryption_change,
    8 => :change_connection_link_key_complete,
    9 => :master_link_key_complete,
    10 => :read_remote_supported_features_complete,
    11 => :read_remote_version_information_complete,
    12 => :qos_setup_complete,
    15 => :hardware_error,
    16 => :flush_occurred,
    17 => :role_change,
    19 => :mode_change,
    20 => :return_link_keys,
    21 => :pin_code_request,
    22 => :link_key_request,
    23 => :link_key_notification,
    24 => :loopback_command,
    25 => :data_buffer_overflow,
    26 => :max_slots_change,
    27 => :read_clock_offset_complete,
    28 => :connection_packet_type_changed,
    29 => :qos_violation,
    30 => :page_scan_mode_change,
    31 => :page_scan_repetition_mode_change,
    32 => :flow_specification_complete,
    33 => :inquiry_resultwith_rssi,
    34 => :read_remote_extended_features_complete,
    43 => :synchronous_connection_complete,
    44 => :synchronous_connection_changed,
    45 => :sniff_subrating,
    46 => :extended_inquiry_result,
    47 => :encryption_key_refresh_complete,
    48 => :io_capability_request,
    49 => :io_capability_response,
    50 => :user_confirmation_request,
    51 => :user_passkey_request,
    52 => :remote_oob_data_request,
    53 => :simple_pairing_complete,
    55 => :link_supervision_timeout_changed,
    56 => :enhanced_flush_complete,
    58 => :user_passkey_notification,
    59 => :keypress_notification,
    60 => :remote_host_supported_features_notification,
    61 => :le_meta
  }

  defparameters Map.values(@events_map)

  defimpl HCI.Serializable do
    def serialize(%{opcode: opcode} = sem) do
      mask = SetEventMask.mask_events(sem)
      size = byte_size(mask)
      <<opcode::binary, size::8, mask::binary>>
    end
  end

  @impl Harald.HCI.Command
  def deserialize(<<@opcode::binary, 8, mask::binary>>) do
    {:ok, new(unmask_events(mask))}
  end

  @impl Harald.HCI.Command
  def return_parameters(<<status::8>>) do
    %{status: Harald.ErrorCode.name!(status)}
  end

  @doc false
  def mask_events(%__MODULE__{} = sem) do
    for bit_pos <- 0..63, into: <<>> do
      key = @events_map[bit_pos]
      bit = bit_value(Map.get(sem, key))
      <<bit::1>>
    end
  end

  @doc false
  def unmask_events(mask) do
    for {bit_pos, key} <- @events_map do
      {key, ExBin.bit_at(mask, bit_pos)}
    end
  end

  defp bit_value(val) when val in [1, "1", true, <<1>>], do: 1
  defp bit_value(_val), do: 0
end
