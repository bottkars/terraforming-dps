
output "VAULT_PPDM_FQDN" {
  value       = var.vault_ppdm_count > 0 ? module.vault_ppdm[0].ppdm_private_ip_address : null
  description = "The private ip address for the DDVE Instance"
}

output "vault_ppdm_instance_id" {
  value       = var.vault_ppdm_count > 0 ? module.vault_ppdm[0].ppdm_instance_id : null
  description = "The instance id (initial password) for the DDVE Instance"
  sensitive   = true
}
output "vault_ppdm_ssh_private_key" {
  sensitive   = true
  value       = var.vault_ppdm_count > 0 ? module.vault_ppdm[0].ssh_private_key : null
  description = "The ssh private key for the DDVE Instance"
}

output "vault_ppdm_ssh_public_key_name" {
  value       = var.vault_ppdm_count > 0 ? module.vault_ppdm[0].ssh_public_key_name : null
  description = "The ssh public key name  for the DDVE Instance"
}

output "vault_ppdm_ssh_public_key" {
  value       = var.vault_ppdm_count > 0 ? module.vault_ppdm[0].ssh_public_key : null
  sensitive   = true
  description = "The ssh public key for the DDVE Instance"
}

