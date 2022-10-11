resource "aws_key_pair" "ddve" {
  key_name   = "${var.environment}-ddve-key-${var.ddve_instance}"
  public_key = tls_private_key.ddve.public_key_openssh
}

resource "tls_private_key" "ddve" {
  algorithm = "RSA"
  rsa_bits  = "4096"
}
