variable "ec2_device_names" {
  default = [
    "/dev/sdd",
    "/dev/sde",
    "/dev/sdf"
  ]
}
variable "ddve_instance" {
  
}
variable "vpc_id" {
  
}
variable "ddve_name" {
    type = string
    default = "ddve_terraform"
  
}
variable "environment" {
  
}
variable "ec2_ebs_volume_count" {
  default = 1
}
variable "availability_zone" {}

variable "subnet_id" {}
/*
data "aws_key_pair" "ddve" {
  key_name = "ddve"
 # filter {
 #   name   = "tag:Component"
 #   values = ["web"]
 # }
}
*/
data "aws_ami" "ddve" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ddve-7.7.0.7-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["679593333241"]
}
 
resource "aws_instance" "ddve" {
  ami           = data.aws_ami.ddve.id
  instance_type = "m4.xlarge"
  vpc_security_group_ids = ["${aws_security_group.ddve_sg.id}"]
  associate_public_ip_address = false
  subnet_id     = var.subnet_id
  key_name      = "${aws_key_pair.ddve.key_name}"
  iam_instance_profile = aws_iam_instance_profile.terraform_profile.name
  tags = {
    Name = var.ddve_name
  }
}
 
resource "aws_ebs_volume" "nvram" {
  type = "gp2"
  size = 10
  availability_zone = var.availability_zone
}

resource "aws_ebs_volume" "metadata_volume" {
  count             = "${var.ec2_ebs_volume_count}"
  availability_zone = var.availability_zone
  size              = "1024"
}

resource "aws_volume_attachment" "volume_attachement" {
  count       = "${var.ec2_ebs_volume_count}"
  volume_id   = "${aws_ebs_volume.metadata_volume.*.id[count.index]}"
  device_name = "${element(var.ec2_device_names, count.index)}"
  instance_id = aws_instance.ddve.id
  stop_instance_before_detaching = true
  }


 
resource "aws_volume_attachment" "ebs_att_nvram" {
  device_name = "/dev/sdb"
  volume_id = aws_ebs_volume.nvram.id
  instance_id = aws_instance.ddve.id
  stop_instance_before_detaching = true
}
 

 
resource "aws_iam_role" "terraform_role" {
  name = "ddve_terraform_role"
  assume_role_policy = file("assumerolepolicy.json")
}
 
resource "aws_iam_instance_profile" "terraform_profile" {
  name = "ddve_terraform_profile"
  role = aws_iam_role.terraform_role.name
}
 
resource "aws_iam_role_policy" "terraform_policy" {
  name = "ddve_terraform_policy"
  role = aws_iam_role.terraform_role.id
  policy = file("policys3bucket.json")
}
 