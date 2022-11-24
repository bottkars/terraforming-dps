output "crs_tunnel1_address" {
  value       = var.create_crs_s2s_vpn ? module.crs_s2s_vpn[0].tunnel1_address : null
  description = "The address for the VPN tunnel to configure your local device"
}


output "ddcr_ssh_private_key" {
  sensitive   = true
  value       = var.create_vault  ? module.cr[0].ddcr_ssh_private_key : null
  description = "The ssh private key for the DDVE Instance"
}

output "crjump_ssh_private_key" {
  sensitive = true
  value       = var.create_vault  ? module.cr[0].crjump_ssh_private_key : null
  description = "The ssh public key name  for the DDVE Instance"
}

output "ppcr_ssh_private_key" {
  sensitive   = true
  value       = var.create_vault  ? module.cr[0].ppcr_ssh_private_key : null
  description = "The ssh private key for the DDVE Instance"
}
