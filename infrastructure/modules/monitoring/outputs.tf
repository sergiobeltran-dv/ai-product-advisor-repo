output "log_analytics_workspace_id" {
  description = "ID of the Log Analytics Workspace"
  value       = azurerm_log_analytics_workspace.log_analytics.id
}

output "log_analytics_workspace_name" {
  description = "Name of the Log Analytics Workspace"
  value       = azurerm_log_analytics_workspace.log_analytics.name
}

output "log_analytics_workspace_workspace_id" {
  description = "Workspace ID (GUID) of the Log Analytics Workspace"
  value       = azurerm_log_analytics_workspace.log_analytics.workspace_id
}

output "log_analytics_workspace_primary_shared_key" {
  description = "Primary shared key for the Log Analytics Workspace"
  value       = azurerm_log_analytics_workspace.log_analytics.primary_shared_key
  sensitive   = true
}

output "application_insights_id" {
  description = "ID of the Application Insights instance"
  value       = azurerm_application_insights.app_insights.id
}

output "application_insights_name" {
  description = "Name of the Application Insights instance"
  value       = azurerm_application_insights.app_insights.name
}

output "application_insights_instrumentation_key" {
  description = "Instrumentation key for Application Insights"
  value       = azurerm_application_insights.app_insights.instrumentation_key
  sensitive   = true
}

output "application_insights_connection_string" {
  description = "Connection string for Application Insights"
  value       = azurerm_application_insights.app_insights.connection_string
  sensitive   = true
}

output "application_insights_app_id" {
  description = "App ID of the Application Insights instance"
  value       = azurerm_application_insights.app_insights.app_id
}

output "action_group_ids" {
  description = "Map of action group keys to their IDs"
  value = {
    for key, ag in azurerm_monitor_action_group.action_groups : key => ag.id
  }
}

output "metric_alert_ids" {
  description = "Map of metric alert keys to their IDs"
  value = {
    for key, alert in azurerm_monitor_metric_alert.metric_alerts : key => alert.id
  }
}

output "activity_log_alert_ids" {
  description = "Map of activity log alert keys to their IDs"
  value = {
    for key, alert in azurerm_monitor_activity_log_alert.activity_log_alerts : key => alert.id
  }
}

output "workbook_ids" {
  description = "Map of workbook keys to their IDs"
  value = {
    for key, workbook in azurerm_application_insights_workbook.workbooks : key => workbook.id
  }
}
