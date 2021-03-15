output "nve_ssh_public_key" {
  sensitive = true
  value     = "${tls_private_key.nve.public_key_openssh}"
}

output "nve_ssh_private_key" {
  sensitive = true
  value     = "${tls_private_key.nve.private_key_pem}"
}