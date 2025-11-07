output "storage_account_ids" {
  description = "Map of Storage Account keys to their IDs"
  value = {
    for key, sa in azurerm_storage_account.storage_accounts : key => sa.id
  }
}

output "storage_account_names" {
  description = "Map of Storage Account keys to their names"
  value = {
    for key, sa in azurerm_storage_account.storage_accounts : key => sa.name
  }
}

output "storage_account_primary_blob_endpoints" {
  description = "Map of Storage Account keys to their primary blob endpoints"
  value = {
    for key, sa in azurerm_storage_account.storage_accounts : key => sa.primary_blob_endpoint
  }
}

output "storage_account_primary_access_keys" {
  description = "Map of Storage Account keys to their primary access keys"
  value = {
    for key, sa in azurerm_storage_account.storage_accounts : key => sa.primary_access_key
  }
  sensitive = true
}

output "storage_account_primary_connection_strings" {
  description = "Map of Storage Account keys to their primary connection strings"
  value = {
    for key, sa in azurerm_storage_account.storage_accounts : key => sa.primary_connection_string
  }
  sensitive = true
}

output "container_ids" {
  description = "Map of container keys to their IDs"
  value = {
    for key, container in azurerm_storage_container.containers : key => container.id
  }
}

output "file_share_ids" {
  description = "Map of file share keys to their IDs"
  value = {
    for key, share in azurerm_storage_share.file_shares : key => share.id
  }
}

output "data_lake_filesystem_ids" {
  description = "Map of Data Lake filesystem keys to their IDs"
  value = {
    for key, fs in azurerm_storage_data_lake_gen2_filesystem.filesystems : key => fs.id
  }
}
