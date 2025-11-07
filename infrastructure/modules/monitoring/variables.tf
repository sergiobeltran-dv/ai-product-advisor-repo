variable "location" {
  description = "Azure region for resources"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "log_analytics_workspace_name" {
  description = "Name of the Log Analytics Workspace"
  type        = string
}

variable "log_analytics_sku" {
  description = "SKU for Log Analytics Workspace"
  type        = string
  default     = "PerGB2018"
}

variable "retention_in_days" {
  description = "Retention period in days for Log Analytics"
  type        = number
  default     = 30
}

variable "daily_quota_gb" {
  description = "Daily ingestion quota in GB for Log Analytics"
  type        = number
  default     = -1
}

variable "application_insights_name" {
  description = "Name of the Application Insights instance"
  type        = string
}

variable "application_type" {
  description = "Type of application (web, ios, java, etc.)"
  type        = string
  default     = "web"
}

variable "app_insights_retention_in_days" {
  description = "Retention period in days for Application Insights"
  type        = number
  default     = 90
}

variable "app_insights_daily_data_cap" {
  description = "Daily data cap in GB for Application Insights"
  type        = number
  default     = null
}

variable "disable_daily_cap_notifications" {
  description = "Disable notifications when daily cap is met"
  type        = bool
  default     = false
}

variable "action_groups" {
  description = "Map of action groups to create"
  type = map(object({
    name       = string
    short_name = string
    email_receivers = optional(list(object({
      name                    = string
      email_address           = string
      use_common_alert_schema = optional(bool, true)
    })), [])
    sms_receivers = optional(list(object({
      name         = string
      country_code = string
      phone_number = string
    })), [])
    webhook_receivers = optional(list(object({
      name                    = string
      service_uri             = string
      use_common_alert_schema = optional(bool, true)
    })), [])
  }))
  default = {}
}

variable "metric_alerts" {
  description = "Map of metric alerts to create"
  type = map(object({
    name               = string
    scopes             = list(string)
    description        = optional(string, "")
    severity           = optional(number, 3)
    enabled            = optional(bool, true)
    frequency          = optional(string, "PT1M")
    window_size        = optional(string, "PT5M")
    metric_namespace   = string
    metric_name        = string
    aggregation        = string
    operator           = string
    threshold          = number
    action_group_key   = string
  }))
  default = {}
}

variable "activity_log_alerts" {
  description = "Map of activity log alerts to create"
  type = map(object({
    name             = string
    scopes           = list(string)
    description      = optional(string, "")
    enabled          = optional(bool, true)
    category         = string
    operation_name   = optional(string)
    resource_type    = optional(string)
    action_group_key = string
  }))
  default = {}
}

variable "workbooks" {
  description = "Map of Azure Monitor Workbooks to create"
  type = map(object({
    name         = string
    display_name = string
    data_json    = string
  }))
  default = {}
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}
