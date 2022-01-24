
output "ave_private_ip" {
  value       = var.create_ave ? module.ave[0].ave_private_ip_address : null
  description = "The sprivate ip address for the AVE Instance"
}


output "ave_ssh_private_key" {
  sensitive   = true
  value       = var.create_ave ? module.ave[0].ssh_private_key : null
  description = "The ssh private key for the AVE Instance"
}


output "ave_ssh_public_key" {
  value       = var.create_ave ? module.ave[0].ssh_public_key : null
  description = "The ssh public key for the AVE Instance"
  sensitive   = true
}
