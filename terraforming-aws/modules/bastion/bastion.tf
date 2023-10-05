data "aws_ami" "bastion" {
  most_recent = true
  filter {
    name   = "name"
    values = ["Windows_Server-2022-English-Full-Base*"]

  }
  owners = ["amazon"]
}

resource "aws_instance" "bastion" {
  ami                         = data.aws_ami.bastion.id
  instance_type               = "c4.xlarge"
  vpc_security_group_ids      = ["${aws_security_group.bastion_sg.id}", var.default_sg_id]
  associate_public_ip_address = false
  subnet_id                   = var.subnet_id
  key_name                    = aws_key_pair.bastion.key_name
  get_password_data           = true
  tags = merge(
    var.tags,
    { "Name" = var.bastion_name
    "environment" = var.environment },
  )
}
