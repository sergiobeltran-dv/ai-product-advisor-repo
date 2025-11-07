# Resource Group
resource "azurerm_resource_group" "main" {
  name     = "${var.environment}-${var.project_name}-${var.location}-rg"
  location = var.location
  tags     = var.tags
}

# Networking Module
module "networking" {
  source = "../../modules/networking"

  vnet_name           = "${var.environment}-${var.project_name}-${var.location}-vnet"
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name
  vnet_address_space  = var.vnet_address_space
  subnets             = var.subnet_config

  # Network Security Groups
  network_security_groups = {
    app_service = {
      name = "${var.environment}-${var.project_name}-${var.location}-app-nsg"
      rules = [
        {
          name                       = "AllowHTTPS"
          priority                   = 100
          direction                  = "Inbound"
          access                     = "Allow"
          protocol                   = "Tcp"
          destination_port_range     = "443"
          source_address_prefix      = "*"
          destination_address_prefix = "*"
        }
      ]
    }
    function = {
      name = "${var.environment}-${var.project_name}-${var.location}-func-nsg"
      rules = []
    }
    private_endpoints = {
      name = "${var.environment}-${var.project_name}-${var.location}-pe-nsg"
      rules = []
    }
  }

  # Subnet to NSG Associations
  subnet_nsg_associations = {
    app_service_nsg = {
      subnet_key = "app_service"
      nsg_key    = "app_service"
    }
    function_nsg = {
      subnet_key = "function"
      nsg_key    = "function"
    }
    private_endpoints_nsg = {
      subnet_key = "private_endpoints"
      nsg_key    = "private_endpoints"
    }
  }

  # Private DNS Zones
  private_dns_zones = {
    openai = {
      name = "privatelink.openai.azure.com"
    }
    search = {
      name = "privatelink.search.windows.net"
    }
    cosmos = {
      name = "privatelink.documents.azure.com"
    }
    redis = {
      name = "privatelink.redis.cache.windows.net"
    }
    blob = {
      name = "privatelink.blob.core.windows.net"
    }
    file = {
      name = "privatelink.file.core.windows.net"
    }
    dfs = {
      name = "privatelink.dfs.core.windows.net"
    }
    keyvault = {
      name = "privatelink.vaultcore.azure.net"
    }
    sites = {
      name = "privatelink.azurewebsites.net"
    }
  }

  tags = var.tags
}

# Security Module (Optional)
module "security" {
  source = "../../modules/security"

  location            = var.location
  resource_group_name = azurerm_resource_group.main.name

  enable_firewall     = var.enable_firewall
  firewall_name       = var.enable_firewall ? "${var.environment}-${var.project_name}-${var.location}-afw" : ""
  firewall_subnet_id  = var.enable_firewall ? module.networking.subnet_ids["firewall"] : ""
  
  enable_vpn_gateway        = var.enable_vpn_gateway
  vpn_gateway_name          = var.enable_vpn_gateway ? "${var.environment}-${var.project_name}-${var.location}-vpngw" : ""
  vpn_gateway_subnet_id     = var.enable_vpn_gateway ? module.networking.subnet_ids["gateway"] : ""
  vpn_gateway_sku           = var.vpn_gateway_sku

  tags = var.tags

  depends_on = [module.networking]
}

# Identity Module
module "identity" {
  source = "../../modules/identity"

  location            = var.location
  resource_group_name = azurerm_resource_group.main.name

  managed_identities = {
    app_service = {
      name = "${var.environment}-${var.project_name}-${var.location}-mi"
    }
    function = {
      name = "${var.environment}-${var.project_name}-${var.location}-func-mi"
    }
  }

  tags = var.tags
}

# Monitoring Module
module "monitoring" {
  source = "../../modules/monitoring"

  location            = var.location
  resource_group_name = azurerm_resource_group.main.name

  log_analytics_workspace_name = "${var.environment}-${var.project_name}-${var.location}-la"
  application_insights_name    = "${var.environment}-${var.project_name}-${var.location}-appin"

  retention_in_days            = 30
  app_insights_retention_in_days = 90

  action_groups = {}

  tags = var.tags
}

# Storage Module
module "storage" {
  source = "../../modules/storage"

  location            = var.location
  resource_group_name = azurerm_resource_group.main.name

  storage_accounts = {
    adls = {
      name                     = replace("${var.environment}${var.project_name}${var.location}flh", "-", "")
      account_tier             = "Standard"
      account_replication_type = "LRS"
      is_hns_enabled           = true
      public_network_access_enabled = false
      
      data_lake_filesystems = [
        {
          name = "productdata"
        }
      ]
    }
  }

  tags = var.tags
}

# Key Vault Module - REMOVED
# Using Managed Identities and Entra ID for credential management instead

# Azure OpenAI Module
module "openai" {
  source = "../../modules/cognitive-services"

  openai_account_name   = "${var.environment}-${var.project_name}-${var.location}-aoai"
  location              = var.location
  resource_group_name   = azurerm_resource_group.main.name
  sku_name              = var.openai_sku
  custom_subdomain_name = "${var.environment}-${var.project_name}-aoai"

  public_network_access_enabled = false
  identity_type                 = "SystemAssigned"

  model_deployments = var.openai_model_deployments

  log_analytics_workspace_id = module.monitoring.log_analytics_workspace_id

  tags = var.tags

  depends_on = [module.monitoring]
}

# Azure AI Search Module
module "search" {
  source = "../../modules/search"

  search_service_name = "${var.environment}-${var.project_name}-${var.location}-aais"
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name
  sku                 = var.search_sku
  replica_count       = var.search_replica_count
  partition_count     = var.search_partition_count

  public_network_access_enabled = false
  identity_type                 = "SystemAssigned"

  log_analytics_workspace_id = module.monitoring.log_analytics_workspace_id

  tags = var.tags

  depends_on = [module.monitoring]
}

# Cosmos DB Module
module "cosmos" {
  source = "../../modules/cosmos-db"

  cosmos_account_name = "${var.environment}-${var.project_name}-${var.location}-codb"
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name
  consistency_level   = var.cosmos_consistency_level

  public_network_access_enabled = false
  identity_type                 = "SystemAssigned"

  sql_databases = var.cosmos_databases

  log_analytics_workspace_id = module.monitoring.log_analytics_workspace_id

  tags = var.tags

  depends_on = [module.monitoring]
}

# Redis Cache Module
module "redis" {
  source = "../../modules/cache"

  redis_name          = "${var.environment}-${var.project_name}-${var.location}-acr"
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name
  sku_name            = var.redis_sku_name
  capacity            = var.redis_capacity
  family              = var.redis_sku_name == "Premium" ? "P" : "C"

  public_network_access_enabled = false
  minimum_tls_version           = "1.2"

  log_analytics_workspace_id = module.monitoring.log_analytics_workspace_id

  tags = var.tags

  depends_on = [module.monitoring]
}

# App Service Module
module "app_service" {
  source = "../../modules/app-services"

  app_service_plan_name = "${var.environment}-${var.project_name}-${var.location}-asp"
  app_service_name      = "${var.environment}-${var.project_name}-${var.location}-as"
  location              = var.location
  resource_group_name   = azurerm_resource_group.main.name
  os_type               = var.app_service_os_type
  sku_name              = var.app_service_plan_sku

  public_network_access_enabled = false
  vnet_integration_subnet_id    = module.networking.subnet_ids["app_service"]

  identity_type = "SystemAssigned"

  application_stack = {
    node_version = "18-lts"
  }

  log_analytics_workspace_id = module.monitoring.log_analytics_workspace_id

  tags = var.tags

  depends_on = [module.networking, module.monitoring]
}

# Function App Module
module "function_app" {
  source = "../../modules/function-app"

  function_plan_name    = "${var.environment}-${var.project_name}-${var.location}-funcplan"
  function_app_name     = "${var.environment}-${var.project_name}-${var.location}-fa"
  storage_account_name  = replace("${var.environment}${var.project_name}${var.location}fa", "-", "")
  location              = var.location
  resource_group_name   = azurerm_resource_group.main.name
  os_type               = "Linux"
  sku_name              = var.function_app_sku

  public_network_access_enabled = false
  vnet_integration_subnet_id    = module.networking.subnet_ids["function"]

  identity_type = "SystemAssigned"

  functions_worker_runtime = "python"
  application_stack = {
    python_version = "3.11"
  }

  application_insights_connection_string = module.monitoring.application_insights_connection_string
  application_insights_instrumentation_key = module.monitoring.application_insights_instrumentation_key

  log_analytics_workspace_id = module.monitoring.log_analytics_workspace_id

  tags = var.tags

  depends_on = [module.networking, module.monitoring]
}

# Fabric Module
module "fabric" {
  source = "../../modules/fabric"

  location            = var.location
  resource_group_name = azurerm_resource_group.main.name

  use_existing_capacity = true
  capacity_name         = var.fabric_capacity_name
  sku_name              = var.fabric_sku

  workspace_name = "${var.environment}-${var.project_name}-workspace"

  create_lakehouse = true
  lakehouse_name   = "${var.environment}-${var.project_name}-lakehouse"

  data_pipelines = [
    {
      name        = "d365-ingestion"
      description = "Ingest data from D365"
    },
    {
      name        = "salesforce-ingestion"
      description = "Ingest data from Salesforce"
    },
    {
      name        = "perfect-server-ingestion"
      description = "Ingest data from Perfect Server"
    }
  ]

  generate_setup_script = true

  tags = var.tags
}

# Private Endpoints Module
module "private_endpoints" {
  source = "../../modules/private-endpoints"

  location            = var.location
  resource_group_name = azurerm_resource_group.main.name

  private_endpoints = {
    openai = {
      name                           = "${var.environment}-${var.project_name}-${var.location}-aoaipe"
      subnet_id                      = module.networking.subnet_ids["private_endpoints"]
      private_connection_resource_id = module.openai.openai_id
      subresource_names              = ["account"]
      private_dns_zone_ids           = [module.networking.private_dns_zone_ids["openai"]]
    }
    search = {
      name                           = "${var.environment}-${var.project_name}-${var.location}-aaispe"
      subnet_id                      = module.networking.subnet_ids["private_endpoints"]
      private_connection_resource_id = module.search.search_id
      subresource_names              = ["searchService"]
      private_dns_zone_ids           = [module.networking.private_dns_zone_ids["search"]]
    }
    cosmos = {
      name                           = "${var.environment}-${var.project_name}-${var.location}-codbpe"
      subnet_id                      = module.networking.subnet_ids["private_endpoints"]
      private_connection_resource_id = module.cosmos.cosmos_id
      subresource_names              = ["Sql"]
      private_dns_zone_ids           = [module.networking.private_dns_zone_ids["cosmos"]]
    }
    redis = {
      name                           = "${var.environment}-${var.project_name}-${var.location}-acrpe"
      subnet_id                      = module.networking.subnet_ids["private_endpoints"]
      private_connection_resource_id = module.redis.redis_id
      subresource_names              = ["redisCache"]
      private_dns_zone_ids           = [module.networking.private_dns_zone_ids["redis"]]
    }
    storage_blob = {
      name                           = "${var.environment}-${var.project_name}-${var.location}-flh-blob-pe"
      subnet_id                      = module.networking.subnet_ids["private_endpoints"]
      private_connection_resource_id = module.storage.storage_account_ids["adls"]
      subresource_names              = ["blob"]
      private_dns_zone_ids           = [module.networking.private_dns_zone_ids["blob"]]
    }
    storage_dfs = {
      name                           = "${var.environment}-${var.project_name}-${var.location}-flhpe"
      subnet_id                      = module.networking.subnet_ids["private_endpoints"]
      private_connection_resource_id = module.storage.storage_account_ids["adls"]
      subresource_names              = ["dfs"]
      private_dns_zone_ids           = [module.networking.private_dns_zone_ids["dfs"]]
    }
    app_service = {
      name                           = "${var.environment}-${var.project_name}-${var.location}-aspe"
      subnet_id                      = module.networking.subnet_ids["private_endpoints"]
      private_connection_resource_id = module.app_service.app_service_id
      subresource_names              = ["sites"]
      private_dns_zone_ids           = [module.networking.private_dns_zone_ids["sites"]]
    }
    function = {
      name                           = "${var.environment}-${var.project_name}-${var.location}-fape"
      subnet_id                      = module.networking.subnet_ids["private_endpoints"]
      private_connection_resource_id = module.function_app.function_app_id
      subresource_names              = ["sites"]
      private_dns_zone_ids           = [module.networking.private_dns_zone_ids["sites"]]
    }
  }

  tags = var.tags

  depends_on = [
    module.networking,
    module.openai,
    module.search,
    module.cosmos,
    module.redis,
    module.storage,
    module.app_service,
    module.function_app
  ]
}
