resource "aws_security_group" "bastion_sg" {
  name   = "bastion_sg"
  vpc_id = var.vpc_id

  ingress {
    from_port   = 3389
    to_port     = 3389
    protocol    = "tcp"
    cidr_blocks = ["${var.wan_ip}/32"]
    description = "Allow incoming RDP connections"
  }
      
  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = [
    "0.0.0.0/0"]
  }
    tags = {
    Name = "bastion-sg"
  }
}
/* */
