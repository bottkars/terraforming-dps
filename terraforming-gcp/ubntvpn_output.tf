

output "vpn_ip" {
    value = "${var.create_s2svpn? module.s2svpn[0].public_ip : "" }"
}