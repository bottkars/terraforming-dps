output "ddve_ssh_public_key" {
  sensitive = true
  value     = "${tls_private_key.ddve.public_key_openssh}"
}

output "ddve_ssh_private_key" {
  sensitive = true
  value     = "${tls_private_key.ddve.private_key_pem}"
}