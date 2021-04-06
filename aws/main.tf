provider "aws" {
  version = "~> 3.0"
  region  = "eu-central-1"
}


resource "aws_vpc" "Default" {
	cidr_block  = "172.31.0.0/16"
}

