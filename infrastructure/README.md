# ElectroRent AI Product Advisor - Infrastructure as Code

This repository contains Terraform configurations for deploying the ElectroRent AI Product Advisor MVP infrastructure across Azure environments.

## Architecture Overview

The solution deploys a comprehensive Azure infrastructure including:
- **Networking**: VNet, Subnets, Private DNS Zones, NSGs
- **Security**: Azure Firewall, VPN Gateway
- **AI Services**: Azure OpenAI, Azure AI Search
- **Data**: Cosmos DB, Azure Cache for Redis, Storage Accounts
- **Compute**: App Services, Azure Functions
- **Analytics**: Microsoft Fabric (Capacity, Workspace, Lakehouse, Pipelines)
- **Monitoring**: Log Analytics, Application Insights, Azure Monitor

## Project Structure

```
terraform/
├── environments/
│   ├── dev/              # Non-production environment
│   │   ├── backend.tf
│   │   ├── providers.tf
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── terraform.tfvars
│   │   └── outputs.tf
│   └── prod/             # Production environment
│       ├── backend.tf
│       ├── providers.tf
│       ├── main.tf
│       ├── variables.tf
│       ├── terraform.tfvars
│       └── outputs.tf
├── modules/              # Reusable Terraform modules
│   ├── networking/
│   ├── security/
│   ├── identity/
│   ├── app-services/
│   ├── function-app/
│   ├── api-management/
│   ├── cognitive-services/
│   ├── search/
│   ├── cache/
│   ├── storage/
│   ├── fabric/
│   ├── cosmos-db/
│   ├── key-vault/
│   ├── monitoring/
│   └── private-endpoints/
├── scripts/              # Helper scripts
└── README.md
```

## Prerequisites

1. **Terraform**: Version 1.5.0 or higher
2. **Azure CLI**: Authenticated with appropriate subscription access
3. **Azure Permissions**: Contributor or Owner role on target subscription
4. **Terraform Backend**: Azure Storage Account for state management

## Naming Convention

Resources follow this naming pattern:
- **Dev/NonProd**: `nonprod-aiproductadvisor-eastus-{shortform}`
- **Prod**: `prod-aiproductadvisor-eastus-{shortform}`

## Initial Setup

### 1. Configure Backend Storage

First, create the Azure Storage Account for Terraform state:

```bash
# Set variables
RESOURCE_GROUP="terraform-state-rg"
STORAGE_ACCOUNT="tfstateerprodadvisor"
CONTAINER_NAME="tfstate"
LOCATION="eastus"

# Create resource group
az group create --name $RESOURCE_GROUP --location $LOCATION

# Create storage account
az storage account create \
  --name $STORAGE_ACCOUNT \
  --resource-group $RESOURCE_GROUP \
  --location $LOCATION \
  --sku Standard_LRS \
  --encryption-services blob

# Create container
az storage container create \
  --name $CONTAINER_NAME \
  --account-name $STORAGE_ACCOUNT
```

### 2. Initialize Terraform

Navigate to the desired environment and initialize:

```bash
# For Dev environment
cd environments/dev
terraform init

# For Prod environment
cd environments/prod
terraform init
```

### 3. Configure Variables

Edit the `terraform.tfvars` file in your environment directory with appropriate values.

## Deployment

### Dev Environment

```bash
cd environments/dev

# Review planned changes
terraform plan -out=tfplan

# Apply changes
terraform apply tfplan
```

### Prod Environment

```bash
cd environments/prod

# Review planned changes
terraform plan -out=tfplan

# Apply changes
terraform apply tfplan
```

## Deployment Order

Resources are deployed in the following order to handle dependencies:

1. **Networking** - VNet, Subnets, NSGs, Private DNS Zones
2. **Security** - Azure Firewall, VPN Gateway
3. **Identity** - Managed Identities, App Registrations
4. **Storage & Key Vault** - Storage Accounts, Key Vault
5. **PaaS Services** - OpenAI, AI Search, Cosmos DB, Redis Cache
6. **Compute** - App Service, Azure Functions
7. **Private Endpoints** - All private endpoints for PaaS services
8. **Monitoring** - Log Analytics, Application Insights
9. **Fabric** - Fabric Capacity, Workspace, Lakehouse, Pipelines

## Module Usage

Each module is designed to be reusable and configurable. Example:

```hcl
module "networking" {
  source = "../../modules/networking"
  
  environment          = var.environment
  location             = var.location
  resource_group_name  = azurerm_resource_group.main.name
  vnet_address_space   = var.vnet_address_space
  subnet_config        = var.subnet_config
  tags                 = var.tags
}
```

## Phased Implementation

### Phase 1: Self-Contained Deployment (Current)
- All resources created from scratch
- Complete infrastructure ownership
- Suitable for dev/test environments

### Phase 2: Hybrid Deployment (Future)
- Reference existing shared infrastructure via `data` sources
- Create only environment-specific resources
- Reduced duplication and improved consistency

## Validation

After deployment, validate the infrastructure:

```bash
# Check resource group
az group show --name <resource-group-name>

# List all resources
az resource list --resource-group <resource-group-name> --output table

# Test connectivity to private endpoints
# (requires VPN connection or bastion host)
```

## Maintenance

### Updating Infrastructure

1. Make changes to Terraform files
2. Run `terraform plan` to review changes
3. Run `terraform apply` to apply changes
4. Commit changes to version control

### Destroying Infrastructure

**Warning**: This will delete all resources!

```bash
terraform destroy
```

## Troubleshooting

### Common Issues

1. **Authentication Errors**: Ensure Azure CLI is authenticated
   ```bash
   az login
   az account set --subscription <subscription-id>
   ```

2. **State Lock Issues**: If state is locked, identify and remove the lock
   ```bash
   terraform force-unlock <lock-id>
   ```

3. **Permission Errors**: Verify you have appropriate RBAC permissions

### Getting Help

Contact the DevOps team or refer to:
- [Terraform Azure Provider Documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)
- [Azure Architecture Center](https://docs.microsoft.com/en-us/azure/architecture/)

## Security Considerations

- **Secrets Management**: All secrets stored in Azure Key Vault
- **Network Security**: Private endpoints for all PaaS services
- **Access Control**: Azure AD authentication required
- **Monitoring**: All resources monitored via Azure Monitor

## Support

For issues or questions:
- **Project Team**: Datavail Infrastructure Team
- **Client Contact**: ElectroRent IT Team

## License

Proprietary - ElectroRent Corporation
