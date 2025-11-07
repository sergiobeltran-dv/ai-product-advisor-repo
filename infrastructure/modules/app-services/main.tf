# App Service Plan
resource "azurerm_service_plan" "app_service_plan" {
  name                = var.app_service_plan_name
  location            = var.location
  resource_group_name = var.resource_group_name
  os_type             = var.os_type
  sku_name            = var.sku_name

  zone_balancing_enabled = var.zone_balancing_enabled

  tags = var.tags
}

# Linux Web App
resource "azurerm_linux_web_app" "web_app" {
  count = var.os_type == "Linux" ? 1 : 0

  name                = var.app_service_name
  location            = var.location
  resource_group_name = var.resource_group_name
  service_plan_id     = azurerm_service_plan.app_service_plan.id

  https_only                    = var.https_only
  public_network_access_enabled = var.public_network_access_enabled

  site_config {
    always_on                         = var.always_on
    http2_enabled                     = var.http2_enabled
    minimum_tls_version               = var.minimum_tls_version
    ftps_state                        = var.ftps_state
    vnet_route_all_enabled            = var.vnet_route_all_enabled
    websockets_enabled                = var.websockets_enabled

    dynamic "application_stack" {
      for_each = var.application_stack != null ? [var.application_stack] : []
      content {
        node_version   = lookup(application_stack.value, "node_version", null)
        python_version = lookup(application_stack.value, "python_version", null)
        dotnet_version = lookup(application_stack.value, "dotnet_version", null)
        java_version   = lookup(application_stack.value, "java_version", null)
      }
    }

    dynamic "cors" {
      for_each = var.cors != null ? [var.cors] : []
      content {
        allowed_origins     = cors.value.allowed_origins
        support_credentials = lookup(cors.value, "support_credentials", false)
      }
    }
  }

  app_settings = var.app_settings

  dynamic "connection_string" {
    for_each = var.connection_strings
    content {
      name  = connection_string.value.name
      type  = connection_string.value.type
      value = connection_string.value.value
    }
  }

  dynamic "identity" {
    for_each = var.identity_type != null ? [1] : []
    content {
      type         = var.identity_type
      identity_ids = var.identity_type == "UserAssigned" || var.identity_type == "SystemAssigned, UserAssigned" ? var.identity_ids : null
    }
  }

  tags = var.tags
}

# Windows Web App
resource "azurerm_windows_web_app" "web_app" {
  count = var.os_type == "Windows" ? 1 : 0

  name                = var.app_service_name
  location            = var.location
  resource_group_name = var.resource_group_name
  service_plan_id     = azurerm_service_plan.app_service_plan.id

  https_only                    = var.https_only
  public_network_access_enabled = var.public_network_access_enabled

  site_config {
    always_on                         = var.always_on
    http2_enabled                     = var.http2_enabled
    minimum_tls_version               = var.minimum_tls_version
    ftps_state                        = var.ftps_state
    vnet_route_all_enabled            = var.vnet_route_all_enabled
    websockets_enabled                = var.websockets_enabled

    dynamic "application_stack" {
      for_each = var.application_stack != null ? [var.application_stack] : []
      content {
        current_stack   = lookup(application_stack.value, "current_stack", null)
        dotnet_version  = lookup(application_stack.value, "dotnet_version", null)
        node_version    = lookup(application_stack.value, "node_version", null)
        python          = lookup(application_stack.value, "python", null)
        java_version    = lookup(application_stack.value, "java_version", null)
      }
    }

    dynamic "cors" {
      for_each = var.cors != null ? [var.cors] : []
      content {
        allowed_origins     = cors.value.allowed_origins
        support_credentials = lookup(cors.value, "support_credentials", false)
      }
    }
  }

  app_settings = var.app_settings

  dynamic "connection_string" {
    for_each = var.connection_strings
    content {
      name  = connection_string.value.name
      type  = connection_string.value.type
      value = connection_string.value.value
    }
  }

  dynamic "identity" {
    for_each = var.identity_type != null ? [1] : []
    content {
      type         = var.identity_type
      identity_ids = var.identity_type == "UserAssigned" || var.identity_type == "SystemAssigned, UserAssigned" ? var.identity_ids : null
    }
  }

  tags = var.tags
}

# VNet Integration
resource "azurerm_app_service_virtual_network_swift_connection" "vnet_integration" {
  app_service_id = var.os_type == "Linux" ? azurerm_linux_web_app.web_app[0].id : azurerm_windows_web_app.web_app[0].id
  subnet_id      = var.vnet_integration_subnet_id
}

# Diagnostic Settings
resource "azurerm_monitor_diagnostic_setting" "app_service_diagnostics" {
  name                       = "${var.app_service_name}-diagnostics"
  target_resource_id         = var.os_type == "Linux" ? azurerm_linux_web_app.web_app[0].id : azurerm_windows_web_app.web_app[0].id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  enabled_log {
    category = "AppServiceHTTPLogs"
  }

  enabled_log {
    category = "AppServiceConsoleLogs"
  }

  enabled_log {
    category = "AppServiceAppLogs"
  }

  metric {
    category = "AllMetrics"
    enabled  = true
  }
}
