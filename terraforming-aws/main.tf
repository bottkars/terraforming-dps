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
  profile                 = "dps"
  region                  = "eu-central-1"
  shared_credentials_file = "/home/bottk/.aws/credentials"

}
locals {
  production_availability_zones = ["${var.region}a", "${var.region}b", "${var.region}c"]
}

module "networks" {
  count                    = var.create_networks ? 1 : 0 // terraform  >=0.13 only
  networks_instance             = count.index
  source                   = "./modules/networks"
  region               = "${var.region}"
  environment          = "${var.environment}"
  vpc_cidr             = "${var.vpc_cidr}"
  public_subnets_cidr  = "${var.public_subnets_cidr}"
  private_subnets_cidr = "${var.private_subnets_cidr}"
  availability_zones   = "${local.production_availability_zones}"

}


module "s2s_vpn" {
  count                    = var.create_s2s_vpn ? 1 : 0 // terraform  >=0.13 only
  source                   = "./modules/s2s_vpn"
  depends_on               = [module.networks]
  vpc_id = "${var.create_networks ? module.networks[0].vpc_id : var.vpc_id }"
  private_route_table = "${var.create_networks ? module.networks[0].private_route_table : var.private_route_table }"
  wan_ip                    = var.wan_ip
  environment          = "${var.environment}"
  tunnel1_preshared_key = var.tunnel1_preshared_key
  vpn_destination_cidr_blocks = var.vpn_destination_cidr_blocks
}

module "ave" {
  count                    = var.create_ave ? 1 : 0 // terraform  >=0.13 only
  ave_instance             = count.index
  source                   = "./modules/ave"
  depends_on               = [module.networks]
  environment          = "${var.environment}"
  ave_name            = var.AVE_HOSTNAME
  subnet_id 	       = "${var.create_networks ? module.networks[0].private_subnets_id[0] : var.subnet_id }"
  availability_zone =  "${local.production_availability_zones[0]}"
  vpc_id = "${var.create_networks ? module.networks[0].vpc_id : var.vpc_id }"
  ingress_cidr_blocks = var.ingress_cidr_blocks
}


module "ddve" {
  count                    = var.create_ddve ? 1 : 0 // terraform  >=0.13 only
  ddve_instance            = count.index
  source                   = "./modules/ddve"
  environment          = "${var.environment}"
  depends_on               = [module.networks]
  ddve_name                = var.DDVE_HOSTNAME
  subnet_id 	          = "${var.create_networks ? module.networks[0].private_subnets_id[0] : var.subnet_id }"
  availability_zone     =  "${local.production_availability_zones[0]}"
  vpc_id = "${var.create_networks ? module.networks[0].vpc_id : var.vpc_id }"
  ingress_cidr_blocks = var.ingress_cidr_blocks

}
