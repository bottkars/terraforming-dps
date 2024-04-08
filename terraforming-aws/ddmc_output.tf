
output "ddmc_private_ip" {
  value       = var.ddmc_count > 0 ? module.ddmc[0].ddmc_private_ip_address : null
  description = "The private ip address for the ddmc Instance"
}

output "ddmc_instance_id" {
  value       = var.ddmc_count > 0 ? module.ddmc[0].ddmc_instance_id : null
  description = "The instance id (initial password) for the ddmc Instance"
  sensitive   = true
}
output "ddmc_ssh_private_key" {
  sensitive   = true
  value       = var.ddmc_count > 0 ? module.ddmc[0].ssh_private_key : null
  description = "The ssh private key for the ddmc Instance"
}

output "ddmc_ssh_public_key_name" {
  value       = var.ddmc_count > 0 ? module.ddmc[0].ssh_public_key_name : null
  description = "The ssh public key name  for the ddmc Instance"
}

output "ddmc_ssh_public_key" {
  value       = var.ddmc_count > 0 ? module.ddmc[0].ssh_public_key : null
  sensitive   = true
  description = "The ssh public key for the ddmc Instance"
}
