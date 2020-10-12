output "ppdm_ssh_public_key" {
  sensitive = true
  value     = tls_private_key.ppdm.public_key_openssh
}

output "ppdm_ssh_private_key" {
  sensitive = true
  value     = tls_private_key.ppdm.private_key_pem
}