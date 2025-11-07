# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**ElectroRent AI Product Advisor MVP** - An intelligent chatbot for the ElectroRent sales team to get product recommendations, specifications, and pricing. The solution integrates Azure OpenAI, Azure AI Search, Cosmos DB, Redis Cache, and Microsoft Fabric for a comprehensive AI-powered product advisory system.

**Client**: ElectroRent Corporation
**Implementation**: Datavail
**Cloud Platform**: Microsoft Azure

## Repository Structure

```
ERchat/
├── ai-product-advisor-repo/
│   ├── infrastructure/          # Terraform Infrastructure as Code
│   │   ├── environments/
│   │   │   ├── sandbox/        # POC environment (ca9f1f9c-1617-4cfa-8f5a-55346b27c16c)
│   │   │   ├── dev/            # Development environment (586cc063-2fd8-41c0-8871-682beb464ca9)
│   │   │   └── prod/           # Production environment (cf5782a6-c27d-4355-946a-e6e1a943540a)
│   │   ├── modules/            # 15+ reusable Terraform modules
│   │   └── scripts/            # Setup scripts for Terraform backend
│   ├── backend/                # Azure Functions (Python 3.11) - to be developed
│   └── .azuredevops/           # CI/CD pipeline definitions
├── terraform/                  # Legacy/reference terraform (use ai-product-advisor-repo instead)
└── Poc/                        # Proof of concept files
```

## Technology Stack

### Infrastructure (Terraform 1.5+)
- **Networking**: VNet, Subnets, Private DNS Zones, NSGs
- **AI Services**: Azure OpenAI (GPT-4, GPT-3.5, Embeddings), Azure AI Search
- **Data**: Cosmos DB, Azure Cache for Redis, Storage Accounts with ADLS Gen2
- **Compute**: App Service (Node.js/React frontend), Azure Functions (Python backend)
- **Analytics**: Microsoft Fabric (Capacity, Workspace, Lakehouse, Data Pipelines)
- **Security**: Managed Identities, Private Endpoints (no Key Vault in current design)
- **Monitoring**: Log Analytics, Application Insights

### Backend (Planned)
- **Runtime**: Python 3.11
- **Framework**: Azure Functions
- **AI Integration**: Azure OpenAI SDK, Azure AI Search SDK
- **Data Access**: Cosmos DB SDK, Redis client

## Common Development Commands

### Infrastructure Deployment

#### Initial Setup - Terraform Backend
```bash
# Navigate to scripts directory
cd ai-product-advisor-repo/infrastructure/scripts

# PowerShell (Windows)
.\setup-backend.ps1 -SubscriptionId "<subscription-id>"

# Bash (Linux/Mac)
chmod +x setup-backend.sh
./setup-backend.sh "<subscription-id>"
```

This creates:
- Resource Group: `terraform-state-rg`
- Storage Account: `tfstateerprodadvisor`
- Container: `tfstate`

#### Deploy Sandbox Environment
```bash
cd ai-product-advisor-repo/infrastructure/environments/sandbox

# Copy and edit variables file
cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars with subscription_id, tenant_id, fabric_capacity_name

# Initialize Terraform
terraform init

# Validate configuration
terraform validate
terraform fmt -check

# Review changes
terraform plan -out=tfplan

# Apply changes (deployment takes 30-45 minutes)
terraform apply tfplan

# View outputs
terraform output
```

#### Deploy Dev Environment
```bash
cd ai-product-advisor-repo/infrastructure/environments/dev
# Same steps as sandbox
```

#### Deploy Prod Environment
```bash
cd ai-product-advisor-repo/infrastructure/environments/prod
# Same steps as sandbox
```

### Infrastructure Management

```bash
# List all resources in a resource group
az resource list --resource-group <resource-group-name> --output table

# View Terraform state
terraform state list
terraform state show 'azurerm_resource_group.main'

# Destroy infrastructure (WARNING: deletes all resources)
terraform destroy
```

### Backend Development (Planned)

```bash
cd ai-product-advisor-repo/backend

# Install dependencies
pip install -r requirements.txt

# Run Azure Functions locally
func start

# Run tests
pytest tests/unit
pytest tests/integration
```

### Azure Authentication

```bash
# Login to Azure
az login

# Set active subscription
az account set --subscription "<subscription-id>"

# Verify current subscription
az account show
```

## Architecture & Key Design Decisions

### Multi-Environment Strategy
- **Sandbox**: POC environment for experimentation (Basic/Standard SKUs, single region)
- **Dev**: Development and testing (Basic/Standard SKUs, cost-optimized)
- **Prod**: Production workloads (Premium SKUs, zone redundancy, high availability)

### Naming Convention
Resources follow this pattern:
- **Sandbox**: `sandbox-aiproductadvisor-eastus-{shortform}`
- **Dev**: `nonprod-aiproductadvisor-eastus-{shortform}`
- **Prod**: `prod-aiproductadvisor-eastus-{shortform}`

Examples:
- `sandbox-aiproductadvisor-eastus-aoai` (Azure OpenAI)
- `sandbox-aiproductadvisor-eastus-aais` (AI Search)
- `sandbox-aiproductadvisor-eastus-codb` (Cosmos DB)
- `sandbox-aiproductadvisor-eastus-fa` (Function App)

### Network Architecture
- All environments use dedicated VNets with different address spaces:
  - Sandbox: `10.2.0.0/16`
  - Dev: `10.0.0.0/16`
  - Prod: `10.1.0.0/16`
- Three subnets per environment:
  - App Service subnet
  - Function App subnet
  - Private Endpoints subnet
- All PaaS services accessed via Private Endpoints (no public access)
- Private DNS Zones for service resolution within VNet

### Security Model
- **Authentication**: Managed Identities + Entra ID (no Key Vault in current design)
- **Network Security**: Private Endpoints for all PaaS services, NSGs on subnets
- **Secrets**: Stored in Azure App Configuration or Function App Settings
- **IMPORTANT**: Never commit `.tfvars` files with actual values to git

### Terraform Module Structure
The infrastructure uses 15+ reusable modules:
1. **networking** - VNet, subnets, NSGs, Private DNS Zones
2. **identity** - Managed Identities
3. **monitoring** - Log Analytics, Application Insights
4. **storage** - Storage Accounts with ADLS Gen2
5. **cognitive-services** - Azure OpenAI with model deployments
6. **search** - Azure AI Search with semantic search
7. **cosmos-db** - Cosmos DB with databases and containers
8. **cache** - Azure Cache for Redis
9. **app-services** - App Service Plan and App Service
10. **function-app** - Function App Plan and Function App
11. **fabric** - Microsoft Fabric (limited Terraform support)
12. **private-endpoints** - Private Endpoints for all services
13. **api-management** - API Management (optional)
14. **security** - Azure Firewall, VPN Gateway (prod)
15. **key-vault** - Key Vault (module exists but not used)

### Dependency Order
Terraform deploys resources in this order:
1. Networking (VNet, Subnets, DNS Zones)
2. Identity (Managed Identities)
3. Monitoring (Log Analytics, App Insights)
4. Storage
5. PaaS Services (OpenAI, Search, Cosmos, Redis)
6. Compute (App Service, Functions)
7. Private Endpoints (depends on all PaaS services)
8. Fabric (manual configuration required)

## CI/CD Pipelines (Azure DevOps)

### Pipeline Structure
Located in `.azuredevops/pipelines/`:
- `infrastructure/terraform-plan.yml` - PR validation (validates all 3 environments)
- `infrastructure/terraform-apply-sandbox.yml` - Deploy to sandbox
- Similar apply pipelines for dev and prod

### Variable Groups Required
- `infrastructure-common` - Terraform state configuration
- `backend-sandbox` - Sandbox deployment variables
- `backend-dev` - Dev deployment variables
- `backend-prod` - Prod deployment variables

### Service Connections Required
- `electrorent-ai-poc-sub` (Sandbox)
- `electrorent-dev-sub` (Dev)
- `electrorent-prod-sub` (Prod)

## Microsoft Fabric Limitations

Terraform has limited support for Microsoft Fabric. After infrastructure deployment:
1. Access Fabric Portal: `https://app.fabric.microsoft.com`
2. Create Workspace using existing Fabric Capacity
3. Create Lakehouse within the workspace
4. Create Data Pipelines (D365, Salesforce, Perfect Server ingestion)
5. Manually configure Private Endpoints for Fabric resources if needed

## Troubleshooting

### SSL Certificate Issues
If encountering SSL errors during `terraform init`:
```bash
# Temporarily disable backend for initialization
mv backend.tf backend.tf.disabled
terraform init
mv backend.tf.disabled backend.tf
terraform init
```

### Authentication Issues
```bash
# Re-authenticate
az login
az account set --subscription "<subscription-id>"
az account show
```

### Terraform State Locks
```bash
# Force unlock (use with caution)
terraform force-unlock <lock-id>
```

### Permission Errors
- Verify you have Contributor or Owner role on the subscription
- Ensure required resource providers are registered

### Deployment Failures
```bash
# Enable debug logging
export TF_LOG=DEBUG
terraform plan

# Check Azure Activity Log
az monitor activity-log list --resource-group <rg-name>
```

## Important Notes

### What NOT to Commit
- `terraform.tfvars` files with actual values
- Any files containing credentials, keys, or sensitive data
- `.terraform/` directories
- `*.tfstate` files (should be in remote backend only)

### Cost Estimates
- **Sandbox**: ~$300-500/month (Basic/Standard SKUs)
- **Dev**: ~$500-800/month (Basic/Standard SKUs)
- **Prod**: ~$2,000-3,500/month (Premium SKUs, high availability)

### Deployment Time
- Initial deployment: 30-45 minutes
- Updates: 5-20 minutes depending on changes

### Known Issues
1. Microsoft Fabric requires manual configuration (limited Terraform support)
2. Private DNS resolution requires VPN or bastion host for testing
3. SSL certificate issues may require corporate certificate configuration

## Documentation References

- **Main README**: `ai-product-advisor-repo/README.md`
- **Setup Instructions**: `ai-product-advisor-repo/SETUP_INSTRUCTIONS.md`
- **Infrastructure README**: `ai-product-advisor-repo/infrastructure/README.md`
- **Deployment Guide**: `ai-product-advisor-repo/infrastructure/DEPLOYMENT_GUIDE.md`
- **Quick Start**: `ai-product-advisor-repo/infrastructure/QUICKSTART.md`
- **Backend README**: `ai-product-advisor-repo/backend/README.md`
- **Claude Code Prompt**: `ai-product-advisor-repo/CLAUDE_CODE_PROMPT.md` (detailed next steps)

## Support & Contacts

- **Project Team**: Datavail Infrastructure Team
- **Client Contact**: ElectroRent IT Team
- **Azure Support**: Open support ticket in Azure Portal
