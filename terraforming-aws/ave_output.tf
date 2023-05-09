
output "ave_private_ip" {
  value       = var.ave_count > 0 ? module.ave[0].ave_private_ip_address : null
  description = "The sprivate ip address for the AVE Instance"
}


output "ave_ssh_private_key" {
  sensitive   = true
  value       = var.ave_count > 0 ? module.ave[0].ssh_private_key : null
  description = "The ssh private key for the AVE Instance"
}

output "ave_ssh_public_key_name" {
  value       = var.ave_count > 0 ? module.ave[0].ssh_public_key_name : null
  description = "The ssh public key Name for the AVE Instance"
}

output "ave_ssh_public_key" {
  value       = var.ave_count > 0 ? module.ave[0].ssh_public_key : null
  description = "The ssh public key for the AVE Instance"
  sensitive   = true
}


output "ave_instance_id" {
  value       = var.ave_count > 0 ? module.ave[0].ave_instance_id : null
  description = "The instance id (initial password) for the DDVE Instance"
  sensitive   = true
}