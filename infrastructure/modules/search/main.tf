# Azure AI Search Service
resource "azurerm_search_service" "search" {
  name                = var.search_service_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = var.sku
  
  replica_count           = var.replica_count
  partition_count         = var.partition_count
  public_network_access_enabled = var.public_network_access_enabled
  
  dynamic "identity" {
    for_each = var.identity_type != null ? [1] : []
    content {
      type = var.identity_type
    }
  }

  tags = var.tags
}

# Diagnostic Settings
resource "azurerm_monitor_diagnostic_setting" "search_diagnostics" {
  name                       = "${var.search_service_name}-diagnostics"
  target_resource_id         = azurerm_search_service.search.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  enabled_log {
    category = "OperationLogs"
  }

  metric {
    category = "AllMetrics"
    enabled  = true
  }
}
