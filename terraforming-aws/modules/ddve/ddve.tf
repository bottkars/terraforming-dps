locals { 
    ddve_size = {
      "16 TB DDVE" = {
        ddve_metadata_volume_count = 2
        ddve_disksize = 1000
        instance_type = "m5.xlarge"
      }
      "32 TB DDVE" = {
        ddve_metadata_volume_count = 4
        ddve_disksize = 1000
        instance_type = "m5.2xlarge"
      }
      "96 TB DDVE" = {
        ddve_metadata_volume_count = 10
        ddve_disksize = 1000
        instance_type = "m5.4xlarge"
      } 
      "256 TB DDVE" = {
        ddve_metadata_volume_count = 13
        ddve_disksize = 2000
        instance_type = "m5.8xlarge"
      } 
                             
    }
    
  }
data "aws_ami" "ddve" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ddve-7.7.*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["679593333241"]
}

resource "aws_instance" "ddve" {
  ami                         = data.aws_ami.ddve.id
  instance_type               = local.ddve_size[var.ddve_type].instance_type
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
  count             = local.ddve_size[var.ddve_type].ddve_metadata_volume_count
  availability_zone = var.availability_zone
  size              = local.ddve_size[var.ddve_type].ddve_disksize
  tags = merge(
    var.tags,
    {
      Name        = "${var.ddve_name}-metadata-vol-${count.index}"
      Environment = "${var.environment}"
    }
  )  
}

resource "aws_volume_attachment" "volume_attachement" {
  count                          = local.ddve_size[var.ddve_type].ddve_metadata_volume_count
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

