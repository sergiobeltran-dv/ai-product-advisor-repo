variable "search_service_name" {
  description = "Name of the Azure AI Search service"
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

variable "sku" {
  description = "SKU for Azure AI Search (free, basic, standard, standard2, standard3, storage_optimized_l1, storage_optimized_l2)"
  type        = string
  default     = "standard"
}

variable "replica_count" {
  description = "Number of replicas for the search service"
  type        = number
  default     = 1
}

variable "partition_count" {
  description = "Number of partitions for the search service"
  type        = number
  default     = 1
}

variable "public_network_access_enabled" {
  description = "Enable public network access to Azure AI Search"
  type        = bool
  default     = false
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
