output "ddmc_private_ip_address" {
  value = "${aws_instance.ddmc.private_ip}"
}


output "ddmc_instance_id" {
  value = "${aws_instance.ddmc.id}"
}
output "ssh_public_key_name" {
  value = aws_key_pair.ddmc.key_name
}
output "ssh_public_key" {
  sensitive = true
  value     = tls_private_key.ddmc.public_key_openssh
}
output "ssh_private_key" {
  sensitive = true
  value     = tls_private_key.ddmc.private_key_pem
}
