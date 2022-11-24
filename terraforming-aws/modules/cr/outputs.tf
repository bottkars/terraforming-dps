output "ddcr_ssh_public_key" {
  sensitive = true
  value     = tls_private_key.ddcr.public_key_openssh
}
output "ddcr_ssh_private_key" {
  sensitive = true
  value     = tls_private_key.ddcr.private_key_pem
}

output "ppcr_ssh_public_key" {
  sensitive = true
  value     = tls_private_key.ppcr.public_key_openssh
}
output "ppcr_ssh_private_key" {
  sensitive = true
  value     = tls_private_key.ppcr.private_key_pem
}
output "crjump_ssh_public_key" {
  sensitive = true
  value     = tls_private_key.crjump.public_key_openssh
}
output "crjump_ssh_private_key" {
  sensitive = true
  value     = tls_private_key.crjump.private_key_pem
}
