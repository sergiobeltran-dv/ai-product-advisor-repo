# Azure OpenAI Account
resource "azurerm_cognitive_account" "openai" {
  name                  = var.openai_account_name
  location              = var.location
  resource_group_name   = var.resource_group_name
  kind                  = "OpenAI"
  sku_name              = var.sku_name
  custom_subdomain_name = var.custom_subdomain_name

  public_network_access_enabled = var.public_network_access_enabled

  dynamic "network_acls" {
    for_each = var.network_acls != null ? [var.network_acls] : []
    content {
      default_action = network_acls.value.default_action
      ip_rules       = lookup(network_acls.value, "ip_rules", [])
      
      dynamic "virtual_network_rules" {
        for_each = lookup(network_acls.value, "virtual_network_subnet_ids", [])
        content {
          subnet_id = virtual_network_rules.value
        }
      }
    }
  }

  dynamic "identity" {
    for_each = var.identity_type != null ? [1] : []
    content {
      type         = var.identity_type
      identity_ids = var.identity_type == "UserAssigned" ? var.identity_ids : null
    }
  }

  tags = var.tags
}

# Azure OpenAI Model Deployments
resource "azurerm_cognitive_deployment" "deployments" {
  for_each = var.model_deployments

  name                 = each.value.name
  cognitive_account_id = azurerm_cognitive_account.openai.id

  model {
    format  = each.value.model_format
    name    = each.value.model_name
    version = each.value.model_version
  }

  scale {
    type     = each.value.scale_type
    capacity = lookup(each.value, "capacity", null)
  }

  rai_policy_name = lookup(each.value, "rai_policy_name", null)
}

# Diagnostic Settings
resource "azurerm_monitor_diagnostic_setting" "openai_diagnostics" {
  name                       = "${var.openai_account_name}-diagnostics"
  target_resource_id         = azurerm_cognitive_account.openai.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  enabled_log {
    category = "Audit"
  }

  enabled_log {
    category = "RequestResponse"
  }

  metric {
    category = "AllMetrics"
    enabled  = true
  }
}
