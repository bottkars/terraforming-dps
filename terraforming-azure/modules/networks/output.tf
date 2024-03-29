
output "dns_zone_name" {
  value = azurerm_private_dns_zone.env_dns_zone.name
}
output "dns_zone_id" {
  value = azurerm_private_dns_zone.env_dns_zone.id
}
#output "dns_zone_name_servers" {
#  value = azurerm_private_dns_zone.env_dns_zone.name_servers
#}

output "resource_group_name" {
  value = azurerm_resource_group.resource_group.name
}

output "network_name" {
  value = azurerm_virtual_network.virtual_network.name
}

output "infrastructure_subnet_id" {
  value = azurerm_subnet.infrastructure_subnet.id
}
output "aks_subnet_id" {
  value = azurerm_subnet.aks_subnet[0].id
}

output "infrastructure_subnet_name" {
  value = azurerm_subnet.infrastructure_subnet.name
}

output "infrastructure_subnet_cidr" {
  value = azurerm_subnet.infrastructure_subnet.address_prefixes[0]
}

output "infrastructure_subnet_gateway" {
  value = cidrhost(azurerm_subnet.infrastructure_subnet.address_prefixes[0], 1)
}

output "virtual_network_name" {
  value = azurerm_virtual_network.virtual_network.name
}
