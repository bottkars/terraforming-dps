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

#terraform {
  #required_version = "< 0.12.0"

#  backend "local" {
#    path = "../terraform.tfstate"
#  }
#  backend "s3" {
#        bucket = "terraform"
#    key    = "terraforming-dps"    
#}


module "infra" {
  source = "../modules/infra"

  ENV_NAME                          = var.ENV_NAME
  location                          = var.location
  dns_suffix                        = var.dns_suffix
  dps_infrastructure_subnet         = var.dps_infrastructure_subnet
  dps_azure_bastion_subnet          = var.dps_azure_bastion_subnet
  dps_virtual_network_address_space = var.dps_virtual_network_address_space
}

module "ddve" {
  source = "../modules/ddve"
  DDVE_IMAGE = var.DDVE_IMAGE
  DDVE_HOSTNAME = var.DDVE_HOSTNAME
  DDVE_META_DISKS = var.DDVE_META_DISKS
  DDVE_INITIAL_PASSWORD = var.DDVE_INITIAL_PASSWORD
  ddve_private_ip = var.ddve_private_ip
  ENV_NAME = var.ENV_NAME
  location = var.location
  DDVE_VM_SIZE = var.DDVE_VM_SIZE
  resource_group_name = module.infra.resource_group_name
  dns_zone_name       = module.infra.dns_zone_name
  subnet_id           = module.infra.infrastructure_subnet_id
  public_ip           = var.DDVE_PUBLIC_IP
  ddve_ppdd_nfs_client  = var.PPDM_HOSTNAME
  ddve_ppdd_nfs_path  = var.ddve_ppdd_nfs_path
}
