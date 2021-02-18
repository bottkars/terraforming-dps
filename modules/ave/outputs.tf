output "ave_ssh_public_key" {
  sensitive = true
  value     = "${tls_private_key.ave.public_key_openssh}"
}

output "ave_ssh_private_key" {
  sensitive = true
  value     = "${tls_private_key.ave.private_key_pem}"
}
output "ave_public_ip" {
  value = length(azurerm_public_ip.publicip) > 0 ? azurerm_public_ip.publicip[0].ip_address : ""
}

output "ave_private_ip" {
  value     = "${azurerm_network_interface.ave_nic.ip_configuration[0].private_ip_address}"
}
