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

module "ppdm" {
  source = "../modules/ppdm"
  PPDM_IMAGE = var.PPDM_IMAGE
  PPDM_HOSTNAME = var.PPDM_HOSTNAME
  PPDM_META_DISKS = var.PPDM_META_DISKS
  PPDM_INITIAL_PASSWORD = var.PPDM_INITIAL_PASSWORD
  ppdm_private_ip = var.ppdm_private_ip
  ENV_NAME = var.ENV_NAME
  location = var.location
  PPDM_VM_SIZE = var.PPDM_VM_SIZE
  resource_group_name = module.infra.resource_group_name
  dns_zone_name       = module.infra.dns_zone_name
  subnet_id           = module.infra.infrastructure_subnet_id
  public_ip           = var.PPDM_PUBLIC_IP
}

