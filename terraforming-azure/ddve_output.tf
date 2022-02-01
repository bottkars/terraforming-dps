
output "DDVE_PRIVATE_IP" {
  value       = var.ddve_count > 0 ? module.ddve[0].ddve_private_ip_address : null
  description = "The private ip address for the first DDVE Instance"
}

output "ddve_private_ip" {
  value       = var.ddve_count > 0 ? module.ddve[*].ddve_private_ip_address : null
  description = "The private ip addresses for the DDVE Instances"
}
output "DDVE_SSH_PRIVATE_KEY" {
  sensitive   = true
  value       = var.ddve_count > 0 ? module.ddve[0].ssh_private_key : null
  description = "The ssh private key for the DDVE Instance"
}
output "ddve_ssh_private_key" {
  sensitive   = true
  value       = var.ddve_count > 0 ? module.ddve[*].ssh_private_key : null
  description = "The ssh private key´s for the DDVE Instances"
}

output "DDVE_SSH_PUBLIC_KEY" {
  value       = var.ddve_count > 0 ? module.ddve[0].ssh_public_key : null
  sensitive   = true
  description = "The ssh public key for the DDVE Instance"
}

output "ddve_ssh_public_key" {
  value       = var.ddve_count > 0 ? module.ddve[*].ssh_public_key : null
  sensitive   = true
  description = "The ssh public keys for the DDVE Instances"
}
output "ddve_private_fqdn" {
  sensitive = false
  value     = var.ddve_count > 0 ? module.ddve[*].private_fqdn : null
  description = "the private FQDN of the DDVE´s"
}
output "DDVE_PRIVATE_FQDN" {
  sensitive = false
  value     = var.ddve_count > 0 ? module.ddve[0].private_fqdn : null
  description = "the private FQDN of the first DDVE"

}

output "ddve_public_fqdn" {
  sensitive = false
  value     = var.ddve_count > 0  && var.ddve_public_ip ? module.ddve[*].private_fqdn : module.ddve[*].ddve_private_ip_address
  description = "the private FQDN of the DDVE´s"
}
output "DDVE_PUBLIC_FQDN" {
  sensitive = false
  value     = var.ddve_count > 0  && var.ddve_public_ip ? module.ddve[0].public_fqdn : var.ddve_count > 0  &&! var.ddve_public_ip ? module.ddve[0].ddve_private_ip_address : null
  description = "we will use the Priovate IP as FQDN if no pubblic is registered, so api calls can work"
}

output "DDVE_PASSWORD" {
  sensitive=true
  value= var.ddve_count > 0 ? var.ddve_initial_password : null
}
