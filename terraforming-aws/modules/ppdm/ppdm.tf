locals {
  ppdm_name          = "${var.ppdm_name}-${var.ppdm_instance}"    
  }

data "aws_ami" "ppdm" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ppdm-ami-${var.ppdm_version}-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["679593333241"]
}

resource "aws_instance" "ppdm" {
  ami                         = data.aws_ami.ppdm.id
  instance_type               = "m5.2xlarge"
  vpc_security_group_ids      = ["${aws_security_group.ppdm_sg.id}", var.default_sg_id]
  associate_public_ip_address = false
  subnet_id                   = var.subnet_id
  key_name                    = aws_key_pair.ppdm.key_name
  tags = merge(
    var.tags,
    { "Name" = local.ppdm_name
    "environment" = var.environment },
  )
}
