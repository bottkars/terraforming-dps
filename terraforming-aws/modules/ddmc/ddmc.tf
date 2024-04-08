locals {
  ddmc_size = {
    "10 Gigabit Ethernet ddmc" = {
      ddmc_metadata_volume_count = 2
      instance_type              = "m5.xlarge"
    }
    "12.5 Gigabit Ethernet ddmc" = {
      ddmc_metadata_volume_count = 4
      instance_type              = "m6i.xlarge"
    }


  }
  ddmc_name = "${var.ddmc_name}-${var.ddmc_instance}"
}

data "aws_ami" "ddmc" {
  most_recent = true
  include_deprecated = true
  filter {
    name   = "name"
    values = ["ddmc-${var.ddmc_version}*"]
    
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["679593333241"]
}

resource "aws_instance" "ddmc" {
  ami                         = data.aws_ami.ddmc.id
  instance_type               = local.ddmc_size[var.ddmc_type].instance_type
  vpc_security_group_ids      = ["${aws_security_group.ddmc_sg[0].id}", var.default_sg_id]
  associate_public_ip_address = false
  subnet_id                   = var.subnet_id
  key_name                    = aws_key_pair.ddmc.key_name
  tags = merge(
    var.tags,
    { "Name" = local.ddmc_name
    "environment" = var.environment },
  )
  root_block_device {
    delete_on_termination = true
  }
    lifecycle {
   #     prevent_destroy = true
        ignore_changes = [tags,tags_all,ami]
    }  
}

resource "aws_ebs_volume" "dbvolume" {
  type              = "gp2"
  size              = 200
  availability_zone = var.availability_zone
  tags = merge(
    var.tags,
    { Name           = "${var.ddmc_name}-dbvolume"
      environment    = var.environment
      OwningInstance = local.ddmc_name
    },
  )

}


resource "aws_volume_attachment" "ebs_att_dbvolume" {
  device_name                    = "/dev/sdb"
  volume_id                      = aws_ebs_volume.dbvolume.id
  instance_id                    = aws_instance.ddmc.id
  stop_instance_before_detaching = true
  skip_destroy                   = true
}

resource "aws_ebs_volume" "resvolume" {
  type              = "gp2"
  size              = 100
  availability_zone = var.availability_zone
  tags = merge(
    var.tags,
    { Name           = "${var.ddmc_name}-resvolume"
      environment    = var.environment
      OwningInstance = local.ddmc_name
    },
  )

}


resource "aws_volume_attachment" "ebs_att_resvolume" {
  device_name                    = "/dev/sdc"
  volume_id                      = aws_ebs_volume.resvolume.id
  instance_id                    = aws_instance.ddmc.id
  stop_instance_before_detaching = true
  skip_destroy                   = true
}
