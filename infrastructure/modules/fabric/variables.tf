variable "location" {
  description = "Azure region for resources"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "use_existing_capacity" {
  description = "Use existing Fabric Capacity instead of creating new"
  type        = bool
  default     = true
}

variable "capacity_name" {
  description = "Name of the Fabric Capacity"
  type        = string
}

variable "sku_name" {
  description = "SKU for Fabric Capacity (F2, F4, F8, F16, F32, F64, F128, F256, F512, F1024, F2048)"
  type        = string
  default     = "F8"
}

variable "workspace_name" {
  description = "Name of the Fabric Workspace"
  type        = string
}

variable "create_lakehouse" {
  description = "Create Fabric Lakehouse"
  type        = bool
  default     = true
}

variable "lakehouse_name" {
  description = "Name of the Fabric Lakehouse"
  type        = string
  default     = ""
}

variable "data_pipelines" {
  description = "List of Fabric Data Pipelines to create"
  type = list(object({
    name        = string
    description = optional(string, "")
  }))
  default = []
}

variable "generate_setup_script" {
  description = "Generate setup scripts for Fabric resources"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}
