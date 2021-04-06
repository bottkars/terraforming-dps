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
#  dns_subdomain                    = var.dns_subdomain
  dns_suffix                        = var.dns_suffix
  dps_infrastructure_subnet         = var.dps_infrastructure_subnet
  dps_azure_bastion_subnet          = var.dps_azure_bastion_subnet
  dps_virtual_network_address_space = var.dps_virtual_network_address_space
}

module "linux" {
  source = "../modules/linux"
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

 