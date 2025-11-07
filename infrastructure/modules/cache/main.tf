# Azure Cache for Redis
resource "azurerm_redis_cache" "redis" {
  name                = var.redis_name
  location            = var.location
  resource_group_name = var.resource_group_name
  capacity            = var.capacity
  family              = var.family
  sku_name            = var.sku_name
  
  enable_non_ssl_port         = var.enable_non_ssl_port
  minimum_tls_version         = var.minimum_tls_version
  public_network_access_enabled = var.public_network_access_enabled
  
  redis_version = var.redis_version

  dynamic "redis_configuration" {
    for_each = var.redis_configuration != null ? [var.redis_configuration] : []
    content {
      enable_authentication           = lookup(redis_configuration.value, "enable_authentication", true)
      maxmemory_policy               = lookup(redis_configuration.value, "maxmemory_policy", "volatile-lru")
      maxmemory_reserved             = lookup(redis_configuration.value, "maxmemory_reserved", null)
      maxmemory_delta                = lookup(redis_configuration.value, "maxmemory_delta", null)
      maxfragmentationmemory_reserved = lookup(redis_configuration.value, "maxfragmentationmemory_reserved", null)
      rdb_backup_enabled             = lookup(redis_configuration.value, "rdb_backup_enabled", false)
      rdb_backup_frequency           = lookup(redis_configuration.value, "rdb_backup_frequency", null)
      rdb_backup_max_snapshot_count  = lookup(redis_configuration.value, "rdb_backup_max_snapshot_count", null)
      rdb_storage_connection_string  = lookup(redis_configuration.value, "rdb_storage_connection_string", null)
      aof_backup_enabled             = lookup(redis_configuration.value, "aof_backup_enabled", false)
      aof_storage_connection_string_0 = lookup(redis_configuration.value, "aof_storage_connection_string_0", null)
      aof_storage_connection_string_1 = lookup(redis_configuration.value, "aof_storage_connection_string_1", null)
    }
  }

  dynamic "patch_schedule" {
    for_each = var.patch_schedule != null ? [var.patch_schedule] : []
    content {
      day_of_week        = patch_schedule.value.day_of_week
      start_hour_utc     = lookup(patch_schedule.value, "start_hour_utc", 0)
      maintenance_window = lookup(patch_schedule.value, "maintenance_window", "PT5H")
    }
  }

  dynamic "identity" {
    for_each = var.identity_type != null ? [1] : []
    content {
      type         = var.identity_type
      identity_ids = var.identity_type == "UserAssigned" ? var.identity_ids : null
    }
  }

  zones = var.zones

  tags = var.tags
}

# Redis Firewall Rules
resource "azurerm_redis_firewall_rule" "firewall_rules" {
  for_each = var.firewall_rules

  name                = each.value.name
  redis_cache_name    = azurerm_redis_cache.redis.name
  resource_group_name = var.resource_group_name
  start_ip            = each.value.start_ip
  end_ip              = each.value.end_ip
}

# Diagnostic Settings
resource "azurerm_monitor_diagnostic_setting" "redis_diagnostics" {
  name                       = "${var.redis_name}-diagnostics"
  target_resource_id         = azurerm_redis_cache.redis.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  enabled_log {
    category = "ConnectedClientList"
  }

  metric {
    category = "AllMetrics"
    enabled  = true
  }
}
