# Azure Provider Variables
variable "subscription_id" {
  description = "Azure Subscription ID"
  type        = string
}

variable "tenant_id" {
  description = "Azure AD Tenant ID"
  type        = string
}

# General Variables
variable "environment" {
  description = "Environment name (dev, nonprod, prod)"
  type        = string
  default     = "nonprod"
}

variable "location" {
  description = "Azure region for resources"
  type        = string
  default     = "eastus"
}

variable "project_name" {
  description = "Project name for resource naming"
  type        = string
  default     = "aiproductadvisor"
}

# Networking Variables
variable "vnet_address_space" {
  description = "Address space for the Virtual Network"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "subnet_config" {
  description = "Subnet configuration"
  type = map(object({
    name             = string
    address_prefixes = list(string)
    service_endpoints = optional(list(string), [])
    delegation = optional(object({
      name         = string
      service_name = string
      actions      = optional(list(string), [])
    }))
  }))
}

# Security Variables
variable "enable_firewall" {
  description = "Enable Azure Firewall"
  type        = bool
  default     = false
}

variable "enable_vpn_gateway" {
  description = "Enable VPN Gateway"
  type        = bool
  default     = false
}

variable "vpn_gateway_sku" {
  description = "SKU for VPN Gateway"
  type        = string
  default     = "VpnGw1"
}

# Azure OpenAI Variables
variable "openai_sku" {
  description = "SKU for Azure OpenAI"
  type        = string
  default     = "S0"
}

variable "openai_model_deployments" {
  description = "OpenAI model deployments"
  type = map(object({
    name           = string
    model_format   = string
    model_name     = string
    model_version  = string
    scale_type     = string
    capacity       = optional(number)
  }))
}

# Azure AI Search Variables
variable "search_sku" {
  description = "SKU for Azure AI Search"
  type        = string
  default     = "standard"
}

variable "search_replica_count" {
  description = "Number of replicas for Search"
  type        = number
  default     = 1
}

variable "search_partition_count" {
  description = "Number of partitions for Search"
  type        = number
  default     = 1
}

# Cosmos DB Variables
variable "cosmos_consistency_level" {
  description = "Cosmos DB consistency level"
  type        = string
  default     = "Session"
}

variable "cosmos_databases" {
  description = "Cosmos DB databases configuration"
  type        = any
}

# Redis Cache Variables
variable "redis_sku_name" {
  description = "SKU for Redis Cache"
  type        = string
  default     = "Standard"
}

variable "redis_capacity" {
  description = "Capacity for Redis Cache"
  type        = number
  default     = 1
}

# App Service Variables
variable "app_service_plan_sku" {
  description = "SKU for App Service Plan"
  type        = string
  default     = "P1v2"
}

variable "app_service_os_type" {
  description = "OS type for App Service"
  type        = string
  default     = "Linux"
}

# Function App Variables
variable "function_app_sku" {
  description = "SKU for Function App"
  type        = string
  default     = "EP1"
}

# Fabric Variables
variable "fabric_capacity_name" {
  description = "Name of existing Fabric Capacity"
  type        = string
}

variable "fabric_sku" {
  description = "SKU for Fabric Capacity (F2 is minimum)"
  type        = string
  default     = "F2"
}

# Tags
variable "tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default = {
    environment = "nonprod"
    project     = "ai-product-advisor"
    managed-by  = "terraform"
  }
}
