variable "location" {
  description = "Azure region for resources"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

# Azure Firewall Variables
variable "enable_firewall" {
  description = "Enable Azure Firewall"
  type        = bool
  default     = false
}

variable "firewall_name" {
  description = "Name of the Azure Firewall"
  type        = string
  default     = ""
}

variable "firewall_public_ip_name" {
  description = "Name of the Firewall Public IP"
  type        = string
  default     = ""
}

variable "firewall_subnet_id" {
  description = "ID of the subnet for Azure Firewall (must be named AzureFirewallSubnet)"
  type        = string
  default     = ""
}

variable "firewall_sku_name" {
  description = "SKU name for Azure Firewall"
  type        = string
  default     = "AZFW_VNet"
}

variable "firewall_sku_tier" {
  description = "SKU tier for Azure Firewall (Standard or Premium)"
  type        = string
  default     = "Standard"
}

variable "enable_firewall_policy" {
  description = "Enable Firewall Policy"
  type        = bool
  default     = true
}

# VPN Gateway Variables
variable "enable_vpn_gateway" {
  description = "Enable VPN Gateway"
  type        = bool
  default     = false
}

variable "vpn_gateway_name" {
  description = "Name of the VPN Gateway"
  type        = string
  default     = ""
}

variable "vpn_gateway_public_ip_name" {
  description = "Name of the VPN Gateway Public IP"
  type        = string
  default     = ""
}

variable "vpn_gateway_subnet_id" {
  description = "ID of the subnet for VPN Gateway (must be named GatewaySubnet)"
  type        = string
  default     = ""
}

variable "vpn_gateway_sku" {
  description = "SKU for VPN Gateway (VpnGw1, VpnGw2, VpnGw3, etc.)"
  type        = string
  default     = "VpnGw1"
}

variable "vpn_type" {
  description = "VPN type (RouteBased or PolicyBased)"
  type        = string
  default     = "RouteBased"
}

variable "vpn_active_active" {
  description = "Enable active-active mode for VPN Gateway"
  type        = bool
  default     = false
}

variable "vpn_enable_bgp" {
  description = "Enable BGP for VPN Gateway"
  type        = bool
  default     = false
}

variable "vpn_client_configuration" {
  description = "VPN Client configuration for Point-to-Site VPN"
  type = object({
    address_space = list(string)
    root_certificates = optional(list(object({
      name             = string
      public_cert_data = string
    })), [])
    revoked_certificates = optional(list(object({
      name       = string
      thumbprint = string
    })), [])
  })
  default = null
}

# NAT Gateway Variables
variable "enable_nat_gateway" {
  description = "Enable NAT Gateway"
  type        = bool
  default     = false
}

variable "nat_gateway_name" {
  description = "Name of the NAT Gateway"
  type        = string
  default     = ""
}

variable "nat_gateway_public_ip_name" {
  description = "Name of the NAT Gateway Public IP"
  type        = string
  default     = ""
}

variable "nat_gateway_idle_timeout" {
  description = "Idle timeout in minutes for NAT Gateway"
  type        = number
  default     = 4
}

variable "nat_gateway_subnet_ids" {
  description = "Map of subnet IDs to associate with NAT Gateway"
  type        = map(string)
  default     = {}
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}
