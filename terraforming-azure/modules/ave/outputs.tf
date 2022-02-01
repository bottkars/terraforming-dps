output "ssh_public_key" {
  sensitive = true
  value     = tls_private_key.ave.public_key_openssh
}

output "ssh_private_key" {
  sensitive = true
  value     = tls_private_key.ave.private_key_pem
}

output "ave_public_fqdn" {
  value = length(azurerm_public_ip.publicip) > 0 ? azurerm_public_ip.publicip[0].fqdn : ""
}

output "ave_private_ip_address" {
  value = azurerm_network_interface.ave_nic.private_ip_address
}
output "ave_public_ip_address" {
  value = length(azurerm_public_ip.publicip) > 0 ? azurerm_public_ip.publicip[0].ip_address : ""
}
output "private_fqdn" {
  sensitive = false
  value     = trimsuffix(azurerm_private_dns_a_record.ave_dns.fqdn, ".")
}
