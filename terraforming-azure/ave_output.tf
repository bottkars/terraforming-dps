
output "AVE_PRIVATE_IP" {
  value       = var.ave_count > 0 ? module.ave[0].ave_private_ip_address : null
  description = "The private ip address for the first AVE Instance"
}

output "ave_private_ip" {
  value       = var.ave_count > 0 ? module.ave[*].ave_private_ip_address : null
  description = "The private ip addresses for the AVE Instances"
}
output "AVE_SSH_PRIVATE_KEY" {
  sensitive   = true
  value       = var.ave_count > 0 ? module.ave[0].ssh_private_key : null
  description = "The ssh private key for the AVE Instance"
}
output "ave_ssh_private_key" {
  sensitive   = true
  value       = var.ave_count > 0 ? module.ave[*].ssh_private_key : null
  description = "The ssh private key´s for the AVE Instances"
}

output "AVE_SSH_PUBLIC_KEY" {
  value       = var.ave_count > 0 ? module.ave[0].ssh_public_key : null
  sensitive   = true
  description = "The ssh public key for the AVE Instance"
}

output "ave_ssh_public_key" {
  value       = var.ave_count > 0 ? module.ave[*].ssh_public_key : null
  sensitive   = true
  description = "The ssh public keys for the AVE Instances"
}
output "ave_private_fqdn" {
  sensitive = false
  value     = var.ave_count > 0 ? module.ave[*].private_fqdn : null
  description = "the private FQDN of the AVE´s"
}
output "AVE_PRIVATE_FQDN" {
  sensitive = false
  value     = var.ave_count > 0 ? module.ave[0].private_fqdn : null
  description = "the private FQDN of the first AVE"

}

output "ave_public_fqdn" {
  sensitive = false
  value     = var.ave_count > 0  && var.ave_public_ip ? module.ave[*].private_fqdn : module.ave[*].ave_private_ip_address
  description = "the private FQDN of the AVE´s"
}
output "AVE_PUBLIC_FQDN" {
  sensitive = false
  value     = var.ave_count > 0  && var.ave_public_ip ? module.ave[0].public_fqdn : var.ave_count > 0  &&! var.ave_public_ip ? module.ave[0].ave_private_ip_address : null
  description = "we will use the Priovate IP as FQDN if no pubblic is registered, so api calls can work"
}
output "AVE_PUBLIC_IP" {
  sensitive = false
  value     = var.ave_count > 0  && var.ave_public_ip ? module.ave[0].public_ip : var.ave_count > 0  &&! var.ave_public_ip ? module.ave[0].ave_private_ip_address : null
  description = "we will use the Priovate IP as FQDN if no pubblic is registered, so api calls can work"
}
output "AVE_PASSWORD" {
  sensitive=true
  value= var.ave_count > 0 ? var.ave_initial_password : null
}
