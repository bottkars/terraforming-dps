output "ppdm_ssh_public_key" {
  sensitive = true
  value     = tls_private_key.ppdm.public_key_openssh
}

output "ppdm_ssh_private_key" {
  sensitive = true
  value     = tls_private_key.ppdm.private_key_pem
}

output "public_ip_address" {
  value = length(azurerm_public_ip.publicip) > 0 ? azurerm_public_ip.publicip[0].ip_address : ""
}

output "username" {
  value = azurerm_virtual_machine.ppdm.os_profile
}