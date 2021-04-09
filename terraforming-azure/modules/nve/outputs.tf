output "ssh_public_key" {
  sensitive = true
  value     = "${tls_private_key.nve.public_key_openssh}"
}

output "ssh_private_key" {
  sensitive = true
  value     = "${tls_private_key.nve.private_key_pem}"
}
output "public_fqdn" {
  value = length(azurerm_public_ip.publicip) > 0 ? azurerm_public_ip.publicip[0].fqdn : ""
}

output "private_ip" {
  value     = "${azurerm_network_interface.nve_nic.ip_configuration[0].private_ip_address}"
}
