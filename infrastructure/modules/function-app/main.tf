# Storage Account for Function App (required)
resource "azurerm_storage_account" "function_storage" {
  name                     = var.storage_account_name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  
  enable_https_traffic_only       = true
  min_tls_version                 = "TLS1_2"
  allow_nested_items_to_be_public = false

  tags = var.tags
}

# App Service Plan for Function App
resource "azurerm_service_plan" "function_plan" {
  name                = var.function_plan_name
  location            = var.location
  resource_group_name = var.resource_group_name
  os_type             = var.os_type
  sku_name            = var.sku_name

  tags = var.tags
}

# Linux Function App
resource "azurerm_linux_function_app" "function_app" {
  count = var.os_type == "Linux" ? 1 : 0

  name                = var.function_app_name
  location            = var.location
  resource_group_name = var.resource_group_name
  service_plan_id     = azurerm_service_plan.function_plan.id

  storage_account_name       = azurerm_storage_account.function_storage.name
  storage_account_access_key = azurerm_storage_account.function_storage.primary_access_key

  https_only                    = var.https_only
  public_network_access_enabled = var.public_network_access_enabled

  site_config {
    always_on                         = var.always_on
    http2_enabled                     = var.http2_enabled
    minimum_tls_version               = var.minimum_tls_version
    ftps_state                        = var.ftps_state
    vnet_route_all_enabled            = var.vnet_route_all_enabled
    application_insights_key          = var.application_insights_instrumentation_key
    application_insights_connection_string = var.application_insights_connection_string

    dynamic "application_stack" {
      for_each = var.application_stack != null ? [var.application_stack] : []
      content {
        node_version    = lookup(application_stack.value, "node_version", null)
        dotnet_version  = lookup(application_stack.value, "dotnet_version", null)
        java_version    = lookup(application_stack.value, "java_version", null)
        use_custom_runtime = lookup(application_stack.value, "use_custom_runtime", false)
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

  app_settings = merge(
    var.app_settings,
    {
      "FUNCTIONS_WORKER_RUNTIME" = var.functions_worker_runtime
    }
  )

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

# Windows Function App
resource "azurerm_windows_function_app" "function_app" {
  count = var.os_type == "Windows" ? 1 : 0

  name                = var.function_app_name
  location            = var.location
  resource_group_name = var.resource_group_name
  service_plan_id     = azurerm_service_plan.function_plan.id

  storage_account_name       = azurerm_storage_account.function_storage.name
  storage_account_access_key = azurerm_storage_account.function_storage.primary_access_key

  https_only                    = var.https_only
  public_network_access_enabled = var.public_network_access_enabled

  site_config {
    always_on                         = var.always_on
    http2_enabled                     = var.http2_enabled
    minimum_tls_version               = var.minimum_tls_version
    ftps_state                        = var.ftps_state
    vnet_route_all_enabled            = var.vnet_route_all_enabled
    application_insights_key          = var.application_insights_instrumentation_key
    application_insights_connection_string = var.application_insights_connection_string

    dynamic "application_stack" {
      for_each = var.application_stack != null ? [var.application_stack] : []
      content {
        node_version    = lookup(application_stack.value, "node_version", null)
        dotnet_version  = lookup(application_stack.value, "dotnet_version", null)
        java_version    = lookup(application_stack.value, "java_version", null)
        use_custom_runtime = lookup(application_stack.value, "use_custom_runtime", false)
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

  app_settings = merge(
    var.app_settings,
    {
      "FUNCTIONS_WORKER_RUNTIME" = var.functions_worker_runtime
    }
  )

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
  app_service_id = var.os_type == "Linux" ? azurerm_linux_function_app.function_app[0].id : azurerm_windows_function_app.function_app[0].id
  subnet_id      = var.vnet_integration_subnet_id
}

# Diagnostic Settings
resource "azurerm_monitor_diagnostic_setting" "function_app_diagnostics" {
  name                       = "${var.function_app_name}-diagnostics"
  target_resource_id         = var.os_type == "Linux" ? azurerm_linux_function_app.function_app[0].id : azurerm_windows_function_app.function_app[0].id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  enabled_log {
    category = "FunctionAppLogs"
  }

  metric {
    category = "AllMetrics"
    enabled  = true
  }
}
