output "ddve_private_ip_address" {
  value = "${aws_instance.ddve.private_ip}"
}


output "ddve_instance_id" {
  value = "${aws_instance.ddve.id}"
}
output "ssh_public_key_name" {
  value = aws_key_pair.ddve.key_name
}
output "ssh_public_key" {
  sensitive = true
  value     = tls_private_key.ddve.public_key_openssh
}
output "ssh_private_key" {
  sensitive = true
  value     = tls_private_key.ddve.private_key_pem
}

output "atos_bucket" {
  sensitive = true
  value     = aws_s3_bucket.atos-bucket.bucket
}