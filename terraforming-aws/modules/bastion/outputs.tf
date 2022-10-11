output "bastion_public_ip_address" {
  value = "${aws_instance.bastion.public_ip}"
}


output "bastion_instance_id" {
  value = "${aws_instance.bastion.id}"
}
output "ssh_public_key_name" {
  value = aws_key_pair.bastion.key_name
}
output "ssh_public_key" {
  sensitive = true
  value     = tls_private_key.bastion.public_key_openssh
}
output "ssh_private_key" {
  sensitive = true
  value     = tls_private_key.bastion.private_key_pem
}

