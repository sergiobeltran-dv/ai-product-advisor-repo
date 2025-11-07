variable "function_plan_name" {
  description = "Name of the Function App Service Plan"
  type        = string
}

variable "function_app_name" {
  description = "Name of the Function App"
  type        = string
}

variable "storage_account_name" {
  description = "Name of the storage account for Function App"
  type        = string
}

variable "location" {
  description = "Azure region for resources"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "os_type" {
  description = "OS type for Function App (Linux or Windows)"
  type        = string
  default     = "Linux"
}

variable "sku_name" {
  description = "SKU name for Function App Plan (Y1 for Consumption, EP1 for Premium, P1v2 for Dedicated)"
  type        = string
  default     = "EP1"
}

variable "https_only" {
  description = "Enable HTTPS only"
  type        = bool
  default     = true
}

variable "public_network_access_enabled" {
  description = "Enable public network access"
  type        = bool
  default     = true
}

variable "always_on" {
  description = "Enable Always On (not available for Consumption plan)"
  type        = bool
  default     = false
}

variable "http2_enabled" {
  description = "Enable HTTP/2"
  type        = bool
  default     = true
}

variable "minimum_tls_version" {
  description = "Minimum TLS version (1.0, 1.1, 1.2)"
  type        = string
  default     = "1.2"
}

variable "ftps_state" {
  description = "FTPS state (Disabled, FtpsOnly, AllAllowed)"
  type        = string
  default     = "Disabled"
}

variable "vnet_route_all_enabled" {
  description = "Route all traffic through VNet"
  type        = bool
  default     = false
}

variable "application_insights_instrumentation_key" {
  description = "Application Insights Instrumentation Key"
  type        = string
  default     = null
  sensitive   = true
}

variable "application_insights_connection_string" {
  description = "Application Insights Connection String"
  type        = string
  default     = null
  sensitive   = true
}

variable "functions_worker_runtime" {
  description = "Functions worker runtime (node, python, dotnet, java)"
  type        = string
  default     = "python"
}

variable "application_stack" {
  description = "Application stack configuration"
  type        = map(string)
  default     = null
}

variable "cors" {
  description = "CORS configuration"
  type = object({
    allowed_origins     = list(string)
    support_credentials = optional(bool, false)
  })
  default = null
}

variable "app_settings" {
  description = "App settings for the Function App"
  type        = map(string)
  default     = {}
}

variable "connection_strings" {
  description = "Connection strings for the Function App"
  type = list(object({
    name  = string
    type  = string
    value = string
  }))
  default   = []
  sensitive = true
}

variable "identity_type" {
  description = "Type of Managed Identity (SystemAssigned, UserAssigned, SystemAssigned, UserAssigned)"
  type        = string
  default     = "SystemAssigned"
}

variable "identity_ids" {
  description = "List of User Assigned Identity IDs"
  type        = list(string)
  default     = []
}

variable "vnet_integration_subnet_id" {
  description = "Subnet ID for VNet integration"
  type        = string
  default     = null
}

variable "log_analytics_workspace_id" {
  description = "Log Analytics Workspace ID for diagnostics"
  type        = string
  default     = null
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}
