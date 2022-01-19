
output "ddve_private_ip" {
    value = "${var.create_ddve ? module.ddve[0].ddve_private_ip_address : null }"
  description = "The private ip address for the DDVE Instance"
}

output "ddve_instance_id" {
    value = "${var.create_ddve ? module.ddve[0].ddve_instance_id : null }"
  description = "The instance id (initial password) for the DDVE Instance"
  sensitive = true
}
output "ddve_ssh_private_key" {
  sensitive = true
  value     = "${var.create_ddve ? module.ddve[0].ssh_private_key : null}"
  description = "The ssh private key for the DDVE Instance"
}

output "ddve_ssh_public_key_name" {
  value = "${var.create_ddve ? module.ddve[0].ssh_public_key_name : null}"
  description = "The ssh public key name  for the DDVE Instance"
}

output "ddve_ssh_public_key" {
  value = "${var.create_ddve ? module.ddve[0].ssh_public_key : null}"
  sensitive = true
  description = "The ssh public key for the DDVE Instance"
}

output "atos_bucket" {
  value = "${var.create_ddve ? module.ddve[0].atos_bucket : null}"
  sensitive = true
  description = "The S3 Bucket Name created for ATOS configuration"
}