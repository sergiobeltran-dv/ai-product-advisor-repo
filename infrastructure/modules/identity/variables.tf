variable "location" {
  description = "Azure region for resources"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "managed_identities" {
  description = "Map of User Assigned Managed Identities to create"
  type = map(object({
    name = string
    role_assignments = optional(list(object({
      scope                = string
      role_definition_name = string
    })), [])
  }))
  default = {}
}

variable "app_registrations" {
  description = "Map of App Registrations to create"
  type = map(object({
    display_name                 = string
    owners                       = optional(list(string), [])
    app_role_assignment_required = optional(bool, false)
    web = optional(object({
      redirect_uris                 = optional(list(string), [])
      access_token_issuance_enabled = optional(bool, false)
      id_token_issuance_enabled     = optional(bool, false)
    }))
    api = optional(object({
      mapped_claims_enabled          = optional(bool, false)
      requested_access_token_version = optional(number, 2)
    }))
    required_resource_access = optional(list(object({
      resource_app_id = string
      resource_access = list(object({
        id   = string
        type = string
      }))
    })), [])
  }))
  default = {}
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}
