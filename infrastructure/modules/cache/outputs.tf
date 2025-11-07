output "redis_id" {
  description = "ID of the Azure Cache for Redis"
  value       = azurerm_redis_cache.redis.id
}

output "redis_name" {
  description = "Name of the Azure Cache for Redis"
  value       = azurerm_redis_cache.redis.name
}

output "redis_hostname" {
  description = "Hostname of the Redis cache"
  value       = azurerm_redis_cache.redis.hostname
}

output "redis_ssl_port" {
  description = "SSL port of the Redis cache"
  value       = azurerm_redis_cache.redis.ssl_port
}

output "redis_port" {
  description = "Non-SSL port of the Redis cache"
  value       = azurerm_redis_cache.redis.port
}

output "redis_primary_access_key" {
  description = "Primary access key for the Redis cache"
  value       = azurerm_redis_cache.redis.primary_access_key
  sensitive   = true
}

output "redis_secondary_access_key" {
  description = "Secondary access key for the Redis cache"
  value       = azurerm_redis_cache.redis.secondary_access_key
  sensitive   = true
}

output "redis_primary_connection_string" {
  description = "Primary connection string for the Redis cache"
  value       = azurerm_redis_cache.redis.primary_connection_string
  sensitive   = true
}

output "redis_secondary_connection_string" {
  description = "Secondary connection string for the Redis cache"
  value       = azurerm_redis_cache.redis.secondary_connection_string
  sensitive   = true
}

output "redis_identity_principal_id" {
  description = "Principal ID of the system-assigned managed identity"
  value       = try(azurerm_redis_cache.redis.identity[0].principal_id, null)
}
