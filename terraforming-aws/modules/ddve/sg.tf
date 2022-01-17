
variable "ingress_cidr_blocks" {
  type = list
  default = [""]
}
resource "aws_security_group" "ddve_sg" {
  name = "ddve_sg"
  vpc_id = var.vpc_id #"${aws_vpc.my_vpc.id}"
 
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = var.ingress_cidr_blocks
    
  }
   ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = var.ingress_cidr_blocks
  }
  ingress {
    from_port = 3009
    to_port = 3009
    protocol = "tcp"
    cidr_blocks = var.ingress_cidr_blocks
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [
      "0.0.0.0/0"]
  }
} 
/* */