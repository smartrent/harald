defmodule Harald.HCI.InformationalParameters do
  @moduledoc """
  > The Informational Parameters are fixed by the
  > manufacturer of the Bluetooth hardware.
  > These parameters provide information about the BR/EDR
  > Controller and the capabilities of the Link Manager and
  > Baseband in the BR/EDR Controller and PAL in the AMP Controller.
  > The host device cannot modify any of these parameters.

  See Section 7.4 of the Bluetooth spec
  """

  alias Harald.HCI

  @ogf 0x04

  @doc """

  """
  def read_local_version(), do: @ogf |> HCI.opcode(0x0001) |> HCI.command()

  @doc """
  > This command reads the list of HCI commands supported for
  > the local Controller.This command shall return the Supported_Commands
  > configuration parameter. It is implied that if a command is
  > listed as supported, the feature underlying that command is also supported.

      iex> read_local_supported_commands()
      <<0x02, 0x10, 0x00>>
  """
  def read_local_supported_commands(), do: @ogf |> HCI.opcode(0x0002) |> HCI.command()

  @doc """
  > This command requests a list of the supported features for the local BR/EDR Controller.

      iex> read_local_supported_features()
      <<0x03, 0x10, 0x00>>
  """
  def read_local_supported_features(), do: @ogf |> HCI.opcode(0x0003) |> HCI.command()

  @doc """
  > On a BR/EDR Controller, this command reads the Bluetooth Controller address
  > On an LE Controller, this command shall read the Public Device Address as defined

      iex> read_bd_addr()
      <<0x09, 0x10, 0x00>>
  """
  def read_bd_addr(), do: @ogf |> HCI.opcode(0x0009) |> HCI.command()

  @doc """
  > The Read_Buffer_Size command is used to read the maximum size of
  > the data portion of HCI ACL and synchronous Data Packets sent
  > from the Host to the Controller. The Host will segment the data
  > to be transmitted from the Host to the Controller according to
  > these sizes, so that the HCI Data Packets will contain data with
  > up to these sizes. The Read_Buffer_Size command also returns the
  > total number of HCI ACL and synchronous Data Packets that can be
  > stored in the data buffers of the Controller. The Read_Buffer_Size
  > command must be issued by the Host before it sends any data to the
  > Controller.

      iex> read_buffer_size()
      <<0x05, 0x10, 0x00>>
  """
  def read_buffer_size(), do: @ogf |> HCI.opcode(0x0005) |> HCI.command()
end
