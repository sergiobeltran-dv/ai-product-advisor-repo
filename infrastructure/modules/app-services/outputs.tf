output "app_service_plan_id" {
  description = "ID of the App Service Plan"
  value       = azurerm_service_plan.app_service_plan.id
}

output "app_service_plan_name" {
  description = "Name of the App Service Plan"
  value       = azurerm_service_plan.app_service_plan.name
}

output "app_service_id" {
  description = "ID of the App Service"
  value       = var.os_type == "Linux" ? azurerm_linux_web_app.web_app[0].id : azurerm_windows_web_app.web_app[0].id
}

output "app_service_name" {
  description = "Name of the App Service"
  value       = var.os_type == "Linux" ? azurerm_linux_web_app.web_app[0].name : azurerm_windows_web_app.web_app[0].name
}

output "app_service_default_hostname" {
  description = "Default hostname of the App Service"
  value       = var.os_type == "Linux" ? azurerm_linux_web_app.web_app[0].default_hostname : azurerm_windows_web_app.web_app[0].default_hostname
}

output "app_service_outbound_ip_addresses" {
  description = "Outbound IP addresses of the App Service"
  value       = var.os_type == "Linux" ? azurerm_linux_web_app.web_app[0].outbound_ip_addresses : azurerm_windows_web_app.web_app[0].outbound_ip_addresses
}

output "app_service_possible_outbound_ip_addresses" {
  description = "Possible outbound IP addresses of the App Service"
  value       = var.os_type == "Linux" ? azurerm_linux_web_app.web_app[0].possible_outbound_ip_addresses : azurerm_windows_web_app.web_app[0].possible_outbound_ip_addresses
}

output "app_service_identity_principal_id" {
  description = "Principal ID of the system-assigned managed identity"
  value       = var.os_type == "Linux" ? try(azurerm_linux_web_app.web_app[0].identity[0].principal_id, null) : try(azurerm_windows_web_app.web_app[0].identity[0].principal_id, null)
}

output "app_service_identity_tenant_id" {
  description = "Tenant ID of the system-assigned managed identity"
  value       = var.os_type == "Linux" ? try(azurerm_linux_web_app.web_app[0].identity[0].tenant_id, null) : try(azurerm_windows_web_app.web_app[0].identity[0].tenant_id, null)
}
