output "linux_ssh_public_key" {
  sensitive = true
  value     = "${tls_private_key.linux.public_key_openssh}"
}

output "linux_ssh_private_key" {
  sensitive = true
  value     = "${tls_private_key.linux.private_key_pem}"
}