output "ssh_public_key" {
  sensitive = true
  value     = tls_private_key.ppdm.public_key_openssh
}
output "ssh_private_key" {
  sensitive = true
  value     = tls_private_key.ppdm.private_key_pem
}
output "private_ip" {
    value = google_compute_instance.ppdm.network_interface[0].network_ip
}

