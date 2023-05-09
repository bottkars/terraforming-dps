locals {
  tcp_inbound_rules =  [22, 8080, 443, 9090, 7543]
}
resource "aws_security_group" "allow_nve" {
  name   = "allow_nve"
  vpc_id = var.vpc_id

  dynamic "ingress" {
    for_each = local.tcp_inbound_rules
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = var.ingress_cidr_blocks
    }
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = concat(var.ingress_cidr_blocks, var.public_subnets_cidr)

  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = concat(var.ingress_cidr_blocks, var.public_subnets_cidr)
  }
    ingress {
    from_port   = 9000
    to_port     = 9001
    protocol    = "tcp"
    cidr_blocks = concat(var.ingress_cidr_blocks, var.public_subnets_cidr)
  }
  ingress {
    from_port   = 7937
    to_port     = 7954
    protocol    = "tcp"
    cidr_blocks = var.ingress_cidr_blocks
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
