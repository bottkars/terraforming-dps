provider "azurerm" {
  # The "feature" block is required for AzureRM provider 2.x.
  # If you're using version 1.x, the "features" block is not allowed.
  version = "~>2.0"
  features {}
  # expect to use with env vars, otherwise derive from vars  ...
  subscription_id = var.subscription_id
  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id
  environment     = var.environment
}

/*
uncomment necx block with correct backend or use backend.tf
*/

/* 
terraform {
  required_version = "< 0.12.0"

  backend "local" {
    path = "../terraform.tfstate"
  }
  backend "s3" {
        bucket = "terraform"
    key    = "terraforming-dps"    
}
*/


module "infra" {
  source = "./modules/infra"
  ENV_NAME                          = var.ENV_NAME
  location                          = var.location
  dns_suffix                        = var.dns_suffix
  dps_infrastructure_subnet         = var.dps_infrastructure_subnet
  dps_aks_subnet                    = var.dps_aks_subnet
  dps_azure_bastion_subnet          = var.dps_azure_bastion_subnet
  dps_virtual_network_address_space = var.dps_virtual_network_address_space
  dps_enable_aks_subnet             = var.aks_subnet
}
/*
uncomment next block to add ddve
*/

module "ddve" {
#   count = var.ddve ? 1 : 0 terraform 0.13 only
  source                = "./modules/ddve"
  DDVE_IMAGE            = var.DDVE_IMAGE
  DDVE_HOSTNAME         = var.DDVE_HOSTNAME
  DDVE_META_DISKS       = var.DDVE_META_DISKS
  DDVE_INITIAL_PASSWORD = var.DDVE_INITIAL_PASSWORD
  ddve_private_ip       = var.ddve_private_ip
  ENV_NAME              = var.ENV_NAME
  location              = var.location
  DDVE_VM_SIZE          = var.DDVE_VM_SIZE
  resource_group_name   = module.infra.resource_group_name
  dns_zone_name         = module.infra.dns_zone_name
  subnet_id             = module.infra.infrastructure_subnet_id
  public_ip             = var.DDVE_PUBLIC_IP
  ddve_ppdd_nfs_client  = var.DDVE_PPDM_HOSTNAME
  ddve_ppdd_nfs_path    = var.ddve_ppdd_nfs_path
}

/*
uncomment next block to add ppdm
*/

module "ppdm" {
#   count = var.ppdm ? 1 : 0  only on terraform 0.13
  source                = "./modules/ppdm"
  PPDM_IMAGE            = var.PPDM_IMAGE
  PPDM_HOSTNAME         = var.PPDM_HOSTNAME
  PPDM_META_DISKS       = var.PPDM_META_DISKS
  PPDM_INITIAL_PASSWORD = var.PPDM_INITIAL_PASSWORD
  ppdm_private_ip       = var.ppdm_private_ip
  ENV_NAME              = var.ENV_NAME
  location              = var.location
  PPDM_VM_SIZE          = var.PPDM_VM_SIZE
  resource_group_name   = module.infra.resource_group_name
  dns_zone_name         = module.infra.dns_zone_name
  subnet_id             = module.infra.infrastructure_subnet_id
  public_ip             = var.PPDM_PUBLIC_IP
}

/*
uncomment next block to add ppdm# linux guest
module "linux" {
  count = var.linux ? 1 : 0  
  source = "./modules/linux"
  linux_image = var.linux_image
  linux_hostname = var.linux_hostname
  linux_data_disks = var.linux_data_disks
  linux_admin_username = var.linux_admin_username
  linux_private_ip = var.linux_private_ip
  ENV_NAME = var.ENV_NAME
  location = var.location
  linux_vm_size     = var.linux_vm_size
  resource_group_name   = module.infra.resource_group_name
  dns_zone_name         = module.infra.dns_zone_name
 # security_group_id   = module.infra.linux_security_group_id
  subnet_id             = module.infra.infrastructure_subnet_id
  storage_account_key      = var.storage_account_key_cs
  storage_account          = var.storage_account_cs
  file_uris         = var.file_uris_cs
}
*/