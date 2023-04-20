output "ssh_public_key" {
  sensitive = true
  value     = tls_private_key.ddve.public_key_openssh
}
output "ssh_private_key" {
  sensitive = true
  value     = tls_private_key.ddve.private_key_pem
}
output "ddve_private_ip_address" {
    value = google_compute_instance.ddve.network_interface[0].network_ip
}
output "ddve_instance_id" {
    value = google_compute_instance.ddve.instance_id
}
output "atos_bucket" {
  sensitive = true
  value     = google_storage_bucket.ddve-bucket.name
}

