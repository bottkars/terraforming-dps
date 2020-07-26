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
#    bucket = "terraform"
#    key    = "terraforming-dps"    
#}


module "infra" {
  source = "../modules/infra"

  env_name                          = var.env_name
  location                          = var.location
#  dns_subdomain                    = var.dns_subdomain
  dns_suffix                        = var.dns_suffix
  dps_infrastructure_subnet         = var.dps_infrastructure_subnet
  dps_azure_bastion_subnet          = var.dps_azure_bastion_subnet
  dps_virtual_network_address_space = var.dps_virtual_network_address_space
}

module "ddve" {
  source = "../modules/ddve"
  ddve_image = var.ddve_image
  ddve_hostname = var.ddve_hostname
  ddve_meta_disks = var.ddve_meta_disks
  ddve_meta_disk_size = var.ddve_meta_disk_size
  ddve_initial_password = var.ddve_initial_password
  ddve_private_ip = var.ddve_private_ip
  env_name = var.env_name
  location = var.location
  ddve_vm_size    = var.ddve_vm_size
  resource_group_name = module.infra.resource_group_name
  dns_zone_name       = module.infra.dns_zone_name
  security_group_id   = module.infra.security_group_id
  subnet_id           = module.infra.infrastructure_subnet_id
}

