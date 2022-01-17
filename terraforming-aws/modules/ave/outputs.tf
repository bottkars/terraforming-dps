output "ave_private_ip_address" {
  value = "${aws_instance.ave.private_ip}"
}

output "ssh_public_key_name" {
  value = aws_key_pair.ave.key_name
}
output "ssh_public_key" {
  sensitive = true
  value     = tls_private_key.ave.public_key_openssh
}
output "ssh_private_key" {
  sensitive = true
  value     = tls_private_key.ave.private_key_pem
}