#output "vpn_public_ip" {
#  value = length(azurerm_virtual_network_gateway.s2s_vpn.bgp_settings[0].peering_addresses[0].tunnel_ip_addresses) > 0 ? azurerm_virtual_network_gateway.s2s_vpn.bgp_settings[0].peering_addresses[0].tunnel_ip_addresses[0] : ""
#}
