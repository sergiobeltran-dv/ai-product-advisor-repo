variable "redis_name" {
  description = "Name of the Azure Cache for Redis"
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

variable "capacity" {
  description = "Capacity of the Redis cache"
  type        = number
  default     = 1
}

variable "family" {
  description = "Family of the Redis cache (C for Basic/Standard, P for Premium)"
  type        = string
  default     = "C"
}

variable "sku_name" {
  description = "SKU name for Redis (Basic, Standard, Premium)"
  type        = string
  default     = "Standard"
}

variable "enable_non_ssl_port" {
  description = "Enable non-SSL port (6379)"
  type        = bool
  default     = false
}

variable "minimum_tls_version" {
  description = "Minimum TLS version (1.0, 1.1, 1.2)"
  type        = string
  default     = "1.2"
}

variable "public_network_access_enabled" {
  description = "Enable public network access"
  type        = bool
  default     = false
}

variable "redis_version" {
  description = "Redis version (4 or 6)"
  type        = string
  default     = "6"
}

variable "redis_configuration" {
  description = "Redis configuration settings"
  type = object({
    enable_authentication           = optional(bool, true)
    maxmemory_policy               = optional(string, "volatile-lru")
    maxmemory_reserved             = optional(number)
    maxmemory_delta                = optional(number)
    maxfragmentationmemory_reserved = optional(number)
    rdb_backup_enabled             = optional(bool, false)
    rdb_backup_frequency           = optional(number)
    rdb_backup_max_snapshot_count  = optional(number)
    rdb_storage_connection_string  = optional(string)
    aof_backup_enabled             = optional(bool, false)
    aof_storage_connection_string_0 = optional(string)
    aof_storage_connection_string_1 = optional(string)
  })
  default = null
}

variable "patch_schedule" {
  description = "Patch schedule configuration"
  type = object({
    day_of_week        = string
    start_hour_utc     = optional(number, 0)
    maintenance_window = optional(string, "PT5H")
  })
  default = null
}

variable "identity_type" {
  description = "Type of Managed Identity (SystemAssigned, UserAssigned)"
  type        = string
  default     = null
}

variable "identity_ids" {
  description = "List of User Assigned Identity IDs"
  type        = list(string)
  default     = []
}

variable "zones" {
  description = "List of availability zones"
  type        = list(string)
  default     = null
}

variable "firewall_rules" {
  description = "Map of firewall rules"
  type = map(object({
    name     = string
    start_ip = string
    end_ip   = string
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
