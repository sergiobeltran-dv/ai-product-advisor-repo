output "vnet_id" {
  description = "ID of the Virtual Network"
  value       = azurerm_virtual_network.vnet.id
}

output "vnet_name" {
  description = "Name of the Virtual Network"
  value       = azurerm_virtual_network.vnet.name
}

output "subnet_ids" {
  description = "Map of subnet names to their IDs"
  value = {
    for key, subnet in azurerm_subnet.subnets : key => subnet.id
  }
}

output "subnet_names" {
  description = "Map of subnet keys to their names"
  value = {
    for key, subnet in azurerm_subnet.subnets : key => subnet.name
  }
}

output "nsg_ids" {
  description = "Map of NSG names to their IDs"
  value = {
    for key, nsg in azurerm_network_security_group.nsgs : key => nsg.id
  }
}

output "private_dns_zone_ids" {
  description = "Map of Private DNS Zone names to their IDs"
  value = {
    for key, zone in azurerm_private_dns_zone.dns_zones : key => zone.id
  }
}

output "private_dns_zone_names" {
  description = "Map of Private DNS Zone keys to their names"
  value = {
    for key, zone in azurerm_private_dns_zone.dns_zones : key => zone.name
  }
}
