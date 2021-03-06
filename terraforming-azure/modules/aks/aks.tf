

resource "azurerm_kubernetes_cluster" "k8s" {
  name                = "k8s-${var.ENV_NAME}"
  resource_group_name      = var.resource_group_name
  location                 = var.location
  dns_prefix          = "k8s-${var.ENV_NAME}"
//  network_profile {
//    network_plugin = "azure"
//    load_balancer_sku = "standard"
//    service_cidr = "10.1.0.0/16"
//  }
  

  /*linux_profile {
    admin_username = "ubuntu"

    ssh_key {
      key_data = tls_private_key.aks.public_key_openssh

    }
  }*/

  default_node_pool {
    name           = "pool"
    node_count     = var.k8s_pool_node_count
    vm_size        = var.k8s_pool_node_size
    vnet_subnet_id     = var.subnet_id

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