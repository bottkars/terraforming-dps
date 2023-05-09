output "nve_private_ip_address" {
  value       = aws_instance.nve.private_ip
  description = "The private ip address of the nve Instance"
}

output "ssh_public_key_name" {
  value       = aws_key_pair.nve.key_name
  description = "The ssh key name for the nve Instance"
}
output "ssh_public_key" {
  sensitive   = true
  value       = tls_private_key.nve.public_key_openssh
  description = "The ssh public key for the nve Instance"
}
output "ssh_private_key" {
  sensitive   = true
  value       = tls_private_key.nve.private_key_pem
  description = "The ssh private key for the nve Instance"
}

output "nve_instance_id" {
  value = "${aws_instance.nve.id}"
}
