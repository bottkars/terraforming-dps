
resource "azurerm_resource_group" "dps_resource_group" {
  name     = var.env_name
  location = var.location
}

# Security Groups



# = Network

resource "azurerm_virtual_network" "dps_virtual_network" {
  name                = "${var.env_name}-virtual-network"
  depends_on          = [azurerm_resource_group.dps_resource_group]
  resource_group_name = azurerm_resource_group.dps_resource_group.name
  address_space       = var.dps_virtual_network_address_space
  location            = var.location
}

resource "azurerm_subnet" "AzureBastionSubnet" {
  name                      = "AzureBastionSubnet"
  depends_on                = [azurerm_resource_group.dps_resource_group]
  resource_group_name       = azurerm_resource_group.dps_resource_group.name
  virtual_network_name      = azurerm_virtual_network.dps_virtual_network.name
  address_prefixes            = [var.dps_azure_bastion_subnet]
#  network_security_group_id = "${azurerm_network_security_group.ddve_security_group.id}"
}

resource "azurerm_public_ip" "AzureBastionIP" {
  name                = "AzureBastionIP"
  location            = var.location
  resource_group_name = azurerm_resource_group.dps_resource_group.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_bastion_host" "AzureBastionHost" {
  name                = "AzureBastionHost"
  location            = var.location
  resource_group_name = azurerm_resource_group.dps_resource_group.name

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.AzureBastionSubnet.id
    public_ip_address_id = azurerm_public_ip.AzureBastionIP.id
  }
}

resource "azurerm_subnet" "infrastructure_subnet" {
  name                      = "${var.env_name}-infrastructure-subnet"
  depends_on                = [azurerm_resource_group.dps_resource_group]
  resource_group_name       = azurerm_resource_group.dps_resource_group.name
  virtual_network_name      = azurerm_virtual_network.dps_virtual_network.name
  address_prefixes          = [var.dps_infrastructure_subnet]
}

resource "azurerm_subnet" "aks_subnet" {
  count = var.dps_enable_aks_subnet ? 1 : 0
  name                      = "${var.env_name}-aks-subnet"
  depends_on                = [azurerm_resource_group.dps_resource_group]
  resource_group_name       = azurerm_resource_group.dps_resource_group.name
  virtual_network_name      = azurerm_virtual_network.dps_virtual_network.name
  address_prefixes          = [var.dps_aks_subnet]
}

# ============= DNS

locals {
  dns_subdomain = var.env_name
}

resource "azurerm_private_dns_zone" "env_dns_zone" {
  name                = "${var.dns_subdomain != "" ? var.dns_subdomain : local.dns_subdomain}.${var.dns_suffix}"
  resource_group_name = azurerm_resource_group.dps_resource_group.name
}
resource "azurerm_private_dns_zone_virtual_network_link" "env_dns_zone" {
  name                  = azurerm_virtual_network.dps_virtual_network.name
  resource_group_name   = azurerm_resource_group.dps_resource_group.name
  private_dns_zone_name = azurerm_private_dns_zone.env_dns_zone.name
  virtual_network_id    = azurerm_virtual_network.dps_virtual_network.id
}

output "dns_zone_name" {
  value = azurerm_private_dns_zone.env_dns_zone.name
}

#output "dns_zone_name_servers" {
#  value = azurerm_private_dns_zone.env_dns_zone.name_servers
#}

output "resource_group_name" {
  value = azurerm_resource_group.dps_resource_group.name
}

output "network_name" {
  value = azurerm_virtual_network.dps_virtual_network.name
}

output "infrastructure_subnet_id" {
  value = azurerm_subnet.infrastructure_subnet.id
}

output "infrastructure_subnet_name" {
  value = azurerm_subnet.infrastructure_subnet.name
}

output "infrastructure_subnet_cidr" {
  value = azurerm_subnet.infrastructure_subnet.address_prefix
}

output "infrastructure_subnet_gateway" {
  value = cidrhost(azurerm_subnet.infrastructure_subnet.address_prefix, 1)
}

