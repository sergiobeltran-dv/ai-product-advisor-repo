output "key_vault_id" {
  description = "ID of the Key Vault"
  value       = azurerm_key_vault.key_vault.id
}

output "key_vault_name" {
  description = "Name of the Key Vault"
  value       = azurerm_key_vault.key_vault.name
}

output "key_vault_uri" {
  description = "URI of the Key Vault"
  value       = azurerm_key_vault.key_vault.vault_uri
}

output "key_vault_tenant_id" {
  description = "Tenant ID of the Key Vault"
  value       = azurerm_key_vault.key_vault.tenant_id
}

output "secret_ids" {
  description = "Map of secret names to their IDs"
  value = {
    for key, secret in azurerm_key_vault_secret.secrets : key => secret.id
  }
}

output "secret_versions" {
  description = "Map of secret names to their version IDs"
  value = {
    for key, secret in azurerm_key_vault_secret.secrets : key => secret.version
  }
}

output "key_ids" {
  description = "Map of key names to their IDs"
  value = {
    for key, kvkey in azurerm_key_vault_key.keys : key => kvkey.id
  }
}
