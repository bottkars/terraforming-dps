
output "NVE_PRIVATE_IP" {
  value       = var.nve_count > 0 ? module.nve[0].nve_private_ip_address : null
  description = "The private ip address for the first NVE Instance"
}

output "nve_private_ip" {
  value       = var.nve_count > 0 ? module.nve[*].nve_private_ip_address : null
  description = "The private ip addresses for the NVE Instances"
}
output "NVE_SSH_PRIVATE_KEY" {
  sensitive   = true
  value       = var.nve_count > 0 ? module.nve[0].ssh_private_key : null
  description = "The ssh private key for the NVE Instance"
}
output "nve_ssh_private_key" {
  sensitive   = true
  value       = var.nve_count > 0 ? module.nve[*].ssh_private_key : null
  description = "The ssh private key´s for the NVE Instances"
}

output "NVE_SSH_PUBLIC_KEY" {
  value       = var.nve_count > 0 ? module.nve[0].ssh_public_key : null
  sensitive   = true
  description = "The ssh public key for the NVE Instance"
}

output "nve_ssh_public_key" {
  value       = var.nve_count > 0 ? module.nve[*].ssh_public_key : null
  sensitive   = true
  description = "The ssh public keys for the NVE Instances"
}
output "nve_private_fqdn" {
  sensitive = false
  value     = var.nve_count > 0 ? module.nve[*].private_fqdn : null
  description = "the private FQDN of the NVE´s"
}
output "NVE_PRIVATE_FQDN" {
  sensitive = false
  value     = var.nve_count > 0 ? module.nve[0].private_fqdn : null
  description = "the private FQDN of the first NVE"

}

output "nve_public_fqdn" {
  sensitive = false
  value     = var.nve_count > 0  && var.nve_public_ip ? module.nve[*].private_fqdn : module.nve[*].nve_private_ip_address
  description = "the private FQDN of the NVE´s"
}
output "NVE_PUBLIC_FQDN" {
  sensitive = false
  value     = var.nve_count > 0  && var.nve_public_ip ? module.nve[0].public_fqdn : var.nve_count > 0  &&! var.nve_public_ip ? module.nve[0].nve_private_ip_address : null
  description = "we will use the Private IP as FQDN if no pubblic is registered, so api calls can work"
}
output "NVE_PUBLIC_IP" {
  sensitive = false
  value     = var.nve_count > 0  && var.nve_public_ip ? module.nve[0].public_ip : var.nve_count > 0  &&! var.nve_public_ip ? module.nve[0].nve_private_ip_address : null
  description = "we will use the Private IP as FQDN if no pubblic is registered, so api calls can work"
}
output "NVE_PASSWORD" {
  sensitive=true
  value= var.nve_count > 0 ? var.nve_initial_password : null
}
