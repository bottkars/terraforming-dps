output "ave_ssh_public_key" {
  sensitive = true
  value     = "${tls_private_key.ave.public_key_openssh}"
}

output "ave_ssh_private_key" {
  sensitive = true
  value     = "${tls_private_key.ave.private_key_pem}"
}