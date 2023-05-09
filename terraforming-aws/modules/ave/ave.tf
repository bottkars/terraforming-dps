locals {
  ave_size = {
    "0.5 TB AVE" = {
      ave_data_volume_count = 3
      ave_disksize          = 250
      instance_type         = "m5.large"
    }
    "1 TB AVE" = {
      ave_data_volume_count = 6
      ave_disksize          = 250
      instance_type         = "m5.large"
    }
    "2 TB AVE" = {
      ave_data_volume_count = 3
      ave_disksize          = 1000
      instance_type         = "m5.xlarge"
    }
    "4 TB AVE" = {
      ave_data_volume_count = 6
      ave_disksize          = 1000
      instance_type         = "m5.2xlarge"
    }
    "4 TB AVE" = {
      ave_data_volume_count = 12
      ave_disksize          = 1000
      instance_type         = "r5.2xlarge"
    }
    "16 TB AVE" = {
      ave_data_volume_count = 12
      ave_disksize          = 2000
      instance_type         = "r5.4xlarge"
    }
  }
  ave_name = "${var.ave_name}-${var.ave_instance}"

}
data "aws_ami" "ave" {
  most_recent = true
  filter {
    name   = "product-code"
    values = ["39wcpm1kbvedt019kmd2u3r2x"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }


  owners = ["679593333241"]
}

resource "aws_instance" "ave" {
  ami                         = data.aws_ami.ave.id
  instance_type               = local.ave_size[var.ave_type].instance_type
  vpc_security_group_ids      = ["${aws_security_group.allow_ave.id}", var.default_sg_id]
  associate_public_ip_address = false
  subnet_id                   = var.subnet_id
  key_name                    = aws_key_pair.ave.key_name
  tags = merge(
    var.tags,
    {
      Environment = "${var.environment}"
      Name        = local.ave_name
    }
  )
    lifecycle {
        prevent_destroy = true
        ignore_changes = [tags,tags_all,ami]
    }   
}



resource "aws_ebs_volume" "ebs_volume" {
  count             = local.ave_size[var.ave_type].ave_data_volume_count
  availability_zone = var.availability_zone
  size              = local.ave_size[var.ave_type].ave_disksize
  tags = merge(
    var.tags,
    {
      Name        = "${local.ave_name}-data-vol-${count.index}"
      Environment = "${var.environment}"
    }
  )
}

resource "aws_volume_attachment" "volume_attachement" {
  count                          = local.ave_size[var.ave_type].ave_data_volume_count
  volume_id                      = aws_ebs_volume.ebs_volume.*.id[count.index]
  device_name                    = element(var.ec2_device_names, count.index)
  instance_id                    = aws_instance.ave.id
  stop_instance_before_detaching = true
}
