
variable "ingress_cidr_blocks" {
  type = list
  default = [""]
}
variable "ave_tcp_inbound_rules" {
    default =  [22,161,163,443,7543,700,8543,9090,9443,2700,29000]
}
resource "aws_security_group" "allow_ave" {
  name = "allow_ave"
  vpc_id = var.vpc_id #"${aws_vpc.my_vpc.id}"

  dynamic "ingress" {
    for_each = var.ave_tcp_inbound_rules
    content { 
      from_port = ingress.value
      to_port = ingress.value
      protocol = "tcp"
      cidr_blocks = var.ingress_cidr_blocks
    }
  }
  ingress {
    from_port = 28001
    to_port = 28002
    protocol = "tcp"
    cidr_blocks = var.ingress_cidr_blocks
  }  
  ingress {
    from_port = 28810
    to_port = 28819
    protocol = "tcp"
    cidr_blocks = var.ingress_cidr_blocks
  }
  ingress {
    from_port = 30001
    to_port = 30010
    protocol = "tcp"
    cidr_blocks = var.ingress_cidr_blocks
  }
  ingress {
    from_port = 7778
    to_port = 7781
    protocol = "tcp"
    cidr_blocks = var.ingress_cidr_blocks
  } 
/*  ingress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [
      "0.0.0.0/0"]
  }*/
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [
      "0.0.0.0/0"]
  }
} 
/* */