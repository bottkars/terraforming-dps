output "ddve_private_ip" {
    value = "${var.create_ddve ? module.ddve[0].private_ip  : "" }"
}


output "ddve_ssh_private_key" {
    value = "${var.create_ddve ? module.ddve[0].ssh_private_key  : "" }"
    sensitive = true
}
output "ddve_ssh_public_key" {
    value = "${var.create_ddve ? module.ddve[0].ssh_public_key : "" }"
    sensitive = true
}