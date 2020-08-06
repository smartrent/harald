defmodule Harald.HCI.ControllerAndBaseband do
  alias Harald.HCI

  @moduledoc """
  HCI commands for working with the controller and baseband.

  > The Controller & Baseband Commands provide access and control to various capabilities of the
  > Bluetooth hardware. These parameters provide control of BR/EDR Controllers and of the
  > capabilities of the Link Manager and Baseband in the BR/EDR Controller, the PAL in an AMP
  > Controller, and the Link Layer in an LE Controller. The Host can use these commands to modify
  > the behavior of the local Controller.
  Bluetooth Spec v5
  """

  @ogf 0x03

  @doc """
  > The Read_Local_Name command provides the ability to read the stored user-friendly name for
  > the BR/EDR Controller. See Section 6.23.

      iex> read_local_name()
      <<20, 12, 0>>
  """
  @spec read_local_name :: HCI.command()
  def read_local_name, do: @ogf |> HCI.opcode(0x0014) |> HCI.command()

  @doc """
  Reset the baseband

    iex> reset()
    <<0x03, 0x0C, 0x0>>
  """
  @spec reset :: HCI.command()
  def reset(), do: @ogf |> HCI.opcode(0x03) |> HCI.command()

  @doc """
  > The Set_Event_Mask command is used to control which events are generated
  > by the HCI for the Host. If the bit in the Event_Mask is set to a one,
  > then the event associated with that bit will be enabled. For an LE Controller,
  > the “LE Meta Event” bit in the Event_Mask shall enable or disable all LE
  > events in the LE Meta Event

    iex> set_event_mask(<<0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0x3F>>)
    <<0x1, 0xC, 0x8, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0x3F>>
  """
  @spec set_event_mask(<<_::8, _::_*8>>) :: HCI.command()
  def set_event_mask(mask) when byte_size(mask) == 0x8,
    do: @ogf |> HCI.opcode(0x0001) |> HCI.command(mask)

  @doc """
  > This command enables Simple Pairing mode in the BR/EDR Controller.
  > When Simple Pairing Mode is set to 'enabled' the Link Manager shall
  > respond to an LMP_io_capability_req PDU with an LMP_io_capability_res
  > PDU and continue with the subsequent pairing procedure.
  > When Simple Pairing mode is set to 'disabled', the Link Manager
  > shall reject an IO capability request. A Host shall not set the Simple
  > Pairing Mode to ‘disabled.’

      iex> write_simple_pairing_mode(true)
      <<0x56, 0x0C, 0x01, 0x01>>

      iex> write_simple_pairing_mode(false)
      <<0x56, 0x0C, 0x01, 0x00>>
  """
  @spec write_simple_pairing_mode(boolean) :: HCI.command()
  def write_simple_pairing_mode(enabled?),
    do: @ogf |> HCI.opcode(0x0056) |> HCI.command([enabled?])

  @doc """
  > This command writes the value for the Page_Timeout configuration parameter.
  > The Page_Timeout configuration parameter defines the maximum time the local
  > Link Manager shall wait for a baseband page response from the remote device
  > at a locally initiated connection attempt. If this time expires and the
  > remote device has not responded to the page at baseband level,
  > the connection attempt will be considered to have failed.

      iex> write_page_timeout(0x60)
      <<0x18, 0x0C, 0x02, 0x00, 0x60>>
  """
  @spec write_page_timeout(timeout :: 0..65535) :: HCI.command()
  def write_page_timeout(timeout) when timeout <= 65535,
    do: @ogf |> HCI.opcode(0x0018) |> HCI.command(<<timeout::16>>)

  @doc """
  > This command writes the value for the Class_of_Device parameter.

      iex> write_class_of_device(0x0C027A)
      <<0x24, 0x0C, 0x03, 0x0C, 0x02, 0x7A>>
  """
  @spec write_class_of_device(class :: 0..16_777_215) :: HCI.command()
  def write_class_of_device(class) when class <= 16_777_215,
    do: @ogf |> HCI.opcode(0x0024) |> HCI.command(<<class::24>>)

  @doc """
  > The Write_Local_Name command provides the ability to modify the
  > user-friendly name for the BR/EDR Controller.

      iex> write_local_name("some friendly name")
      <<19, 12, 248, 115, 111, 109, 101, 32, 102, 114, 105, 101, 110, 100, 108, 121,
        32, 110, 97, 109, 101, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, ...>>
  """
  @spec write_local_name(name :: <<_::248, _::_*8>>) :: HCI.command()
  def write_local_name(name) when byte_size(name) <= 248 do
    remaining = 248 - byte_size(name)
    padding = :binary.copy(<<0x00>>, remaining)
    @ogf |> HCI.opcode(0x0013) |> HCI.command(name <> padding)
  end

  @doc """
  > The Write_Extended_Inquiry_Response command writes the extended inquiry
  > response to be sent during the extended inquiry response procedure.
  > The FEC_Required command parameter states if FEC encoding is required.
  > The extended inquiry response data is not preserved over a reset.
  > The initial value of the inquiry response data is all zero octets.
  > The controller shall not interpret the extended inquiry response data.

      iex> write_extended_inquiry_response(false, <<0x1A, 0x9, 0x42, 0x54, 0x73, 0x74, 0x61, 0x63, 0x6B, 0x20, 0x45,
        0x20, 0x38, 0x3A, 0x34, 0x45, 0x3A, 0x30, 0x36, 0x3A, 0x38, 0x31, 0x3A, 0x41, 0x34, 0x3A,
        0x35, 0x30, 0x20>>)
      <<0x13, 0xC, 0xF1, 0x0, 0x1A, 0x9, 0x42, 0x54, 0x73, 0x74, 0x61, 0x63, 0x6B,
        0x20, 0x45, 0x20, 0x38, 0x3A, 0x34, 0x45, 0x3A, 0x30, 0x36, 0x3A, 0x38, 0x31,
        0x3A, 0x41, 0x34, 0x3A, 0x35, 0x30, 0x20, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0,
        0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, ...>>
  """
  def write_extended_inquiry_response(fec_required?, response) when byte_size(response) <= 240 do
    fec_required = HCI.to_bin(fec_required?)
    remaining = 240 - byte_size(response)
    padding = :binary.copy(<<0x00>>, remaining)
    @ogf |> HCI.opcode(0x0013) |> HCI.command(fec_required <> response <> padding)
  end

  @doc """
  > This command writes the Inquiry_Mode configuration parameter of the local
  > BR/EDR Controller.

    iex> write_inquiry_mode(0x00)
    <<0x045, 0x0C, 0x01, 0x00>>
  """
  @spec write_inquiry_mode(mode :: 0x00 | 0x01 | 0x02) :: HCI.command()
  def write_inquiry_mode(mode) when mode <= 0x02,
    do: @ogf |> HCI.opcode(0x0045) |> HCI.command(<<mode::8>>)

  @doc """
  > This command writes the Secure_Connections_Host_Support parameter in
  > the BR/EDR Controller.

    iex> write_secure_connections_host_support(true)
    <<0x7A, 0x0C, 0x01, 0x01>>

    iex> write_secure_connections_host_support(false)
    <<0x7A, 0x0C, 0x01, 0x00>>
  """
  @spec write_secure_connections_host_support(boolean()) :: HCI.command()
  def write_secure_connections_host_support(support?),
    do: @ogf |> HCI.opcode(0x007A) |> HCI.command([support?])
end
