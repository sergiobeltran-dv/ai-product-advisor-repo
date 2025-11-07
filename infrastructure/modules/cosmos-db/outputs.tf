output "cosmos_id" {
  description = "ID of the Cosmos DB account"
  value       = azurerm_cosmosdb_account.cosmos.id
}

output "cosmos_name" {
  description = "Name of the Cosmos DB account"
  value       = azurerm_cosmosdb_account.cosmos.name
}

output "cosmos_endpoint" {
  description = "Endpoint URL of the Cosmos DB account"
  value       = azurerm_cosmosdb_account.cosmos.endpoint
}

output "cosmos_primary_key" {
  description = "Primary master key for the Cosmos DB account"
  value       = azurerm_cosmosdb_account.cosmos.primary_key
  sensitive   = true
}

output "cosmos_secondary_key" {
  description = "Secondary master key for the Cosmos DB account"
  value       = azurerm_cosmosdb_account.cosmos.secondary_key
  sensitive   = true
}

output "cosmos_primary_readonly_key" {
  description = "Primary read-only key for the Cosmos DB account"
  value       = azurerm_cosmosdb_account.cosmos.primary_readonly_key
  sensitive   = true
}

output "cosmos_secondary_readonly_key" {
  description = "Secondary read-only key for the Cosmos DB account"
  value       = azurerm_cosmosdb_account.cosmos.secondary_readonly_key
  sensitive   = true
}

output "cosmos_connection_strings" {
  description = "Connection strings for the Cosmos DB account"
  value       = azurerm_cosmosdb_account.cosmos.connection_strings
  sensitive   = true
}

output "cosmos_identity_principal_id" {
  description = "Principal ID of the system-assigned managed identity"
  value       = try(azurerm_cosmosdb_account.cosmos.identity[0].principal_id, null)
}

output "database_ids" {
  description = "Map of database keys to their IDs"
  value = {
    for key, db in azurerm_cosmosdb_sql_database.databases : key => db.id
  }
}

output "container_ids" {
  description = "Map of container keys to their IDs"
  value = {
    for key, container in azurerm_cosmosdb_sql_container.containers : key => container.id
  }
}
