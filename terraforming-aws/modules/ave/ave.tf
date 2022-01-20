data "aws_ami" "ave" {
  most_recent = true
  filter {
    name   = "name"
    values = ["import-ami-0b5710f9c8af3d020-37516d3c-ca11-41f0-9361-8537716e21d9"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["679593333241"]
}

resource "aws_instance" "ave" {
  ami           = data.aws_ami.ave.id
  instance_type = "m4.xlarge"
  vpc_security_group_ids = ["${aws_security_group.allow_ave.id}",var.default_sg_id ]
  associate_public_ip_address = false
  subnet_id     = var.subnet_id
  key_name      = "${aws_key_pair.ave.key_name}"
  tags = {
    Name = var.ave_name
  }
}



resource "aws_ebs_volume" "ebs_volume" {
  count             = "${var.ave_data_volume_count}"
  availability_zone = var.availability_zone
  size              = "500"
}

resource "aws_volume_attachment" "volume_attachement" {
  count       = "${var.ave_data_volume_count}"
  volume_id   = "${aws_ebs_volume.ebs_volume.*.id[count.index]}"
  device_name = "${element(var.ec2_device_names, count.index)}"
  instance_id = aws_instance.ave.id
  stop_instance_before_detaching = true
  }
