output "ppdm_private_ip" {
    value = "${var.create_ppdm ? module.ppdm[0].private_ip  : "" }"
}


output "ppdm_ssh_private_key" {
    value = "${var.create_ppdm ? module.ppdm[0].ssh_private_key  : "" }"
    sensitive = true
}
output "ppdm_ssh_public_key" {
    value = "${var.create_ppdm ? module.ppdm[0].ssh_public_key : "" }"
    sensitive = true
}