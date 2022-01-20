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
  ami                         = data.aws_ami.ddve.id
  instance_type               = "m4.xlarge"
  vpc_security_group_ids      = ["${aws_security_group.ddve_sg.id}", var.default_sg_id]
  associate_public_ip_address = false
  subnet_id                   = var.subnet_id
  key_name                    = aws_key_pair.ddve.key_name
  iam_instance_profile        = aws_iam_instance_profile.atos-bucket.name
  tags = merge(
    var.tags,
    { "Name" = var.ddve_name
    "environment" = var.environment },
  )
}

resource "aws_ebs_volume" "nvram" {
  type              = "gp2"
  size              = 10
  availability_zone = var.availability_zone
  tags = merge(
    var.tags,
    { Name = "${var.ddve_name}-nvram-volume"
    environment = var.environment },
  )

}

resource "aws_ebs_volume" "metadata_volume" {
  count             = var.ddve_metadata_volume_count
  availability_zone = var.availability_zone
  size              = "1024"
  tags = merge(
    var.tags,
    {
      Name        = "${var.ddve_name}-metadata-vol-${count.index}"
      Environment = "${var.environment}"
    }
  )  
}

resource "aws_volume_attachment" "volume_attachement" {
  count                          = var.ddve_metadata_volume_count
  volume_id                      = aws_ebs_volume.metadata_volume.*.id[count.index]
  device_name                    = element(var.ec2_device_names, count.index)
  instance_id                    = aws_instance.ddve.id
  stop_instance_before_detaching = true
}



resource "aws_volume_attachment" "ebs_att_nvram" {
  device_name                    = "/dev/sdb"
  volume_id                      = aws_ebs_volume.nvram.id
  instance_id                    = aws_instance.ddve.id
  stop_instance_before_detaching = true
}

