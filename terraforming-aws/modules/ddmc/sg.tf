resource "aws_security_group" "ddmc_sg" {
  count  = var.is_crs ? 0 : 1
  name   = "ddmc_sg-${var.ddmc_instance}"
  vpc_id = var.vpc_id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = concat(var.ingress_cidr_blocks, var.private_subnets_cidr, var.public_subnets_cidr)
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = concat(var.ingress_cidr_blocks, var.private_subnets_cidr, var.public_subnets_cidr)
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = concat(var.ingress_cidr_blocks, var.private_subnets_cidr)
  }
 
  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = [
    "0.0.0.0/0"]
  }
}
