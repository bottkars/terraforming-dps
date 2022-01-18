
output "ddve_private_ip" {
    value = "${var.create_ddve ? module.ddve[0].ddve_private_ip_address : null }"
}

output "ddve_instance_id" {
    value = "${var.create_ddve ? module.ddve[0].ddve_instance_id : null }"
}
output "ddve_ssh_private_key" {
  sensitive = true
  value     = "${var.create_ddve ? module.ddve[0].ssh_private_key : null}"
}

output "ddve_ssh_public_key_name" {
  value = "${var.create_ddve ? module.ddve[0].ssh_public_key_name : null}"
}

output "ddve_ssh_public_key" {
  value = "${var.create_ddve ? module.ddve[0].ssh_public_key : null}"
  sensitive = true
}