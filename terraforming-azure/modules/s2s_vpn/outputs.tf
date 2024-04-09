output "vpn_public_ip" {
  value = length(azurerm_public_ip.s2s_vpn.ip_address) > 0 ? azurerm_public_ip.s2s_vpn.ip_address : ""
}
