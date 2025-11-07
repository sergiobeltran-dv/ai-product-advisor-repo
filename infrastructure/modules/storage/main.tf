# Storage Accounts
resource "azurerm_storage_account" "storage_accounts" {
  for_each = var.storage_accounts

  name                     = each.value.name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = each.value.account_tier
  account_replication_type = each.value.account_replication_type
  account_kind             = lookup(each.value, "account_kind", "StorageV2")
  
  # ADLS Gen2 support
  is_hns_enabled = lookup(each.value, "is_hns_enabled", false)
  
  # Security settings
  enable_https_traffic_only       = lookup(each.value, "enable_https_traffic_only", true)
  min_tls_version                 = lookup(each.value, "min_tls_version", "TLS1_2")
  allow_nested_items_to_be_public = lookup(each.value, "allow_nested_items_to_be_public", false)
  
  # Network rules
  public_network_access_enabled = lookup(each.value, "public_network_access_enabled", false)

  dynamic "network_rules" {
    for_each = lookup(each.value, "network_rules", null) != null ? [each.value.network_rules] : []
    content {
      default_action             = network_rules.value.default_action
      bypass                     = lookup(network_rules.value, "bypass", ["AzureServices"])
      ip_rules                   = lookup(network_rules.value, "ip_rules", [])
      virtual_network_subnet_ids = lookup(network_rules.value, "virtual_network_subnet_ids", [])
    }
  }

  # Blob properties
  dynamic "blob_properties" {
    for_each = lookup(each.value, "blob_properties", null) != null ? [each.value.blob_properties] : []
    content {
      versioning_enabled       = lookup(blob_properties.value, "versioning_enabled", false)
      change_feed_enabled      = lookup(blob_properties.value, "change_feed_enabled", false)
      last_access_time_enabled = lookup(blob_properties.value, "last_access_time_enabled", false)

      dynamic "delete_retention_policy" {
        for_each = lookup(blob_properties.value, "delete_retention_policy", null) != null ? [blob_properties.value.delete_retention_policy] : []
        content {
          days = delete_retention_policy.value.days
        }
      }

      dynamic "container_delete_retention_policy" {
        for_each = lookup(blob_properties.value, "container_delete_retention_policy", null) != null ? [blob_properties.value.container_delete_retention_policy] : []
        content {
          days = container_delete_retention_policy.value.days
        }
      }
    }
  }

  tags = var.tags
}

# Blob Containers
resource "azurerm_storage_container" "containers" {
  for_each = { for c in local.containers : c.key => c }

  name                  = each.value.container_name
  storage_account_name  = azurerm_storage_account.storage_accounts[each.value.storage_account_key].name
  container_access_type = lookup(each.value, "container_access_type", "private")
}

# File Shares
resource "azurerm_storage_share" "file_shares" {
  for_each = { for fs in local.file_shares : fs.key => fs }

  name                 = each.value.share_name
  storage_account_name = azurerm_storage_account.storage_accounts[each.value.storage_account_key].name
  quota                = lookup(each.value, "quota", 100)
}

# Data Lake Gen2 Filesystems
resource "azurerm_storage_data_lake_gen2_filesystem" "filesystems" {
  for_each = { for fs in local.data_lake_filesystems : fs.key => fs }

  name               = each.value.filesystem_name
  storage_account_id = azurerm_storage_account.storage_accounts[each.value.storage_account_key].id
}

# Local variables for flattening nested structures
locals {
  containers = flatten([
    for sa_key, sa in var.storage_accounts : [
      for container_idx, container in lookup(sa, "containers", []) : {
        key                   = "${sa_key}-${container.name}"
        storage_account_key   = sa_key
        container_name        = container.name
        container_access_type = lookup(container, "container_access_type", "private")
      }
    ]
  ])

  file_shares = flatten([
    for sa_key, sa in var.storage_accounts : [
      for share_idx, share in lookup(sa, "file_shares", []) : {
        key                 = "${sa_key}-${share.name}"
        storage_account_key = sa_key
        share_name          = share.name
        quota               = lookup(share, "quota", 100)
      }
    ]
  ])

  data_lake_filesystems = flatten([
    for sa_key, sa in var.storage_accounts : [
      for fs_idx, fs in lookup(sa, "data_lake_filesystems", []) : {
        key                 = "${sa_key}-${fs.name}"
        storage_account_key = sa_key
        filesystem_name     = fs.name
      }
    ]
  ])
}
