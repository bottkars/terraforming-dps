output "ppdm_private_ip_address" {
  value = "${aws_instance.ppdm.private_ip}"
}


output "ppdm_instance_id" {
  value = "${aws_instance.ppdm.id}"
}
output "ssh_public_key_name" {
  value = aws_key_pair.ppdm.key_name
}
output "ssh_public_key" {
  sensitive = true
  value     = tls_private_key.ppdm.public_key_openssh
}
output "ssh_private_key" {
  sensitive = true
  value     = tls_private_key.ppdm.private_key_pem
}