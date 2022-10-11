resource "aws_security_group" "ddve_sg" {
  name   = "ddve_sg-${var.ddve_instance}"
  vpc_id = var.vpc_id
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
    from_port   = 2051
    to_port     = 2051
    protocol    = "tcp"
    cidr_blocks = var.ingress_cidr_blocks
  }
  ingress {
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    cidr_blocks = var.ingress_cidr_blocks
  }
  ingress {
    from_port   = 3009
    to_port     = 3009
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
