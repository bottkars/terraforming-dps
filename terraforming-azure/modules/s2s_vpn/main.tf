data "azurerm_subnet" "s2s_vpn" { #--We need to look this up as as list as we need to get the ID of the Subnet
    name                 = "GatewaySubnet"
    count                = length(var.vpn_subnet)
    resource_group_name  = var.resource_group_name
    virtual_network_name = var.vnet
}

resource "azurerm_local_network_gateway" "s2s_gateway" {
    name                = "${var.environment}-peer_vpn_gateway"
    location            = var.location
    resource_group_name = var.resource_group_name
    gateway_address     = var.wan_ip #--Your local device public IP here
    address_space       = var.vpn_destination_cidr_blocks
}

resource "azurerm_public_ip" "s2s_vpn" {
    name                = "${var.environment}-vpn_public_ip"
    location            = var.location
    resource_group_name = var.resource_group_name
    allocation_method   = "Dynamic" #--Dynamic set means Azure will generate an IP for your Azure VPN Gateway
}

resource "azurerm_virtual_network_gateway" "s2s_vpn" {
    name                    = "${var.environment}-vpn_gateway"
    location                = var.location
    resource_group_name     = var.resource_group_name
    type                    = "Vpn" 
    vpn_type                = "RouteBased" 
    active_active           = false
    enable_bgp              = false
    sku                     = "Basic" #
    ip_configuration {
        public_ip_address_id          = azurerm_public_ip.s2s_vpn.id
        private_ip_address_allocation = "Dynamic"
        subnet_id                     = data.azurerm_subnet.s2s_vpn.0.id #--There's that ID we needed, for the Transport Subnet
    }
}

resource "azurerm_virtual_network_gateway_connection" "s2s_vpn" {
    name                       = "${var.environment}-vpn_connection"
    location                   = var.location
    resource_group_name        = var.resource_group_name
    type                       = "IPsec"
    virtual_network_gateway_id = azurerm_virtual_network_gateway.s2s_vpn.id
    local_network_gateway_id   = azurerm_local_network_gateway.s2s_gateway.id
    shared_key                 = var.tunnel1_preshared_key 
}