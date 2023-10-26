output "ssh_public_key" {
  sensitive = true
  value     = tls_private_key.ubuntu.public_key_openssh
}
output "ssh_private_key" {
  sensitive = true
  value     = tls_private_key.ubuntu.private_key_pem
}
output "ubuntu_private_ip" {
    value = google_compute_instance.ubuntu.network_interface[0].network_ip
}

output "ubuntu_instance_id" {
    value = google_compute_instance.ubuntu.instance_id
}
