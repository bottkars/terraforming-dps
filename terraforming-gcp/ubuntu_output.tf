output "ubuntu_private_ip" {
  value       = var.ubuntu_count > 0 ? module.ubuntu[0].ubuntu_private_ip : null
  description = "The private ip address for the DDVE Instance"
}

output "ubuntu_instance_id" {
  value       = var.ubuntu_count > 0 ? module.ubuntu[0].ubuntu_instance_id : null
  description = "The instance id (initial password) for the DDVE Instance"
  sensitive   = true
}
output "ubuntu_ssh_private_key" {
  sensitive   = true
  value       = var.ubuntu_count > 0 ? module.ubuntu[0].ssh_private_key : null
  description = "The ssh private key for the DDVE Instance"
}


output "ubuntu_ssh_public_key" {
  value       = var.ubuntu_count > 0 ? module.ubuntu[0].ssh_public_key : null
  sensitive   = true
  description = "The ssh public key for the DDVE Instance"
}
