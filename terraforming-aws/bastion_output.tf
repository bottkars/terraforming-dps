
output "bastion_public_ip" {
  value       = var.create_bastion ? module.bastion[0].bastion_public_ip_address : null
  description = "The private ip address for the DDVE Instance"
}

output "bastion_instance_id" {
  value       = var.create_bastion ? module.bastion[0].bastion_instance_id : null
  description = "The instance id (initial password) for the DDVE Instance"
  sensitive   = true
}
output "bastion_ssh_private_key" {
  sensitive   = true
  value       = var.create_bastion ? module.bastion[0].ssh_private_key : null
  description = "The ssh private key for the DDVE Instance"
}

output "bastion_ssh_public_key_name" {
  value       = var.create_bastion ? module.bastion[0].ssh_public_key_name : null
  description = "The ssh public key name  for the DDVE Instance"
}

output "bastion_ssh_public_key" {
  value       = var.create_bastion ? module.bastion[0].ssh_public_key : null
  sensitive   = true
  description = "The ssh public key for the DDVE Instance"
}


