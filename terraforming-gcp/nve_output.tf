output "NVE_FQDN" {
  value       = var.nve_count > 0 ? module.nve[0].nve_private_ip : null
  description = "The private ip address for the DDVE Instance"
}

output "nve_instance_id" {
  value       = var.nve_count > 0 ? module.nve[0].nve_instance_id : null
  description = "The instance id (initial password) for the DDVE Instance"
  sensitive   = true
}
output "nve_ssh_private_key" {
  sensitive   = true
  value       = var.nve_count > 0 ? module.nve[0].ssh_private_key : null
  description = "The ssh private key for the DDVE Instance"
}


output "nve_ssh_public_key" {
  value       = var.nve_count > 0 ? module.nve[0].ssh_public_key : null
  sensitive   = true
  description = "The ssh public key for the DDVE Instance"
}
