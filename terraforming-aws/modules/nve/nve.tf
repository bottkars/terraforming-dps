locals {
  nve_size = {
    "small" = {
      nve_data_volume_count = 1
      nve_disksize          = 600
      instance_type         = "m5.xlarge"
    }
    "medium" = {
      nve_data_volume_count = 1
      nve_disksize          = 1200
      instance_type         = "m5.xlarge"
    }
    "large" = {
      nve_data_volume_count = 1
      nve_disksize          = 2400
      instance_type         = "m5.2xlarge"
    }
  }
  nve_name = "${var.nve_name}-${var.nve_instance}"

}
data "aws_ami" "nve" {
  most_recent = true
  filter {
    name   = "product-code"
    values = ["ds0r6ix3vy3n0lhovg05upqtf"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }


  owners = ["679593333241"]
}

resource "aws_instance" "nve" {
  ami                         = data.aws_ami.nve.id
  instance_type               = local.nve_size[var.nve_type].instance_type
  vpc_security_group_ids      = ["${aws_security_group.allow_nve.id}", var.default_sg_id]
  associate_public_ip_address = false
  subnet_id                   = var.subnet_id
  key_name                    = aws_key_pair.nve.key_name
  tags = merge(
    var.tags,
    {
      Environment = "${var.environment}"
      Name        = local.nve_name
    }
  )
    lifecycle {
        prevent_destroy = false
        ignore_changes = [tags,tags_all,ami]
    }   
}



resource "aws_ebs_volume" "ebs_volume" {
  count             = local.nve_size[var.nve_type].nve_data_volume_count
  availability_zone = var.availability_zone
  size              = local.nve_size[var.nve_type].nve_disksize
  tags = merge(
    var.tags,
    {
      Name        = "${local.nve_name}-data-vol-${count.index}"
      Environment = "${var.environment}"
    }
  )
}

resource "aws_volume_attachment" "volume_attachement" {
  count                          = local.nve_size[var.nve_type].nve_data_volume_count
  volume_id                      = aws_ebs_volume.ebs_volume.*.id[count.index]
  device_name                    = element(var.ec2_device_names, count.index)
  instance_id                    = aws_instance.nve.id
  stop_instance_before_detaching = true
}
