# Virtual Network
resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = var.vnet_address_space
  
  tags = var.tags
}

# Subnets
resource "azurerm_subnet" "subnets" {
  for_each = var.subnets

  name                 = each.value.name
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = each.value.address_prefixes
  
  # Service endpoints
  service_endpoints = lookup(each.value, "service_endpoints", [])
  
  # Delegation for specific services
  dynamic "delegation" {
    for_each = lookup(each.value, "delegation", null) != null ? [each.value.delegation] : []
    content {
      name = delegation.value.name
      service_delegation {
        name    = delegation.value.service_name
        actions = lookup(delegation.value, "actions", [])
      }
    }
  }
}

# Network Security Groups
resource "azurerm_network_security_group" "nsgs" {
  for_each = var.network_security_groups

  name                = each.value.name
  location            = var.location
  resource_group_name = var.resource_group_name

  tags = var.tags
}

# NSG Rules
resource "azurerm_network_security_rule" "nsg_rules" {
  for_each = { for rule in local.nsg_rules : rule.key => rule }

  name                        = each.value.name
  priority                    = each.value.priority
  direction                   = each.value.direction
  access                      = each.value.access
  protocol                    = each.value.protocol
  source_port_range           = lookup(each.value, "source_port_range", "*")
  destination_port_range      = lookup(each.value, "destination_port_range", null)
  destination_port_ranges     = lookup(each.value, "destination_port_ranges", null)
  source_address_prefix       = lookup(each.value, "source_address_prefix", "*")
  destination_address_prefix  = lookup(each.value, "destination_address_prefix", "*")
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.nsgs[each.value.nsg_key].name
}

# Associate NSGs with Subnets
resource "azurerm_subnet_network_security_group_association" "nsg_associations" {
  for_each = var.subnet_nsg_associations

  subnet_id                 = azurerm_subnet.subnets[each.value.subnet_key].id
  network_security_group_id = azurerm_network_security_group.nsgs[each.value.nsg_key].id
}

# Private DNS Zones
resource "azurerm_private_dns_zone" "dns_zones" {
  for_each = var.private_dns_zones

  name                = each.value.name
  resource_group_name = var.resource_group_name

  tags = var.tags
}

# Link Private DNS Zones to VNet
resource "azurerm_private_dns_zone_virtual_network_link" "dns_links" {
  for_each = var.private_dns_zones

  name                  = "${var.vnet_name}-${each.key}-link"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.dns_zones[each.key].name
  virtual_network_id    = azurerm_virtual_network.vnet.id
  registration_enabled  = lookup(each.value, "registration_enabled", false)

  tags = var.tags
}

# Local variables for flattening NSG rules
locals {
  nsg_rules = flatten([
    for nsg_key, nsg in var.network_security_groups : [
      for rule_idx, rule in lookup(nsg, "rules", []) : merge(rule, {
        key     = "${nsg_key}-${rule.name}"
        nsg_key = nsg_key
      })
    ]
  ])
}
