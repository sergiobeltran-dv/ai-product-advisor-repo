# Public IP for Azure Firewall
resource "azurerm_public_ip" "firewall_pip" {
  count = var.enable_firewall ? 1 : 0

  name                = var.firewall_public_ip_name
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = var.tags
}

# Azure Firewall
resource "azurerm_firewall" "firewall" {
  count = var.enable_firewall ? 1 : 0

  name                = var.firewall_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku_name            = var.firewall_sku_name
  sku_tier            = var.firewall_sku_tier
  firewall_policy_id  = var.enable_firewall_policy ? azurerm_firewall_policy.policy[0].id : null

  ip_configuration {
    name                 = "configuration"
    subnet_id            = var.firewall_subnet_id
    public_ip_address_id = azurerm_public_ip.firewall_pip[0].id
  }

  tags = var.tags
}

# Firewall Policy
resource "azurerm_firewall_policy" "policy" {
  count = var.enable_firewall && var.enable_firewall_policy ? 1 : 0

  name                = "${var.firewall_name}-policy"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = var.firewall_sku_tier

  tags = var.tags
}

# Public IP for VPN Gateway
resource "azurerm_public_ip" "vpn_gateway_pip" {
  count = var.enable_vpn_gateway ? 1 : 0

  name                = var.vpn_gateway_public_ip_name
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = var.tags
}

# VPN Gateway
resource "azurerm_virtual_network_gateway" "vpn_gateway" {
  count = var.enable_vpn_gateway ? 1 : 0

  name                = var.vpn_gateway_name
  location            = var.location
  resource_group_name = var.resource_group_name

  type     = "Vpn"
  vpn_type = var.vpn_type

  active_active = var.vpn_active_active
  enable_bgp    = var.vpn_enable_bgp
  sku           = var.vpn_gateway_sku

  ip_configuration {
    name                          = "vnetGatewayConfig"
    public_ip_address_id          = azurerm_public_ip.vpn_gateway_pip[0].id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = var.vpn_gateway_subnet_id
  }

  dynamic "vpn_client_configuration" {
    for_each = var.vpn_client_configuration != null ? [var.vpn_client_configuration] : []
    content {
      address_space = vpn_client_configuration.value.address_space

      dynamic "root_certificate" {
        for_each = lookup(vpn_client_configuration.value, "root_certificates", [])
        content {
          name             = root_certificate.value.name
          public_cert_data = root_certificate.value.public_cert_data
        }
      }

      dynamic "revoked_certificate" {
        for_each = lookup(vpn_client_configuration.value, "revoked_certificates", [])
        content {
          name       = revoked_certificate.value.name
          thumbprint = revoked_certificate.value.thumbprint
        }
      }
    }
  }

  tags = var.tags
}

# NAT Gateway Public IP
resource "azurerm_public_ip" "nat_gateway_pip" {
  count = var.enable_nat_gateway ? 1 : 0

  name                = var.nat_gateway_public_ip_name
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = var.tags
}

# NAT Gateway
resource "azurerm_nat_gateway" "nat_gateway" {
  count = var.enable_nat_gateway ? 1 : 0

  name                    = var.nat_gateway_name
  location                = var.location
  resource_group_name     = var.resource_group_name
  sku_name                = "Standard"
  idle_timeout_in_minutes = var.nat_gateway_idle_timeout

  tags = var.tags
}

# Associate Public IP with NAT Gateway
resource "azurerm_nat_gateway_public_ip_association" "nat_pip_association" {
  count = var.enable_nat_gateway ? 1 : 0

  nat_gateway_id       = azurerm_nat_gateway.nat_gateway[0].id
  public_ip_address_id = azurerm_public_ip.nat_gateway_pip[0].id
}

# Associate NAT Gateway with Subnets
resource "azurerm_subnet_nat_gateway_association" "nat_subnet_association" {
  for_each = var.enable_nat_gateway ? var.nat_gateway_subnet_ids : {}

  subnet_id      = each.value
  nat_gateway_id = azurerm_nat_gateway.nat_gateway[0].id
}
