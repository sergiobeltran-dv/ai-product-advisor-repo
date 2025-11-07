output "openai_id" {
  description = "ID of the Azure OpenAI account"
  value       = azurerm_cognitive_account.openai.id
}

output "openai_name" {
  description = "Name of the Azure OpenAI account"
  value       = azurerm_cognitive_account.openai.name
}

output "openai_endpoint" {
  description = "Endpoint URL of the Azure OpenAI account"
  value       = azurerm_cognitive_account.openai.endpoint
}

output "openai_primary_access_key" {
  description = "Primary access key for the Azure OpenAI account"
  value       = azurerm_cognitive_account.openai.primary_access_key
  sensitive   = true
}

output "openai_secondary_access_key" {
  description = "Secondary access key for the Azure OpenAI account"
  value       = azurerm_cognitive_account.openai.secondary_access_key
  sensitive   = true
}

output "openai_identity_principal_id" {
  description = "Principal ID of the system-assigned managed identity"
  value       = try(azurerm_cognitive_account.openai.identity[0].principal_id, null)
}

output "openai_identity_tenant_id" {
  description = "Tenant ID of the system-assigned managed identity"
  value       = try(azurerm_cognitive_account.openai.identity[0].tenant_id, null)
}

output "deployment_ids" {
  description = "Map of model deployment names to their IDs"
  value = {
    for key, deployment in azurerm_cognitive_deployment.deployments : key => deployment.id
  }
}

output "deployment_names" {
  description = "Map of deployment keys to their names"
  value = {
    for key, deployment in azurerm_cognitive_deployment.deployments : key => deployment.name
  }
}
