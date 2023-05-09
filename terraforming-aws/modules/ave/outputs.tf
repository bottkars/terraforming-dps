output "ave_private_ip_address" {
  value       = aws_instance.ave.private_ip
  description = "The private ip address of the AVE Instance"
}

output "ssh_public_key_name" {
  value       = aws_key_pair.ave.key_name
  description = "The ssh key name for the AVE Instance"
}
output "ssh_public_key" {
  sensitive   = true
  value       = tls_private_key.ave.public_key_openssh
  description = "The ssh public key for the AVE Instance"
}
output "ssh_private_key" {
  sensitive   = true
  value       = tls_private_key.ave.private_key_pem
  description = "The ssh private key for the AVE Instance"
}

output "ave_instance_id" {
  value = "${aws_instance.ave.id}"
}
