
output "DDVE_PRIVATE_IP" {
  value       = var.ddve_count > 0 ? module.ddve[*].ddve_private_ip_address : null
  description = "The private ip address for the DDVE Instance"
}

output "ddve_private_ip" {
  value       = var.ddve_count > 0 ? module.ddve[0].ddve_private_ip_address : null
  description = "The private ip address for the DDVE Instance"
}
output "ddve_ssh_private_key" {
  sensitive   = true
  value       = var.ddve_count > 0 ? module.ddve[0].ssh_private_key : null
  description = "The ssh private key for the DDVE Instance"
}


output "ddve_ssh_public_key" {
  value       = var.ddve_count > 0 ? module.ddve[0].ssh_public_key : null
  sensitive   = true
  description = "The ssh public key for the DDVE Instance"
}
output "ddve_private_fqdn" {
  sensitive = false
  value     = var.ddve_count > 0 ? module.ddve[0].private_fqdn : null
}
output "DDVE_PRIVATE_FQDN" {
  sensitive = false
  value     = var.ddve_count > 0 ? module.ddve[*].private_fqdn : null
}
