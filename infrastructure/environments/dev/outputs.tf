# Resource Group Outputs
output "resource_group_name" {
  description = "Name of the resource group"
  value       = azurerm_resource_group.main.name
}

output "resource_group_id" {
  description = "ID of the resource group"
  value       = azurerm_resource_group.main.id
}

# Networking Outputs
output "vnet_id" {
  description = "ID of the Virtual Network"
  value       = module.networking.vnet_id
}

output "subnet_ids" {
  description = "Map of subnet IDs"
  value       = module.networking.subnet_ids
}

# Monitoring Outputs
output "log_analytics_workspace_id" {
  description = "ID of the Log Analytics Workspace"
  value       = module.monitoring.log_analytics_workspace_id
}

output "application_insights_instrumentation_key" {
  description = "Application Insights Instrumentation Key"
  value       = module.monitoring.application_insights_instrumentation_key
  sensitive   = true
}

output "application_insights_connection_string" {
  description = "Application Insights Connection String"
  value       = module.monitoring.application_insights_connection_string
  sensitive   = true
}

# Azure OpenAI Outputs
output "openai_endpoint" {
  description = "Azure OpenAI endpoint URL"
  value       = module.openai.openai_endpoint
}

output "openai_id" {
  description = "Azure OpenAI account ID"
  value       = module.openai.openai_id
}

# Azure AI Search Outputs
output "search_endpoint" {
  description = "Azure AI Search endpoint URL"
  value       = module.search.search_endpoint
}

output "search_id" {
  description = "Azure AI Search service ID"
  value       = module.search.search_id
}

# Cosmos DB Outputs
output "cosmos_endpoint" {
  description = "Cosmos DB endpoint URL"
  value       = module.cosmos.cosmos_endpoint
}

output "cosmos_id" {
  description = "Cosmos DB account ID"
  value       = module.cosmos.cosmos_id
}

# Redis Cache Outputs
output "redis_hostname" {
  description = "Redis Cache hostname"
  value       = module.redis.redis_hostname
}

output "redis_id" {
  description = "Redis Cache ID"
  value       = module.redis.redis_id
}

# App Service Outputs
output "app_service_default_hostname" {
  description = "App Service default hostname"
  value       = module.app_service.app_service_default_hostname
}

output "app_service_id" {
  description = "App Service ID"
  value       = module.app_service.app_service_id
}

# Function App Outputs
output "function_app_default_hostname" {
  description = "Function App default hostname"
  value       = module.function_app.function_app_default_hostname
}

output "function_app_id" {
  description = "Function App ID"
  value       = module.function_app.function_app_id
}

# Storage Outputs
output "storage_account_names" {
  description = "Map of storage account names"
  value       = module.storage.storage_account_names
}

# Fabric Outputs
output "fabric_workspace_name" {
  description = "Fabric workspace name"
  value       = module.fabric.workspace_name
}

output "fabric_lakehouse_name" {
  description = "Fabric lakehouse name"
  value       = module.fabric.lakehouse_name
}

output "fabric_setup_notes" {
  description = "Fabric setup notes"
  value       = module.fabric.notes
}

# Private Endpoint Outputs
output "private_endpoint_ids" {
  description = "Map of private endpoint IDs"
  value       = module.private_endpoints.private_endpoint_ids
}

# Managed Identity Outputs
output "managed_identity_ids" {
  description = "Map of managed identity IDs"
  value       = module.identity.managed_identity_ids
}

output "managed_identity_principal_ids" {
  description = "Map of managed identity principal IDs"
  value       = module.identity.managed_identity_principal_ids
}
