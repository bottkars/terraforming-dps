output "ssh_public_key" {
  sensitive = true
  value     = tls_private_key.nve.public_key_openssh
}
output "ssh_private_key" {
  sensitive = true
  value     = tls_private_key.nve.private_key_pem
}
output "nve_private_ip" {
    value = google_compute_instance.nve.network_interface[0].network_ip
}

output "nve_instance_id" {
    value = google_compute_instance.nve.instance_id
}
