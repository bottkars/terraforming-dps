resource "aws_key_pair" "ddmc" {
  key_name   = "${var.environment}-ddmc-key-${var.ddmc_instance}"
  public_key = tls_private_key.ddmc.public_key_openssh
}

resource "tls_private_key" "ddmc" {
  algorithm = "RSA"
  rsa_bits  = "4096"
}
