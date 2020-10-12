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

  env_name                          = var.env_name
  location                          = var.location
  dns_suffix                        = var.dns_suffix
  dps_infrastructure_subnet         = var.dps_infrastructure_subnet
  dps_azure_bastion_subnet          = var.dps_azure_bastion_subnet
  dps_virtual_network_address_space = var.dps_virtual_network_address_space
}

module "ppdm" {
  source = "../modules/ppdm"
#  ppdm_image = var.ppdm_image
  ppdm_hostname = var.ppdm_hostname
  ppdm_meta_disks = var.ppdm_meta_disks
  ppdm_initial_password = var.ppdm_initial_password
  ppdm_private_ip = var.ppdm_private_ip
  env_name = var.env_name
  location = var.location
  ppdm_vm_size = var.ppdm_vm_size
  resource_group_name = module.infra.resource_group_name
  dns_zone_name       = module.infra.dns_zone_name
  subnet_id           = module.infra.infrastructure_subnet_id
  public_ip           = var.ppdm_public_ip
}

