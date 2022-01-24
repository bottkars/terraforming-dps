
output "vpn_public_ip" {
  sensitive   = false
  value       = var.create_s2s_vpn ? module.s2s_vpn[0].vpn_public_ip : null
  description = "The IP of the VPN Vnet Gateway"
}

