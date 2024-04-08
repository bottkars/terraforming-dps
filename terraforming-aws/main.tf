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
  #  default_tags {
  #    tags = var.tags_all
  #  }
}

locals {
  production_availability_zones = ["${var.region}a", "${var.region}b", "${var.region}c"]
}

module "networks" {
  vpc_name             = "${var.environment}-vpc"
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

  count               = var.ave_count > 0 ? var.ave_count : 0
  ave_instance        = count.index + 1
  source              = "./modules/ave"
  depends_on          = [module.networks]
  environment         = var.environment
  ave_name            = var.AVE_HOSTNAME
  default_sg_id       = var.create_networks ? module.networks[0].default_sg_id : var.default_sg_id
  subnet_id           = var.create_networks ? module.networks[0].private_subnets_id[0] : var.subnet_id[0]
  availability_zone   = local.production_availability_zones[0]
  vpc_id              = var.create_networks ? module.networks[0].vpc_id : var.vpc_id
  ingress_cidr_blocks = var.ingress_cidr_blocks
  public_subnets_cidr = var.public_subnets_cidr
  tags                = var.tags
  ave_type            = var.ave_type
}


module "ddve" {
  count                = var.ddve_count > 0 ? var.ddve_count : 0
  ddve_instance        = count.index + 1
  source               = "./modules/ddve"
  environment          = var.environment
  depends_on           = [module.networks]
  ddve_name            = var.DDVE_HOSTNAME
  ddve_version         = var.ddve_version
  default_sg_id        = var.create_networks ? module.networks[0].default_sg_id : var.default_sg_id
  subnet_id            = var.create_networks ? module.networks[0].private_subnets_id[0] : var.subnet_id[0]
  availability_zone    = local.production_availability_zones[0]
  vpc_id               = var.create_networks ? module.networks[0].vpc_id : var.vpc_id
  ingress_cidr_blocks  = var.ingress_cidr_blocks
  public_subnets_cidr  = var.public_subnets_cidr
  private_subnets_cidr = var.private_subnets_cidr
  region               = var.region
  tags                 = var.tags
  ddve_type            = var.ddve_type
}

module "ddmc" {
  count                = var.ddmc_count > 0 ? var.ddmc_count : 0
  ddmc_instance        = count.index + 1
  source               = "./modules/ddmc"
  environment          = var.environment
  depends_on           = [module.networks]
  ddmc_name            = var.DDMC_HOSTNAME
  ddmc_version         = var.ddmc_version
  default_sg_id        = var.create_networks ? module.networks[0].default_sg_id : var.default_sg_id
  subnet_id            = var.create_networks ? module.networks[0].private_subnets_id[0] : var.subnet_id[0]
  availability_zone    = local.production_availability_zones[0]
  vpc_id               = var.create_networks ? module.networks[0].vpc_id : var.vpc_id
  ingress_cidr_blocks  = var.ingress_cidr_blocks
  public_subnets_cidr  = var.public_subnets_cidr
  private_subnets_cidr = var.private_subnets_cidr
  region               = var.region
  tags                 = var.tags
  ddmc_type            = var.ddmc_type
}

module "nve" {
  count                = var.nve_count > 0 ? var.nve_count : 0
  nve_instance         = count.index + 1
  source               = "./modules/nve"
  environment          = var.environment
  depends_on           = [module.networks]
  nve_name             = var.NVE_HOSTNAME
  default_sg_id        = var.create_networks ? module.networks[0].default_sg_id : var.default_sg_id
  subnet_id            = var.create_networks ? module.networks[0].private_subnets_id[0] : var.subnet_id[0]
  availability_zone    = local.production_availability_zones[0]
  vpc_id               = var.create_networks ? module.networks[0].vpc_id : var.vpc_id
  ingress_cidr_blocks  = var.ingress_cidr_blocks
  public_subnets_cidr  = var.public_subnets_cidr
  private_subnets_cidr = var.private_subnets_cidr
  tags                 = var.tags
  nve_type             = var.nve_type
  nve_version          = var.nve_version
}

module "vault_nve" {
  count                = var.vault_nve_count > 0 ? var.vault_nve_count : 0
  nve_instance         = count.index + 1
  source               = "./modules/nve"
  environment          = var.environment
  nve_name             = var.NVE_HOSTNAME
  depends_on           = [module.crs_networks]
  default_sg_id        = var.create_crs_networks ? module.crs_networks[0].vault_sg_id : var.vault_sg_id
  subnet_id            = var.create_crs_networks ? module.crs_networks[0].private_subnets_id[1] : var.crs_vault_subnet_id
  availability_zone    = local.production_availability_zones[0]
  vpc_id               = var.create_crs_networks ? module.crs_networks[0].crs_vpc_id : var.crs_vpc_id
  ingress_cidr_blocks  = var.vault_ingress_cidr_blocks
  public_subnets_cidr  = []
  private_subnets_cidr = var.crs_private_subnets_cidr
  tags                 = var.tags
  nve_type             = var.nve_type
  nve_version          = var.nve_version
}


module "vault_ppdm" {
  count                = var.vault_ppdm_count > 0 ? var.vault_ppdm_count : 0
  ppdm_instance        = count.index + 1
  source               = "./modules/ppdm"
  environment          = var.environment
  ppdm_name            = var.PPDM_HOSTNAME
  ppdm_version         = var.ppdm_version
  depends_on           = [module.crs_networks]
  default_sg_id        = var.create_crs_networks ? module.crs_networks[0].vault_sg_id : var.vault_sg_id
  subnet_id            = var.create_crs_networks ? module.crs_networks[0].private_subnets_id[1] : var.crs_vault_subnet_id
  availability_zone    = local.production_availability_zones[0]
  vpc_id               = var.create_crs_networks ? module.crs_networks[0].crs_vpc_id : var.crs_vpc_id
  ingress_cidr_blocks  = var.vault_ingress_cidr_blocks
  public_subnets_cidr  = []
  private_subnets_cidr = var.crs_private_subnets_cidr
  region               = var.region
  tags                 = var.tags
}


module "eks" {
  count               = var.eks_count > 0 ? var.eks_count : 0
  eks_instance        = count.index + 1
  source              = "./modules/eks"
  environment         = var.environment
  depends_on          = [module.networks]
  eks_cluster_name    = var.eks_cluster_name
  default_sg_id       = var.create_networks ? module.networks[0].default_sg_id : var.default_sg_id
  subnet_id           = var.create_networks ? module.networks[0].private_subnets_id[*] : var.subnet_id[*]
  availability_zone   = local.production_availability_zones[0]
  vpc_id              = var.create_networks ? module.networks[0].vpc_id : var.vpc_id
  ingress_cidr_blocks = var.ingress_cidr_blocks
  public_subnets_cidr = var.public_subnets_cidr
  region              = var.region
  tags                = var.tags
}

module "ppdm" {
  count                = var.ppdm_count > 0 ? var.ppdm_count : 0
  ppdm_instance        = count.index + 1
  source               = "./modules/ppdm"
  environment          = var.environment
  depends_on           = [module.networks]
  ppdm_name            = var.PPDM_HOSTNAME
  ppdm_version         = var.ppdm_version
  default_sg_id        = var.create_networks ? module.networks[0].default_sg_id : var.default_sg_id
  subnet_id            = var.create_networks ? module.networks[0].private_subnets_id[0] : var.subnet_id[0]
  availability_zone    = local.production_availability_zones[0]
  vpc_id               = var.create_networks ? module.networks[0].vpc_id : var.vpc_id
  ingress_cidr_blocks  = var.ingress_cidr_blocks
  public_subnets_cidr  = var.public_subnets_cidr
  private_subnets_cidr = var.private_subnets_cidr
  region               = var.region
  tags                 = var.tags
}

module "bastion" {
  count            = var.create_bastion ? 1 : 0 // terraform  >=0.13 only
  bastion_instance = count.index
  source           = "./modules/bastion"
  environment      = var.environment
  depends_on       = [module.networks]
  bastion_name     = var.BASTION_HOSTNAME
  default_sg_id    = var.create_networks ? module.networks[0].default_sg_id : var.default_sg_id
  subnet_id        = var.create_networks ? module.networks[0].private_subnets_id[0] : var.subnet_id[0]
  # subnet_id         = var.create_networks ? module.networks[0].public_subnets_id[0] : var.subnet_id[0]
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
  wan_ip                      = var.crs_wan_ip
  environment                 = "crs_${var.environment}"
  tunnel1_preshared_key       = var.crs_tunnel1_preshared_key
  vpn_destination_cidr_blocks = var.crs_vpn_destination_cidr_blocks
  tags                        = var.tags
  bgp_asn                     = 65001
  amazon_side_asn             = 64512
}


module "crs_networks" {
  vpc_name             = "${var.crs_environment}_PPCR VPC"
  count                = var.create_crs_networks ? 1 : 0 // terraform  >=0.13 only
  is_crs               = true
  networks_instance    = count.index
  source               = "./modules/networks"
  region               = var.region
  environment          = var.environment
  vpc_cidr             = var.crs_vpc_cidr
  public_subnets_cidr  = var.crs_public_subnets_cidr
  private_subnets_cidr = var.crs_private_subnets_cidr
  availability_zones   = local.production_availability_zones
  tags                 = var.tags
}

module "crs_client_vpn" {
  count                 = var.create_crs_client_vpn ? 1 : 0 // terraform  >=0.13 only
  source                = "./modules/client_vpn"
  depends_on            = [module.networks, module.crs_s2s_vpn]
  vpc_id                = var.crs_vpc_id
  subnet_id             = var.crs_subnet_id
  target_vpc_cidr_block = var.crs_vpc_cidr
  //  private_route_table         = var.crs_private_route_table
  //  wan_ip                      = var.wan_ip
  environment = "crs_${var.environment}"
  //  tunnel1_preshared_key       = var.crs_tunnel1_preshared_key
  //  vpn_destination_cidr_blocks = var.crs_vpn_destination_cidr_blocks
  tags = var.tags
}
module "client_vpn" {
  count                 = var.create_client_vpn ? 1 : 0 // terraform  >=0.13 only
  source                = "./modules/client_vpn"
  depends_on            = [module.networks]
  vpc_id                = var.create_networks ? module.networks[0].vpc_id : var.vpc_id
  subnet_id             = var.create_networks ? module.networks[0].private_subnets_id[0] : var.subnet_id[0]
  target_vpc_cidr_block = var.vpc_cidr
  //  private_route_table         = var.crs_private_route_table
  //  wan_ip                      = var.wan_ip
  environment = var.environment
  //  tunnel1_preshared_key       = var.crs_tunnel1_preshared_key
  //  vpn_destination_cidr_blocks = var.crs_vpn_destination_cidr_blocks
  tags = var.tags
}
