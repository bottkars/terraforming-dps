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
module "infra" {
  source = "../modules/infra"

  ENV_NAME                          = var.ENV_NAME
  location                          = var.location
  dns_suffix                        = var.dns_suffix
  dps_infrastructure_subnet         = var.dps_infrastructure_subnet
  dps_azure_bastion_subnet          = var.dps_azure_bastion_subnet
  dps_virtual_network_address_space = var.dps_virtual_network_address_space
}

module "aks" {
  source = "../modules/aks"
  ENV_NAME = var.ENV_NAME
  location = var.location
  resource_group_name = module.infra.resource_group_name
//  dns_zone_name       = module.infra.dns_zone_name
  subnet_id           = module.infra.infrastructure_subnet_id
//  public_ip           = var.PPDM_PUBLIC_IP
    client_id       = var.client_id
    client_secret   = var.client_secret
    k8s_pool_node_count = var.k8s_pool_node_count
    k8s_pool_node_size = var.k8s_pool_node_size

}