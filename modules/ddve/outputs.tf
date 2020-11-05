output "ddve_ssh_public_key" {
  sensitive = true
  value     = tls_private_key.ddve.public_key_openssh
}

output "ddve_ssh_private_key" {
  sensitive = true
  value     = tls_private_key.ddve.private_key_pem
}


output "ddve_fqdn" {
  sensitive = false
  value     = azurerm_private_dns_a_record.ddve_dns[0].fqdn
}

