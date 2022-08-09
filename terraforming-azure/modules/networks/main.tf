
resource "azurerm_resource_group" "resource_group" {
  name     = var.environment
  location = var.location
}

# Security Groups



# = Network

resource "azurerm_virtual_network" "virtual_network" {
  name                = "${var.environment}-virtual-network"
  depends_on          = [azurerm_resource_group.resource_group]
  resource_group_name = azurerm_resource_group.resource_group.name
  address_space       = var.virtual_network_address_space
  location            = var.location
}

resource "azurerm_subnet" "AzureBastionSubnet" {
  count                = var.create_bastion ? 1 : 0
  name                 = "AzureBastionSubnet"
  depends_on           = [azurerm_resource_group.resource_group]
  resource_group_name  = azurerm_resource_group.resource_group.name
  virtual_network_name = azurerm_virtual_network.virtual_network.name
  address_prefixes     = var.azure_bastion_subnet
  #  network_security_group_id = "${azurerm_network_security_group.ddve_security_group.id}"
}

resource "azurerm_public_ip" "AzureBastionIP" {
  count               = var.create_bastion ? 1 : 0
  name                = "AzureBastionIP"
  location            = var.location
  resource_group_name = azurerm_resource_group.resource_group.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_bastion_host" "AzureBastionHost" {
  count               = var.create_bastion ? 1 : 0
  name                = "AzureBastionHost"
  location            = var.location
  resource_group_name = azurerm_resource_group.resource_group.name

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.AzureBastionSubnet[0].id
    public_ip_address_id = azurerm_public_ip.AzureBastionIP[0].id
  }
}

resource "azurerm_subnet" "infrastructure_subnet" {
  name                 = "${var.environment}-infrastructure-subnet"
  depends_on           = [azurerm_resource_group.resource_group]
  resource_group_name  = azurerm_resource_group.resource_group.name
  virtual_network_name = azurerm_virtual_network.virtual_network.name
  address_prefixes     = var.infrastructure_subnet
  service_endpoints    = ["Microsoft.Sql", "Microsoft.Storage"]  
}

resource "azurerm_subnet" "aks_subnet" {
  count                = var.enable_aks_subnet ? 1 : 0
  name                 = "${var.environment}-aks-subnet"
  depends_on           = [azurerm_resource_group.resource_group]
  resource_group_name  = azurerm_resource_group.resource_group.name
  virtual_network_name = azurerm_virtual_network.virtual_network.name
  address_prefixes     = var.aks_subnet
}
resource "azurerm_subnet" "VPN_GatewaySubnet" {
  count                = var.create_s2s_vpn ? 1 : 0
  name                 = "GatewaySubnet"
  depends_on           = [azurerm_resource_group.resource_group]
  resource_group_name  = azurerm_resource_group.resource_group.name
  virtual_network_name = azurerm_virtual_network.virtual_network.name
  address_prefixes     = var.vpn_subnet
}


resource "azurerm_subnet" "tkg_controlplane_subnet" {
  count                = var.enable_tkg_controlplane_subnet ? 1 : 0
  name                 = "${var.environment}-tkg-control-subnet"
  depends_on           = [azurerm_resource_group.resource_group]
  resource_group_name  = azurerm_resource_group.resource_group.name
  virtual_network_name = azurerm_virtual_network.virtual_network.name
  address_prefixes     = var.tkg_controlplane_subnet
}

resource "azurerm_subnet" "tkg_workload_subnet" {
  count                = var.enable_tkg_workload_subnet ? 1 : 0
  name                 = "${var.environment}-tkg-workload-subnet"
  depends_on           = [azurerm_resource_group.resource_group]
  resource_group_name  = azurerm_resource_group.resource_group.name
  virtual_network_name = azurerm_virtual_network.virtual_network.name
  address_prefixes     = var.tkg_workload_subnet
}
# ============= DNS

locals {
  dns_subdomain = var.environment
}

resource "azurerm_private_dns_zone" "env_dns_zone" {
  name                = "${var.dns_subdomain != "" ? var.dns_subdomain : local.dns_subdomain}.${var.dns_suffix}"
  resource_group_name = azurerm_resource_group.resource_group.name
}
resource "azurerm_private_dns_zone_virtual_network_link" "env_dns_zone" {
  name                  = azurerm_virtual_network.virtual_network.name
  resource_group_name   = azurerm_resource_group.resource_group.name
  private_dns_zone_name = azurerm_private_dns_zone.env_dns_zone.name
  virtual_network_id    = azurerm_virtual_network.virtual_network.id
}
