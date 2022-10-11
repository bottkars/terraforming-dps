resource "aws_key_pair" "bastion" {
  key_name   = "${var.environment}-bastion-key"
  public_key = tls_private_key.bastion.public_key_openssh
}

resource "tls_private_key" "bastion" {
  algorithm = "RSA"
  rsa_bits  = "4096"
}
