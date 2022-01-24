output "ssh_public_key" {
  sensitive = true
  value     = tls_private_key.ddve.public_key_openssh
}

output "ssh_private_key" {
  sensitive = true
  value     = tls_private_key.ddve.private_key_pem
}

output "public_fqdn" {
  value = length(azurerm_public_ip.publicip) > 0 ? azurerm_public_ip.publicip[0].fqdn : ""
}

output "ddve_private_ip_address" {
  value = azurerm_network_interface.ddve_nic.private_ip_address
}
output "public_ip_address" {
  value = length(azurerm_public_ip.publicip) > 0 ? azurerm_public_ip.publicip[0].ip_address : ""
}
output "private_fqdn" {
  sensitive = false
  value     = trimsuffix(azurerm_private_dns_a_record.ddve_dns.fqdn, ".")
}
output "ppdd_nfs_path" {
  sensitive = true
  value     = var.ddve_ppdd_nfs_path
}

