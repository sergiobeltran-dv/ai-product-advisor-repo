# Private Endpoints Module

## Overview

This module creates Azure Private Endpoints for secure, private connectivity to Azure PaaS services over the Azure backbone network.

## Supported Services

Private endpoints can be created for the following Azure services (subresource names in parentheses):

### AI & Cognitive Services
- **Azure OpenAI** (`account`)
- **Azure AI Search** (`searchService`)

### Data Services
- **Cosmos DB SQL** (`Sql`)
- **Cosmos DB MongoDB** (`MongoDB`)
- **Azure Cache for Redis** (`redisCache`)

### Storage Services
- **Storage Account Blob** (`blob`)
- **Storage Account File** (`file`)
- **Storage Account Table** (`table`)
- **Storage Account Queue** (`queue`)
- **Data Lake Storage Gen2** (`dfs`)

### App Services
- **App Service / Web App** (`sites`)
- **Function App** (`sites`)

### Key Management
- **Key Vault** (`vault`)

### Fabric & Analytics
- **Fabric Lakehouse** (`dfs`) - uses Storage endpoint
- **Fabric Data Pipelines** - typically accessed via Fabric portal

## Usage

```hcl
module "private_endpoints" {
  source = "../../modules/private-endpoints"

  location            = "eastus"
  resource_group_name = "rg-ai-product-advisor"

  private_endpoints = {
    # Azure OpenAI Private Endpoint
    openai = {
      name                           = "pe-openai"
      subnet_id                      = var.private_endpoint_subnet_id
      private_connection_resource_id = var.openai_id
      subresource_names              = ["account"]
      private_dns_zone_ids           = [var.privatelink_openai_dns_zone_id]
    }

    # Azure AI Search Private Endpoint
    search = {
      name                           = "pe-search"
      subnet_id                      = var.private_endpoint_subnet_id
      private_connection_resource_id = var.search_id
      subresource_names              = ["searchService"]
      private_dns_zone_ids           = [var.privatelink_search_dns_zone_id]
    }

    # Cosmos DB Private Endpoint
    cosmos = {
      name                           = "pe-cosmos"
      subnet_id                      = var.private_endpoint_subnet_id
      private_connection_resource_id = var.cosmos_id
      subresource_names              = ["Sql"]
      private_dns_zone_ids           = [var.privatelink_cosmos_dns_zone_id]
    }

    # Redis Cache Private Endpoint
    redis = {
      name                           = "pe-redis"
      subnet_id                      = var.private_endpoint_subnet_id
      private_connection_resource_id = var.redis_id
      subresource_names              = ["redisCache"]
      private_dns_zone_ids           = [var.privatelink_redis_dns_zone_id]
    }

    # Storage Account (Blob) Private Endpoint
    storage_blob = {
      name                           = "pe-storage-blob"
      subnet_id                      = var.private_endpoint_subnet_id
      private_connection_resource_id = var.storage_account_id
      subresource_names              = ["blob"]
      private_dns_zone_ids           = [var.privatelink_blob_dns_zone_id]
    }

    # Storage Account (File) Private Endpoint
    storage_file = {
      name                           = "pe-storage-file"
      subnet_id                      = var.private_endpoint_subnet_id
      private_connection_resource_id = var.storage_account_id
      subresource_names              = ["file"]
      private_dns_zone_ids           = [var.privatelink_file_dns_zone_id]
    }

    # Key Vault Private Endpoint
    keyvault = {
      name                           = "pe-keyvault"
      subnet_id                      = var.private_endpoint_subnet_id
      private_connection_resource_id = var.key_vault_id
      subresource_names              = ["vault"]
      private_dns_zone_ids           = [var.privatelink_keyvault_dns_zone_id]
    }

    # App Service Private Endpoint
    appservice = {
      name                           = "pe-appservice"
      subnet_id                      = var.private_endpoint_subnet_id
      private_connection_resource_id = var.app_service_id
      subresource_names              = ["sites"]
      private_dns_zone_ids           = [var.privatelink_sites_dns_zone_id]
    }

    # Function App Private Endpoint
    function = {
      name                           = "pe-function"
      subnet_id                      = var.private_endpoint_subnet_id
      private_connection_resource_id = var.function_app_id
      subresource_names              = ["sites"]
      private_dns_zone_ids           = [var.privatelink_sites_dns_zone_id]
    }
  }

  tags = {
    environment = "dev"
    project     = "ai-product-advisor"
  }
}
```

## Private DNS Zones

Each private endpoint requires a corresponding Private DNS Zone for name resolution. Common DNS zones:

| Service | Private DNS Zone Name |
|---------|----------------------|
| Azure OpenAI | `privatelink.openai.azure.com` |
| Azure AI Search | `privatelink.search.windows.net` |
| Cosmos DB (SQL) | `privatelink.documents.azure.com` |
| Redis Cache | `privatelink.redis.cache.windows.net` |
| Storage Blob | `privatelink.blob.core.windows.net` |
| Storage File | `privatelink.file.core.windows.net` |
| Storage Table | `privatelink.table.core.windows.net` |
| Storage Queue | `privatelink.queue.core.windows.net` |
| Data Lake Gen2 | `privatelink.dfs.core.windows.net` |
| Key Vault | `privatelink.vaultcore.azure.net` |
| App Service / Functions | `privatelink.azurewebsites.net` |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| location | Azure region | string | - | yes |
| resource_group_name | Resource group name | string | - | yes |
| private_endpoints | Map of private endpoints | map(object) | {} | no |
| tags | Tags to apply | map(string) | {} | no |

## Outputs

| Name | Description |
|------|-------------|
| private_endpoint_ids | Map of endpoint IDs |
| private_endpoint_names | Map of endpoint names |
| private_endpoint_ip_addresses | Map of private IP addresses |
| private_endpoint_network_interface_ids | Map of NIC IDs |

## Notes

- Private endpoints must be in the same region as the resource
- Requires a dedicated subnet for private endpoints
- DNS resolution requires Private DNS Zone linked to VNet
- Some services may require multiple private endpoints for different subresources

## Best Practices

1. **Subnet Planning**: Use a dedicated subnet for private endpoints
2. **DNS Management**: Ensure Private DNS Zones are properly configured
3. **Network Security**: Apply NSG rules to the private endpoint subnet
4. **Naming Convention**: Use consistent naming for easy identification
5. **Monitoring**: Enable diagnostics for private endpoint connections

## References

- [Azure Private Link Documentation](https://docs.microsoft.com/en-us/azure/private-link/)
- [Private Endpoint DNS Configuration](https://docs.microsoft.com/en-us/azure/private-link/private-endpoint-dns)
