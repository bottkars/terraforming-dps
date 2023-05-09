
output "nve_private_ip" {
  value       = var.nve_count > 0 ? module.nve[0].nve_private_ip_address : null
  description = "The sprivate ip address for the nve Instance"
}


output "nve_ssh_private_key" {
  sensitive   = true
  value       = var.nve_count > 0 ? module.nve[0].ssh_private_key : null
  description = "The ssh private key for the nve Instance"
}

output "nve_ssh_public_key_name" {
  value       = var.nve_count > 0 ? module.nve[0].ssh_public_key_name : null
  description = "The ssh public key Name for the nve Instance"
}

output "nve_ssh_public_key" {
  value       = var.nve_count > 0 ? module.nve[0].ssh_public_key : null
  description = "The ssh public key for the nve Instance"
  sensitive   = true
}


output "nve_instance_id" {
  value       = var.nve_count > 0 ? module.nve[0].nve_instance_id : null
  description = "The instance id (initial password) for the DDVE Instance"
  sensitive   = true
}