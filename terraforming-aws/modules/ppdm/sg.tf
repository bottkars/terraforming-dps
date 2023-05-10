locals {
  tcp_inbound_rules_bastion = [22, 443, 8443, 14443]
  tcp_inbound_rules         = [22, 7000, 7444, 9009, 8443, 443,14443]
}

resource "aws_security_group" "ppdm_sg" {
  name   = "ppdm_sg-${var.ppdm_instance}"
  vpc_id = var.vpc_id
  dynamic "ingress" {
    for_each = local.tcp_inbound_rules_bastion
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = concat(var.ingress_cidr_blocks, var.public_subnets_cidr)
    }
  }
  dynamic "ingress" {
    for_each = local.tcp_inbound_rules
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = concat(var.ingress_cidr_blocks, var.private_subnets_cidr)
    }
  }
  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = [
    "0.0.0.0/0"]
  }
}
/* */
