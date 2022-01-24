output "ssh_public_key" {
  sensitive = true
  value     = tls_private_key.ppdm.public_key_openssh
}

output "ssh_private_key" {
  sensitive = true
  value     = tls_private_key.ppdm.private_key_pem
}

output "public_ip_address" {
  value = length(azurerm_public_ip.publicip) > 0 ? azurerm_public_ip.publicip[0].ip_address : ""
}
output "ppdm_private_ip_address" {
  value = azurerm_network_interface.ppdm_nic.private_ip_address
}
output "public_fqdn" {
  value = length(azurerm_public_ip.publicip) > 0 ? azurerm_public_ip.publicip[0].fqdn : ""
}
output "private_fqdn" {
  sensitive = false
  value     = trimsuffix(azurerm_private_dns_a_record.ppdm_dns.fqdn, ".")

}

output "username" {
  value = azurerm_virtual_machine.ppdm.os_profile
}

output "hostname" {
  value = azurerm_virtual_machine.ppdm.name
}
