output "ppdm_ssh_public_key" {
  sensitive = true
  value     = var.ppdm_count > 0 ? module.ppdm[*].ssh_public_key : null
}

output "ppdm_ssh_private_key" {
  sensitive = true
  value     = var.ppdm_count > 0 ? module.ppdm[*].ssh_private_key : null
}
output "ppdm_private_ip" {
  value       = var.ppdm_count > 0 ? module.ppdm[*].ppdm_private_ip_address : null
  description = "The private ip address for all ppdm Instances"
}
output "ppdm_public_ip_address" {
  sensitive = false
  value     = var.ppdm_count > 0 ? module.ppdm[*].public_ip_address : null
}
output "ppdm_fqdn" {
  sensitive = false
  value     = var.ppdm_count > 0 ? module.ppdm[*].public_fqdn : null
}

output "PPDM_SSH_PUBLIC_KEY" {
  sensitive = true
  value     = var.ppdm_count > 0 ? module.ppdm[0].ssh_public_key : null
}

output "PPDM_SSH_PRIVATE_KEY" {
  sensitive = true
  value     = var.ppdm_count > 0 ? module.ppdm[0].ssh_private_key : null
}

output "PPDM_PUBLIC_IP_ADDRESS" {
  sensitive = false
  value     = var.ppdm_count > 0 ? module.ppdm[0].public_ip_address : null
}
output "PPDM_FQDN" {
  sensitive = false
  value     = var.ppdm_count > 0 ? module.ppdm[0].public_fqdn : null
}
output "PPDM_PRIVATE_FQDN" {
  sensitive = false
  value     = var.ppdm_count > 0 ? module.ppdm[0].private_fqdn : null
}
output "ppdm_initial_password" {
  sensitive = true
  value     = var.ppdm_count > 0 ? var.ppdm_initial_password : null
}

output "PPDM_PRIVATE_IP" {
  value       = var.ppdm_count > 0 ? module.ppdm[0].ppdm_private_ip_address : null
  description = "The private ip address for the first ppdm Instance"
}

output "PPDM_HOSTNAME" {
  value       = var.ppdm_count > 0 ? module.ppdm[0].hostname : null
  description = "The private ip address for the first ppdm Instance"
}

output "ppdm_hostname" {
  value       = var.ppdm_count > 0 ? module.ppdm[*].hostname : null
  description = "The private ip address for the first ppdm Instance"
}
