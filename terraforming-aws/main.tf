terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.34.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 3.1"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.1"
    }
  }
  required_version = ">= 0.14.9"
}

provider "aws" {
  profile                  = var.aws_profile
  region                   = "eu-central-1"
  shared_credentials_files = ["/home/bottk/.aws/credentials"]

}

locals {
  production_availability_zones = ["${var.region}a", "${var.region}b", "${var.region}c"]
}

module "networks" {
  count                = var.create_networks ? 1 : 0 // terraform  >=0.13 only
  networks_instance    = count.index
  source               = "./modules/networks"
  region               = var.region
  environment          = var.environment
  vpc_cidr             = var.vpc_cidr
  public_subnets_cidr  = var.public_subnets_cidr
  private_subnets_cidr = var.private_subnets_cidr
  availability_zones   = local.production_availability_zones
  tags                 = var.tags
}


module "s2s_vpn" {
  count                       = var.create_s2s_vpn ? 1 : 0 // terraform  >=0.13 only
  source                      = "./modules/s2s_vpn"
  depends_on                  = [module.networks]
  vpc_id                      = var.create_networks ? module.networks[0].vpc_id : var.vpc_id
  private_route_table         = var.create_networks ? module.networks[0].private_route_table : var.private_route_table
  wan_ip                      = var.wan_ip
  environment                 = var.environment
  tunnel1_preshared_key       = var.tunnel1_preshared_key
  vpn_destination_cidr_blocks = var.vpn_destination_cidr_blocks
  tags                        = var.tags
}

module "ave" {

  count               = var.create_ave ? 1 : 0 // terraform  >=0.13 only
  ave_instance        = count.index
  source              = "./modules/ave"
  depends_on          = [module.networks]
  environment         = var.environment
  ave_name            = var.AVE_HOSTNAME
  default_sg_id       = var.create_networks ? module.networks[0].default_sg_id : var.default_sg_id
  subnet_id           = var.create_networks ? module.networks[0].private_subnets_id[0] : var.subnet_id
  availability_zone   = local.production_availability_zones[0]
  vpc_id              = var.create_networks ? module.networks[0].vpc_id : var.vpc_id
  ingress_cidr_blocks = var.ingress_cidr_blocks
  public_subnets_cidr = var.public_subnets_cidr
  tags                = var.tags
  ave_type            = var.ave_type
}


module "ddve" {
  count               = var.ddve_count > 0 ? var.ddve_count : 0
  ddve_instance       = count.index + 1
  source              = "./modules/ddve"
  environment         = var.environment
  depends_on          = [module.networks]
  ddve_name           = var.DDVE_HOSTNAME
  ddve_version        = var.ddve_version
  default_sg_id       = var.create_networks ? module.networks[0].default_sg_id : var.default_sg_id
  subnet_id           = var.create_networks ? module.networks[0].private_subnets_id[0] : var.subnet_id
  availability_zone   = local.production_availability_zones[0]
  vpc_id              = var.create_networks ? module.networks[0].vpc_id : var.vpc_id
  ingress_cidr_blocks = var.ingress_cidr_blocks
  public_subnets_cidr = var.public_subnets_cidr
  region              = var.region
  tags                = var.tags
  ddve_type           = var.ddve_type
}

module "ppdm" {
  count               = var.ppdm_count > 0 ? var.ppdm_count : 0
  ppdm_instance       = count.index + 1
  source              = "./modules/ppdm"
  environment         = var.environment
  depends_on          = [module.networks]
  ppdm_name           = var.PPDM_HOSTNAME
  default_sg_id       = var.create_networks ? module.networks[0].default_sg_id : var.default_sg_id
  subnet_id           = var.create_networks ? module.networks[0].private_subnets_id[0] : var.subnet_id
  availability_zone   = local.production_availability_zones[0]
  vpc_id              = var.create_networks ? module.networks[0].vpc_id : var.vpc_id
  ingress_cidr_blocks = var.ingress_cidr_blocks
  public_subnets_cidr = var.public_subnets_cidr
  region              = var.region
  tags                = var.tags
}

module "bastion" {
  count             = var.create_bastion ? 1 : 0 // terraform  >=0.13 only
  bastion_instance  = count.index
  source            = "./modules/bastion"
  environment       = var.environment
  depends_on        = [module.networks]
  bastion_name      = var.BASTION_HOSTNAME
  default_sg_id     = var.create_networks ? module.networks[0].default_sg_id : var.default_sg_id
  subnet_id         = var.create_networks ? module.networks[0].public_subnets_id[0] : var.subnet_id
  availability_zone = local.production_availability_zones[0]
  vpc_id            = var.create_networks ? module.networks[0].vpc_id : var.vpc_id
  region            = var.region
  tags              = var.tags
  wan_ip            = var.wan_ip

}

module "cr" {
  count        = var.create_vault ? 1 : 0 // terraform  >=0.13 only
  crs_instance = count.index
  source       = "./modules/cr"
  environment  = var.environment
  depends_on   = [module.networks]
}

module "crs_s2s_vpn" {
  count                       = var.create_crs_s2s_vpn ? 1 : 0 // terraform  >=0.13 only
  source                      = "./modules/s2s_vpn"
  depends_on                  = [module.networks]
  vpc_id                      = var.crs_vpc_id
  private_route_table         = var.crs_private_route_table
  wan_ip                      = var.wan_ip
  environment                 = "crs_${var.environment}"
  tunnel1_preshared_key       = var.crs_tunnel1_preshared_key
  vpn_destination_cidr_blocks = var.crs_vpn_destination_cidr_blocks
  tags                        = var.tags
  bgp_asn                     = 65001
  amazon_side_asn             = 64512
}
