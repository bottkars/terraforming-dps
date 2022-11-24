resource "aws_key_pair" "crjump" {
  key_name   = "${var.environment}-crjump-key"
  public_key = tls_private_key.crjump.public_key_openssh
}

resource "tls_private_key" "crjump" {
  algorithm = "RSA"
  rsa_bits  = "4096"
}


resource "aws_key_pair" "ppcr" {
  key_name   = "${var.environment}-ppcr-key"
  public_key = tls_private_key.ppcr.public_key_openssh
}

resource "tls_private_key" "ppcr" {
  algorithm = "RSA"
  rsa_bits  = "4096"
}


resource "aws_key_pair" "ddcr" {
  key_name   = "${var.environment}-ddcr-key"
  public_key = tls_private_key.ddcr.public_key_openssh
}

resource "tls_private_key" "ddcr" {
  algorithm = "RSA"
  rsa_bits  = "4096"
}



