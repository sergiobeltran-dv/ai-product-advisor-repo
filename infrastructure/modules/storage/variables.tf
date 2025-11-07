variable "location" {
  description = "Azure region for resources"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "storage_accounts" {
  description = "Map of Storage Accounts to create"
  type = map(object({
    name                     = string
    account_tier             = string
    account_replication_type = string
    account_kind             = optional(string, "StorageV2")
    is_hns_enabled           = optional(bool, false)
    enable_https_traffic_only       = optional(bool, true)
    min_tls_version                 = optional(string, "TLS1_2")
    allow_nested_items_to_be_public = optional(bool, false)
    public_network_access_enabled   = optional(bool, false)
    
    network_rules = optional(object({
      default_action             = string
      bypass                     = optional(list(string), ["AzureServices"])
      ip_rules                   = optional(list(string), [])
      virtual_network_subnet_ids = optional(list(string), [])
    }))

    blob_properties = optional(object({
      versioning_enabled       = optional(bool, false)
      change_feed_enabled      = optional(bool, false)
      last_access_time_enabled = optional(bool, false)
      delete_retention_policy = optional(object({
        days = number
      }))
      container_delete_retention_policy = optional(object({
        days = number
      }))
    }))

    containers = optional(list(object({
      name                  = string
      container_access_type = optional(string, "private")
    })), [])

    file_shares = optional(list(object({
      name  = string
      quota = optional(number, 100)
    })), [])

    data_lake_filesystems = optional(list(object({
      name = string
    })), [])
  }))
  default = {}
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}
