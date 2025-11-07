variable "location" {
  description = "Azure region for resources"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "private_endpoints" {
  description = "Map of private endpoints to create"
  type = map(object({
    name                           = string
    subnet_id                      = string
    private_connection_resource_id = string
    is_manual_connection           = optional(bool, false)
    subresource_names              = optional(list(string), [])
    request_message                = optional(string)
    private_dns_zone_ids           = optional(list(string))
  }))
  default = {}
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}
