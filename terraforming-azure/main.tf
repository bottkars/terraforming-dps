terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.0"
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




provider "azurerm" {
  # The "feature" block is required for AzureRM provider 2.x.
  # If you're using version 1.x, the "features" block is not allowed.
  features {}

  # expect to use with env vars, otherwise derive from vars  ...
  subscription_id = var.subscription_id
  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id
  environment     = var.azure_environment
}

module "s2s_vpn" {
  count                       = var.create_s2s_vpn ? 1 : 0 // terraform  >=0.13 only
  source                      = "./modules/s2s_vpn"
  depends_on                  = [module.networks]
  vnet                        = var.create_networks ? module.networks[0].virtual_network_name : var.vnet_name
  wan_ip                      = var.wan_ip
  vpn_subnet                  = var.vpn_subnet
  environment                 = var.environment
  tunnel1_preshared_key       = var.tunnel1_preshared_key
  vpn_destination_cidr_blocks = var.vpn_destination_cidr_blocks
  location                    = var.location
  resource_group_name         = var.create_networks ? module.networks[0].resource_group_name : var.network_rg_name
}


module "networks" {
  source                         = "./modules/networks"
  count                          = var.create_networks ? 1 : 0
  networks_instance              = count.index
  environment                    = var.environment
  location                       = var.location
  dns_suffix                     = var.dns_suffix
  infrastructure_subnet          = var.infrastructure_subnet
  aks_subnet                     = var.aks_subnet
  tkg_workload_subnet            = var.tkg_workload_subnet
  tkg_controlplane_subnet        = var.tkg_controlplane_subnet
  azure_bastion_subnet           = var.azure_bastion_subnet
  virtual_network_address_space  = var.virtual_network_address_space
  enable_tkg_workload_subnet     = var.enable_tkg_workload_subnet
  enable_tkg_controlplane_subnet = var.enable_tkg_controlplane_subnet
  enable_aks_subnet              = var.enable_aks_subnet
  vpn_subnet                     = var.vpn_subnet
  create_s2s_vpn                 = var.create_s2s_vpn
}


module "ave" {
  source       = "./modules/ave"
  count        = var.create_ave ? 1 : 0
  ave_instance = count.index

  AVE_IMAGE            = var.AVE_IMAGE
  ave_hostname         = var.AVE_HOSTNAME
  ave_gsan_disks       = var.ave_gsan_disks
  ave_initial_password = var.ave_initial_password
  ave_private_ip       = var.ave_private_ip
  environment          = var.environment
  location             = var.location
  ave_vm_size          = var.ave_vm_size
  resource_group_name  = var.create_networks ? module.networks[0].resource_group_name : var.environment
  dns_zone_name        = var.create_networks ? module.networks[0].dns_zone_name : var.networks_dns_zone_name
  subnet_id            = var.create_networks ? module.networks[0].infrastructure_subnet_id : var.networks_infrastructure_subnet_id
}

module "nve" {

  source                     = "./modules/nve"
  count                      = var.create_nve ? 1 : 0
  nve_instance               = count.index
  nve_image                  = var.NVE_IMAGE
  nve_hostname               = var.NVE_HOSTNAME
  nve_data_disks             = var.NVE_DATA_DISKS
  nve_initial_password       = var.NVE_INITIAL_PASSWORD
  nve_private_ip             = var.NVE_PRIVATE_IP
  environment                = var.environment
  location                   = var.location
  nve_vm_size                = var.NVE_VM_SIZE
  nve_tcp_inbound_rules_Inet = var.NVE_TCP_INBOUND_RULES_INET
  public_ip                  = var.NVE_PUBLIC_IP
  resource_group_name        = var.create_networks ? module.networks[0].resource_group_name : var.environment
  dns_zone_name              = var.create_networks ? module.networks[0].dns_zone_name : var.networks_dns_zone_name
  subnet_id                  = var.create_networks ? module.networks[0].infrastructure_subnet_id : var.networks_infrastructure_subnet_id
}

module "ddve" {
  count                       = var.ddve_count > 0 ? var.ddve_count : 0
  source                      = "./modules/ddve"
  ddve_instance               = count.index + 1
  ddve_image                  = var.ddve_image
  ddve_meta_disks             = var.ddve_meta_disks
  ddve_initial_password       = var.ddve_initial_password
  ddve_tcp_inbound_rules_Inet = var.DDVE_TCP_INBOUND_RULES_INET
  environment                 = var.environment
  location                    = var.location
  ddve_type                   = var.ddve_type
  resource_group_name         = var.create_networks ? module.networks[0].resource_group_name : var.environment
  dns_zone_name               = var.create_networks ? module.networks[0].dns_zone_name : var.networks_dns_zone_name
  subnet_id                   = var.create_networks ? module.networks[0].infrastructure_subnet_id : var.networks_infrastructure_subnet_id
  public_ip                   = var.ddve_public_ip
}



module "ppdm" {
  count                 = var.ppdm_count > 0 ? var.ppdm_count : 0
  source                = "./modules/ppdm"
  ppdm_instance         = count.index + 1
  depends_on            = [module.networks]
  ppdm_image            = var.ppdm_image
  ppdm_meta_disks       = var.ppdm_meta_disks
  ppdm_initial_password = var.ppdm_initial_password
  environment           = var.environment
  location              = var.location
  ppdm_vm_size          = var.ppdm_vm_size
  resource_group_name   = var.create_networks ? module.networks[0].resource_group_name : var.environment
  dns_zone_name         = var.create_networks ? module.networks[0].dns_zone_name : var.networks_dns_zone_name
  subnet_id             = var.create_networks ? module.networks[0].infrastructure_subnet_id : var.networks_infrastructure_subnet_id
  public_ip             = var.ppdm_public_ip
}
module "aks" {
  count               = var.aks_count > 0 ? var.aks_count : 0
  source              = "./modules/aks"
  aks_instance        = count.index + 1
  depends_on          = [module.networks]
  environment         = var.environment
  location            = var.location
  client_id           = var.client_id
  client_secret       = var.client_secret
  resource_group_name = var.create_networks ? module.networks[0].resource_group_name : var.environment
  subnet_id           = var.create_networks ? module.networks[0].aks_subnet_id : var.networks_aks_subnet_id
}
module "linux" {
  count                = var.create_linux ? 1 : 0
  source               = "./modules/linux"
  linux_image          = var.LINUX_IMAGE
  linux_hostname       = var.LINUX_HOSTNAME
  linux_data_disks     = var.LINUX_DATA_DISKS
  linux_admin_username = var.LINUX_ADMIN_USERNAME
  linux_private_ip     = var.LINUX_PRIVATE_IP
  environment          = var.environment
  location             = var.location
  linux_vm_size        = var.LINUX_VM_SIZE
  resource_group_name  = var.create_networks ? module.networks[0].resource_group_name : var.environment
  dns_zone_name        = var.create_networks ? module.networks[0].dns_zone_name : var.networks_dns_zone_name
  subnet_id            = var.create_networks ? module.networks[0].infrastructure_subnet_id : var.networks_infrastructure_subnet_id
  storage_account_key  = var.storage_account_key_cs
  storage_account      = var.storage_account_cs
  file_uris            = var.file_uris_cs
}

