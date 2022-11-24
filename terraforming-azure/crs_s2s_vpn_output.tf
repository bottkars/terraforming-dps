
output "crs_vpn_public_ip" {
  sensitive   = false
  value       = var.create_crs_s2s_vpn ? module.crs_s2s_vpn[0].vpn_public_ip : null
  description = "The IP of the VPN Vnet Gateway"
}

