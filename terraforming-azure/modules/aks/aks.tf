locals {
  aks_name           = "aks${var.aks_instance}-${var.environment}"
  node_pool = regex("[a-z0-9]{3,12}","np${var.aks_instance}${local.aks_name}")
  resourcegroup_name = "${var.environment}-aks${var.aks_instance}"
}

resource "azurerm_resource_group" "resource_group" {
  name     = local.resourcegroup_name
  location = var.location
}

resource "azurerm_kubernetes_cluster" "k8s" {
  name                = local.aks_name
  resource_group_name = local.resourcegroup_name
  location            = var.location
  dns_prefix          = local.aks_name
  private_cluster_enabled = var.aks_private_cluster
  private_dns_zone_id = var.aks_private_dns_zone_id

  default_node_pool {
    name           = local.node_pool
    node_count     = var.k8s_pool_node_count
    vm_size        = var.k8s_pool_node_size
    vnet_subnet_id = var.subnet_id

  }

  service_principal {
    client_id     = var.client_id
    client_secret = var.client_secret
  }

  tags = {
    environment = var.deployment
    autodelete  = var.autodelete
  }
}
