

output "vpn_ip" {
    value = "${var.create_infra? module.infra[0].public_ip : "" }"
}