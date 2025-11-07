output "private_endpoint_ids" {
  description = "Map of private endpoint keys to their IDs"
  value = {
    for key, pe in azurerm_private_endpoint.private_endpoints : key => pe.id
  }
}

output "private_endpoint_names" {
  description = "Map of private endpoint keys to their names"
  value = {
    for key, pe in azurerm_private_endpoint.private_endpoints : key => pe.name
  }
}

output "private_endpoint_ip_addresses" {
  description = "Map of private endpoint keys to their private IP addresses"
  value = {
    for key, pe in azurerm_private_endpoint.private_endpoints : key => pe.private_service_connection[0].private_ip_address
  }
}

output "private_endpoint_network_interface_ids" {
  description = "Map of private endpoint keys to their network interface IDs"
  value = {
    for key, pe in azurerm_private_endpoint.private_endpoints : key => pe.network_interface[0].id
  }
}
