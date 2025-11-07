variable "openai_account_name" {
  description = "Name of the Azure OpenAI account"
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

variable "sku_name" {
  description = "SKU name for Azure OpenAI (S0)"
  type        = string
  default     = "S0"
}

variable "custom_subdomain_name" {
  description = "Custom subdomain name for the OpenAI account"
  type        = string
  default     = null
}

variable "public_network_access_enabled" {
  description = "Enable public network access to Azure OpenAI"
  type        = bool
  default     = false
}

variable "network_acls" {
  description = "Network ACLs for Azure OpenAI"
  type = object({
    default_action             = string
    ip_rules                   = optional(list(string), [])
    virtual_network_subnet_ids = optional(list(string), [])
  })
  default = null
}

variable "identity_type" {
  description = "Type of Managed Identity (SystemAssigned, UserAssigned, or SystemAssigned, UserAssigned)"
  type        = string
  default     = "SystemAssigned"
}

variable "identity_ids" {
  description = "List of User Assigned Identity IDs"
  type        = list(string)
  default     = []
}

variable "model_deployments" {
  description = "Map of model deployments to create"
  type = map(object({
    name           = string
    model_format   = string
    model_name     = string
    model_version  = string
    scale_type     = string
    capacity       = optional(number)
    rai_policy_name = optional(string)
  }))
  default = {}
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
