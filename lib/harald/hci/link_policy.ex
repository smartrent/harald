defmodule Harald.HCI.LinkPolicy do
  @moduledoc """
  > The Link Policy Commands provide methods for the Host to affect
  > how the Link Manager manages the piconet. When Link Policy Commands are
  > used, the LM still controls how Bluetooth piconets and scatternets are
  > established and maintained, depending on adjustable policy parameters.
  > These policy commands modify the Link Manager behavior that can result
  > in changes to the link layer connections with Bluetooth remote devices

  Section 7.2 in the Bluetooth spec
  """
  alias Harald.HCI

  @ogf 0x02

  @doc """
  > This command writes the Default Link Policy configuration value.
  > The Default_Link_Policy_Settings parameter determines the initial
  > value of the Link_Policy_Settings for all new BR/EDR connections.

      iex> write_default_link_policy_settings(0x0)
      <<0x0F, 0x08, 0x02, 0x00, 0x00>>
  """
  @spec write_default_link_policy_settings(mode :: 0x0 | 0x0001 | 0x0002 | 0x0004 | 0x0008) ::
          HCI.command()
  def write_default_link_policy_settings(mode) when mode in [0x0, 0x0001, 0x0002, 0x0004, 0x0008],
    do: @ogf |> HCI.opcode(0x000F) |> HCI.command(<<mode::16>>)
end
