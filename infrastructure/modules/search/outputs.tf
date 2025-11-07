output "search_id" {
  description = "ID of the Azure AI Search service"
  value       = azurerm_search_service.search.id
}

output "search_name" {
  description = "Name of the Azure AI Search service"
  value       = azurerm_search_service.search.name
}

output "search_endpoint" {
  description = "Endpoint URL of the Azure AI Search service"
  value       = "https://${azurerm_search_service.search.name}.search.windows.net"
}

output "search_primary_key" {
  description = "Primary admin key for the Azure AI Search service"
  value       = azurerm_search_service.search.primary_key
  sensitive   = true
}

output "search_secondary_key" {
  description = "Secondary admin key for the Azure AI Search service"
  value       = azurerm_search_service.search.secondary_key
  sensitive   = true
}

output "search_query_keys" {
  description = "Query keys for the Azure AI Search service"
  value       = azurerm_search_service.search.query_keys
  sensitive   = true
}

output "search_identity_principal_id" {
  description = "Principal ID of the system-assigned managed identity"
  value       = try(azurerm_search_service.search.identity[0].principal_id, null)
}

output "search_identity_tenant_id" {
  description = "Tenant ID of the system-assigned managed identity"
  value       = try(azurerm_search_service.search.identity[0].tenant_id, null)
}
