terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }
  required_version = ">= 0.14.9"
}

provider "aws" {
  profile                 = "default"
  region                  = "eu-central-1"
  shared_credentials_file = "/home/bottk/.aws/credentials"

}


module "ave" {
  count                    = var.create_ddve ? 1 : 0 // terraform  >=0.13 only
  ave_instance             = count.index
  source                   = "./modules/ave"
#  depends_on               = [module.infra]
  ave_name            = var.AVE_HOSTNAME
  subnet_id 	       = var.SUBNET_ID
  availability_zone =  var.AVAILABILITY_ZONE
}


module "ddve" {
  count                    = var.create_ddve ? 1 : 0 // terraform  >=0.13 only
  ddve_instance            = count.index
  source                   = "./modules/ddve"
#  depends_on               = [module.infra]
  ddve_name            = var.DDVE_HOSTNAME
  subnet_id 	       = var.SUBNET_ID
  availability_zone =  var.AVAILABILITY_ZONE

}
