
output "ave_private_ip" {
    value = "${var.create_ave ? module.ave[0].ave_private_ip_address : null }"
}


output "ave_ssh_private_key" {
  sensitive = true
  value     = "${var.create_ave ? module.ave[0].ssh_private_key : null}"
}

output "ave_ssh_public_key_name" {
  value = "${var.create_ave ? module.ave[0].ssh_public_key_name : null}"
}

output "ave_ssh_public_key" {
  value = "${var.create_ave ? module.ave[0].ssh_public_key : null}"
  sensitive = true
}