# Log Analytics Workspace
resource "azurerm_log_analytics_workspace" "log_analytics" {
  name                = var.log_analytics_workspace_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = var.log_analytics_sku
  retention_in_days   = var.retention_in_days

  daily_quota_gb = var.daily_quota_gb

  tags = var.tags
}

# Application Insights
resource "azurerm_application_insights" "app_insights" {
  name                = var.application_insights_name
  location            = var.location
  resource_group_name = var.resource_group_name
  workspace_id        = azurerm_log_analytics_workspace.log_analytics.id
  application_type    = var.application_type

  retention_in_days         = var.app_insights_retention_in_days
  daily_data_cap_in_gb      = var.app_insights_daily_data_cap
  daily_data_cap_notifications_disabled = var.disable_daily_cap_notifications

  tags = var.tags
}

# Action Group for Alerts
resource "azurerm_monitor_action_group" "action_groups" {
  for_each = var.action_groups

  name                = each.value.name
  resource_group_name = var.resource_group_name
  short_name          = each.value.short_name

  dynamic "email_receiver" {
    for_each = lookup(each.value, "email_receivers", [])
    content {
      name                    = email_receiver.value.name
      email_address           = email_receiver.value.email_address
      use_common_alert_schema = lookup(email_receiver.value, "use_common_alert_schema", true)
    }
  }

  dynamic "sms_receiver" {
    for_each = lookup(each.value, "sms_receivers", [])
    content {
      name         = sms_receiver.value.name
      country_code = sms_receiver.value.country_code
      phone_number = sms_receiver.value.phone_number
    }
  }

  dynamic "webhook_receiver" {
    for_each = lookup(each.value, "webhook_receivers", [])
    content {
      name                    = webhook_receiver.value.name
      service_uri             = webhook_receiver.value.service_uri
      use_common_alert_schema = lookup(webhook_receiver.value, "use_common_alert_schema", true)
    }
  }

  tags = var.tags
}

# Metric Alerts
resource "azurerm_monitor_metric_alert" "metric_alerts" {
  for_each = var.metric_alerts

  name                = each.value.name
  resource_group_name = var.resource_group_name
  scopes              = each.value.scopes
  description         = lookup(each.value, "description", "")
  severity            = lookup(each.value, "severity", 3)
  enabled             = lookup(each.value, "enabled", true)
  frequency           = lookup(each.value, "frequency", "PT1M")
  window_size         = lookup(each.value, "window_size", "PT5M")

  criteria {
    metric_namespace = each.value.metric_namespace
    metric_name      = each.value.metric_name
    aggregation      = each.value.aggregation
    operator         = each.value.operator
    threshold        = each.value.threshold
  }

  action {
    action_group_id = azurerm_monitor_action_group.action_groups[each.value.action_group_key].id
  }

  tags = var.tags
}

# Activity Log Alerts
resource "azurerm_monitor_activity_log_alert" "activity_log_alerts" {
  for_each = var.activity_log_alerts

  name                = each.value.name
  resource_group_name = var.resource_group_name
  scopes              = each.value.scopes
  description         = lookup(each.value, "description", "")
  enabled             = lookup(each.value, "enabled", true)

  criteria {
    category       = each.value.category
    operation_name = lookup(each.value, "operation_name", null)
    resource_type  = lookup(each.value, "resource_type", null)
  }

  action {
    action_group_id = azurerm_monitor_action_group.action_groups[each.value.action_group_key].id
  }

  tags = var.tags
}

# Workbook (for Azure Monitor)
resource "azurerm_application_insights_workbook" "workbooks" {
  for_each = var.workbooks

  name                = each.value.name
  resource_group_name = var.resource_group_name
  location            = var.location
  display_name        = each.value.display_name
  data_json           = each.value.data_json

  tags = var.tags
}
