output "firewall_id" {
  description = "ID of the Azure Firewall"
  value       = var.enable_firewall ? azurerm_firewall.firewall[0].id : null
}

output "firewall_name" {
  description = "Name of the Azure Firewall"
  value       = var.enable_firewall ? azurerm_firewall.firewall[0].name : null
}

output "firewall_private_ip" {
  description = "Private IP address of the Azure Firewall"
  value       = var.enable_firewall ? azurerm_firewall.firewall[0].ip_configuration[0].private_ip_address : null
}

output "firewall_policy_id" {
  description = "ID of the Firewall Policy"
  value       = var.enable_firewall && var.enable_firewall_policy ? azurerm_firewall_policy.policy[0].id : null
}

output "vpn_gateway_id" {
  description = "ID of the VPN Gateway"
  value       = var.enable_vpn_gateway ? azurerm_virtual_network_gateway.vpn_gateway[0].id : null
}

output "vpn_gateway_name" {
  description = "Name of the VPN Gateway"
  value       = var.enable_vpn_gateway ? azurerm_virtual_network_gateway.vpn_gateway[0].name : null
}

output "vpn_gateway_public_ip" {
  description = "Public IP address of the VPN Gateway"
  value       = var.enable_vpn_gateway ? azurerm_public_ip.vpn_gateway_pip[0].ip_address : null
}

output "nat_gateway_id" {
  description = "ID of the NAT Gateway"
  value       = var.enable_nat_gateway ? azurerm_nat_gateway.nat_gateway[0].id : null
}

output "nat_gateway_name" {
  description = "Name of the NAT Gateway"
  value       = var.enable_nat_gateway ? azurerm_nat_gateway.nat_gateway[0].name : null
}
