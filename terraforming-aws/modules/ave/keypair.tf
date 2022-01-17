resource "aws_key_pair" "ave" {
  key_name   = "${var.environment}-ave-key"
  public_key = "${tls_private_key.ave.public_key_openssh}"
}

resource "tls_private_key" "ave" {
  algorithm = "RSA"
  rsa_bits  = "4096"
}