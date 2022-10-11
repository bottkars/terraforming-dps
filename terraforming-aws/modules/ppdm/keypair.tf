resource "aws_key_pair" "ppdm" {
  key_name   = "${var.environment}-ppdm-key-${var.ppdm_instance}"
  public_key = tls_private_key.ppdm.public_key_openssh
}

resource "tls_private_key" "ppdm" {
  algorithm = "RSA"
  rsa_bits  = "4096"
}
