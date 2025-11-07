output "function_plan_id" {
  description = "ID of the Function App Service Plan"
  value       = azurerm_service_plan.function_plan.id
}

output "function_plan_name" {
  description = "Name of the Function App Service Plan"
  value       = azurerm_service_plan.function_plan.name
}

output "function_app_id" {
  description = "ID of the Function App"
  value       = var.os_type == "Linux" ? azurerm_linux_function_app.function_app[0].id : azurerm_windows_function_app.function_app[0].id
}

output "function_app_name" {
  description = "Name of the Function App"
  value       = var.os_type == "Linux" ? azurerm_linux_function_app.function_app[0].name : azurerm_windows_function_app.function_app[0].name
}

output "function_app_default_hostname" {
  description = "Default hostname of the Function App"
  value       = var.os_type == "Linux" ? azurerm_linux_function_app.function_app[0].default_hostname : azurerm_windows_function_app.function_app[0].default_hostname
}

output "function_app_outbound_ip_addresses" {
  description = "Outbound IP addresses of the Function App"
  value       = var.os_type == "Linux" ? azurerm_linux_function_app.function_app[0].outbound_ip_addresses : azurerm_windows_function_app.function_app[0].outbound_ip_addresses
}

output "function_app_identity_principal_id" {
  description = "Principal ID of the system-assigned managed identity"
  value       = var.os_type == "Linux" ? try(azurerm_linux_function_app.function_app[0].identity[0].principal_id, null) : try(azurerm_windows_function_app.function_app[0].identity[0].principal_id, null)
}

output "function_app_identity_tenant_id" {
  description = "Tenant ID of the system-assigned managed identity"
  value       = var.os_type == "Linux" ? try(azurerm_linux_function_app.function_app[0].identity[0].tenant_id, null) : try(azurerm_windows_function_app.function_app[0].identity[0].tenant_id, null)
}

output "storage_account_id" {
  description = "ID of the storage account for the Function App"
  value       = azurerm_storage_account.function_storage.id
}

output "storage_account_name" {
  description = "Name of the storage account for the Function App"
  value       = azurerm_storage_account.function_storage.name
}
