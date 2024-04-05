
output "vault_nve_private_ip" {
  value       = var.vault_nve_count > 0 ? module.vault_nve[0].nve_private_ip_address : null
  description = "The sprivate ip address for the nve Instance"
}

output "vault_nve_private_ips" {
  value       = var.vault_nve_count > 1 ? module.vault_nve[*].nve_private_ip_address : null
  description = "The sprivate ip address for the nve Instance"
}
output "vault_nve_ssh_private_key" {
  sensitive   = true
  value       = var.vault_nve_count > 0 ? module.vault_nve[0].ssh_private_key : null
  description = "The ssh private key for the nve Instance"
}

output "vault_nve_ssh_private_keys" {
  sensitive   = true
  value       = var.vault_nve_count > 1 ? module.vault_nve[*].ssh_private_key : null
  description = "The ssh private key for the vault_nve Instance"
}

output "vault_nve_ssh_public_key_name" {
  value       = var.vault_nve_count > 0 ? module.vault_nve[0].ssh_public_key_name : null
  description = "The ssh public key Name for the vault_nve Instance"
}

output "vault_nve_ssh_public_key" {
  value       = var.vault_nve_count > 0 ? module.vault_nve[0].ssh_public_key : null
  description = "The ssh public key for the vault_nve Instance"
  sensitive   = true
}


output "vault_nve_instance_id" {
  value       = var.vault_nve_count > 0 ? module.vault_nve[0].nve_instance_id : null
  description = "The instance id (initial password) for the DDVE Instance"
  sensitive   = true
}

output "vault_nve_instance_ids" {
  value       = var.vault_nve_count > 1 ? module.vault_nve[*].nve_instance_id : null
  description = "The instance id (initial password) for the DDVE Instance"
  sensitive   = true
}