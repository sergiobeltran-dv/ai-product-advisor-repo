variable "cosmos_account_name" {
  description = "Name of the Cosmos DB account"
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

variable "kind" {
  description = "Kind of Cosmos DB (GlobalDocumentDB, MongoDB, Parse)"
  type        = string
  default     = "GlobalDocumentDB"
}

variable "consistency_level" {
  description = "Consistency level (BoundedStaleness, Eventual, Session, Strong, ConsistentPrefix)"
  type        = string
  default     = "Session"
}

variable "max_interval_in_seconds" {
  description = "Max interval in seconds for BoundedStaleness"
  type        = number
  default     = 5
}

variable "max_staleness_prefix" {
  description = "Max staleness prefix for BoundedStaleness"
  type        = number
  default     = 100
}

variable "additional_geo_locations" {
  description = "List of additional geo locations for Cosmos DB"
  type = list(object({
    location          = string
    failover_priority = number
  }))
  default = []
}

variable "public_network_access_enabled" {
  description = "Enable public network access to Cosmos DB"
  type        = bool
  default     = false
}

variable "is_virtual_network_filter_enabled" {
  description = "Enable virtual network filter"
  type        = bool
  default     = false
}

variable "virtual_network_subnet_ids" {
  description = "List of subnet IDs for virtual network rules"
  type        = list(string)
  default     = []
}

variable "ip_range_filter" {
  description = "IP range filter for Cosmos DB"
  type        = string
  default     = ""
}

variable "enable_automatic_failover" {
  description = "Enable automatic failover"
  type        = bool
  default     = false
}

variable "enable_multiple_write_locations" {
  description = "Enable multiple write locations"
  type        = bool
  default     = false
}

variable "capabilities" {
  description = "List of capabilities to enable (e.g., EnableServerless, EnableTable)"
  type        = list(string)
  default     = []
}

variable "backup_policy" {
  description = "Backup policy configuration"
  type = object({
    type                = string
    interval_in_minutes = optional(number)
    retention_in_hours  = optional(number)
    storage_redundancy  = optional(string, "Geo")
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

variable "sql_databases" {
  description = "Map of SQL databases to create"
  type = map(object({
    name       = string
    throughput = optional(number)
    autoscale_settings = optional(object({
      max_throughput = number
    }))
    containers = optional(list(object({
      name                  = string
      partition_key_paths   = list(string)
      partition_key_version = optional(number, 1)
      throughput            = optional(number)
      autoscale_settings = optional(object({
        max_throughput = number
      }))
      indexing_policy = optional(object({
        indexing_mode   = optional(string, "consistent")
        included_paths  = optional(list(string), [])
        excluded_paths  = optional(list(string), [])
      }))
      default_ttl = optional(number)
    })), [])
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
