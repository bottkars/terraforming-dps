output "tunnel1_address" {
  value       = var.create_s2s_vpn ? module.s2s_vpn[0].tunnel1_address : null
  description = "The address for the VPN tunnel to configure your local device"
}
