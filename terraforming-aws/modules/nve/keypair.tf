resource "aws_key_pair" "nve" {
  key_name   = "${var.environment}-nve-key-${var.nve_instance}"
  public_key = "${tls_private_key.nve.public_key_openssh}"
}

resource "tls_private_key" "nve" {
  algorithm = "RSA"
  rsa_bits  = "4096"
}