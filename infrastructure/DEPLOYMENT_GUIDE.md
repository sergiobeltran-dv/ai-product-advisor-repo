# ElectroRent AI Product Advisor - Deployment Guide

## Prerequisites

Before deploying the infrastructure, ensure you have:

1. **Azure CLI** (version 2.50.0 or higher)
   ```bash
   az --version
   ```

2. **Terraform** (version 1.5.0 or higher)
   ```bash
   terraform --version
   ```

3. **Azure Subscription Access**
   - Dev Subscription: `electrorent-dev-sub` (586cc063-2fd8-41c0-8871-682beb464ca9)
   - Prod Subscription: `electrorent-prod-sub` (cf5782a6-c27d-4355-946a-e6e1a943540a)

4. **Azure Permissions**
   - Contributor or Owner role on the subscription
   - Permissions to create resources in the subscription

5. **Azure Login**
   ```bash
   az login
   az account set --subscription <subscription-id>
   az account show
   ```

## Infrastructure Overview

The solution deploys the following resources:

### Networking
- Virtual Network with multiple subnets
- Network Security Groups
- Private DNS Zones for private endpoints
- Azure Firewall (optional, prod only)
- VPN Gateway (optional)

### AI & Cognitive Services
- Azure OpenAI with GPT-4, GPT-3.5, and Embedding models
- Azure AI Search (with semantic search capabilities)

### Data Services
- Cosmos DB (for chat history and audit logs)
- Azure Cache for Redis (for semantic cache)
- Storage Accounts with ADLS Gen2 (for Fabric Lakehouse)

### Compute
- App Service (for Chat UI frontend)
- Function App (for backend API)

### Analytics
- Microsoft Fabric (Capacity, Workspace, Lakehouse, Data Pipelines)

### Security & Management
- Key Vault (for secrets management)
- Log Analytics Workspace
- Application Insights
- Managed Identities

### Private Connectivity
- Private Endpoints for all PaaS services
- Private DNS Zone integration

## Deployment Steps

### Step 1: Set Up Terraform Backend

The Terraform state is stored in an Azure Storage Account. Create it first:

```bash
# Navigate to scripts directory
cd terraform/scripts

# For Windows (PowerShell)
.\setup-backend.ps1 -SubscriptionId "586cc063-2fd8-41c0-8871-682beb464ca9"

# For Linux/Mac (Bash)
chmod +x setup-backend.sh
./setup-backend.sh "586cc063-2fd8-41c0-8871-682beb464ca9"
```

This creates:
- Resource Group: `terraform-state-rg`
- Storage Account: `tfstateerprodadvisor`
- Container: `tfstate`

### Step 2: Configure Variables

Navigate to your environment directory and create a `terraform.tfvars` file:

```bash
# For Dev environment
cd terraform/environments/dev
cp terraform.tfvars.example terraform.tfvars

# For Prod environment
cd terraform/environments/prod
cp terraform.tfvars.example terraform.tfvars
```

Edit `terraform.tfvars` with your specific values:
- Update subscription IDs
- Configure network address spaces
- Set SKU sizes based on your needs
- Update Fabric capacity name

**Important**: The `.tfvars` file contains sensitive information and should not be committed to git.

### Step 3: Initialize Terraform

```bash
# From your environment directory (dev or prod)
terraform init
```

This will:
- Download required providers
- Configure the backend
- Initialize modules

### Step 4: Review the Plan

```bash
terraform plan -out=tfplan
```

Review the output carefully:
- Check resource names follow naming convention
- Verify SKU sizes and configurations
- Ensure resource counts match expectations
- Review any warnings or errors

### Step 5: Deploy Infrastructure

```bash
terraform apply tfplan
```

This will:
- Create all resources in the correct order
- Handle dependencies automatically
- Output important values (endpoints, IDs, etc.)

**Deployment Time**: Initial deployment takes approximately 30-45 minutes.

### Step 6: Configure Fabric Resources

Terraform has limited support for Microsoft Fabric resources. After the infrastructure deployment:

1. **Access the Fabric Portal**
   ```
   https://app.fabric.microsoft.com
   ```

2. **Create Workspace**
   - Use the existing Fabric Capacity
   - Name: `nonprod-aiproductadvisor-workspace` (dev) or `prod-aiproductadvisor-workspace` (prod)

3. **Create Lakehouse**
   - In your workspace, create a new Lakehouse
   - Name: `nonprod-aiproductadvisor-lakehouse` (dev) or `prod-aiproductadvisor-lakehouse` (prod)

4. **Create Data Pipelines**
   - D365 data ingestion pipeline
   - Salesforce data ingestion pipeline
   - Perfect Server data ingestion pipeline

5. **Configure Private Endpoints** (if needed)
   - Create private endpoints for Lakehouse and Data Pipelines manually
   - Link to the existing private endpoint subnet

### Step 7: Post-Deployment Configuration

#### 7.1 Configure Key Vault Secrets

Store sensitive credentials in Key Vault:

```bash
# Get Key Vault name from outputs
KV_NAME=$(terraform output -raw key_vault_name)

# Add secrets
az keyvault secret set --vault-name $KV_NAME --name "OpenAI-Key" --value "<openai-key>"
az keyvault secret set --vault-name $KV_NAME --name "Search-AdminKey" --value "<search-admin-key>"
az keyvault secret set --vault-name $KV_NAME --name "Cosmos-PrimaryKey" --value "<cosmos-primary-key>"
az keyvault secret set --vault-name $KV_NAME --name "Redis-PrimaryKey" --value "<redis-primary-key>"
```

#### 7.2 Configure App Service

```bash
# Get App Service name
APP_SERVICE=$(terraform output -raw app_service_name)

# Deploy application code (placeholder)
# Use Azure DevOps pipelines or GitHub Actions for actual deployment
```

#### 7.3 Configure Function App

```bash
# Get Function App name
FUNCTION_APP=$(terraform output -raw function_app_name)

# Deploy function code
# Use Azure Functions Core Tools or CI/CD pipeline
```

#### 7.4 Test Private Endpoints

From a VM or bastion host in the VNet, test connectivity:

```bash
# Test OpenAI endpoint
nslookup nonprod-aiproductadvisor-aoai.openai.azure.com

# Test Search endpoint
nslookup nonprod-aiproductadvisor-eastus-aais.search.windows.net

# Verify private IP addresses are returned
```

## Environment-Specific Configurations

### Development (nonprod)
- **Purpose**: Development and testing
- **SKUs**: Basic/Standard tier (cost-optimized)
- **Redundancy**: Single region, no zone redundancy
- **VPN Gateway**: VpnGw1 (optional)
- **Firewall**: Disabled by default
- **Autoscaling**: Minimal or disabled

### Production (prod)
- **Purpose**: Production workloads
- **SKUs**: Premium/Standard tier (performance-optimized)
- **Redundancy**: Zone redundant where available
- **VPN Gateway**: VpnGw2/VpnGw3 (required)
- **Firewall**: Enabled with policies
- **Autoscaling**: Enabled for all applicable services

## Troubleshooting

### Common Issues

1. **Authentication Errors**
   ```bash
   az login
   az account set --subscription <subscription-id>
   ```

2. **Terraform State Lock**
   ```bash
   terraform force-unlock <lock-id>
   ```

3. **Resource Already Exists**
   - Check if resources were manually created
   - Import existing resources or remove from state

4. **Naming Conflicts**
   - Ensure resource names are globally unique
   - Check naming convention compliance

5. **Permission Errors**
   - Verify you have Contributor/Owner role
   - Check if specific resource providers are registered

6. **Private Endpoint DNS Resolution**
   - Ensure Private DNS Zones are linked to VNet
   - Verify DNS settings on test VMs

### Getting Help

1. **Review Terraform Logs**
   ```bash
   export TF_LOG=DEBUG
   terraform plan
   ```

2. **Check Azure Activity Log**
   ```bash
   az monitor activity-log list --resource-group <rg-name>
   ```

3. **Validate Configuration**
   ```bash
   terraform validate
   terraform fmt -check
   ```

## Maintenance

### Updating Infrastructure

1. **Pull Latest Changes**
   ```bash
   git pull origin main
   ```

2. **Review Changes**
   ```bash
   terraform plan
   ```

3. **Apply Updates**
   ```bash
   terraform apply
   ```

### Scaling Resources

Update SKUs in `terraform.tfvars`:

```hcl
# Example: Scale up App Service Plan
app_service_plan_sku = "P2v3"

# Example: Increase Redis capacity
redis_capacity = 2
```

Then apply changes:

```bash
terraform plan
terraform apply
```

### Destroying Infrastructure

**WARNING**: This will delete all resources!

```bash
terraform destroy
```

## Security Best Practices

1. **Never commit `.tfvars` files** containing sensitive data
2. **Use Key Vault** for all secrets and credentials
3. **Enable diagnostic logging** for all resources
4. **Use Private Endpoints** for all PaaS services
5. **Implement RBAC** with least privilege principle
6. **Enable Azure Policy** for compliance
7. **Regular security audits** using Azure Security Center

## Cost Management

### Cost Optimization Tips

1. **Use appropriate SKUs** for each environment
2. **Enable autoscaling** to scale down during off-hours
3. **Set up budget alerts** in Azure Cost Management
4. **Use Reserved Instances** for long-term savings
5. **Monitor unused resources** and clean up regularly

### Estimated Monthly Costs

**Development Environment**: $500-800/month
- Basic/Standard SKUs
- Minimal redundancy
- Lower throughput

**Production Environment**: $2,000-3,500/month
- Premium SKUs
- High availability
- Autoscaling enabled

## Next Steps

After successful deployment:

1. **Deploy Application Code**
   - Set up CI/CD pipelines
   - Deploy frontend to App Service
   - Deploy backend to Function App

2. **Configure Data Sources**
   - Set up Fabric Data Pipelines
   - Configure D365, Salesforce, Perfect Server connections
   - Test data ingestion

3. **Set Up Monitoring**
   - Configure Application Insights
   - Set up alerts and dashboards
   - Enable diagnostic logging

4. **Testing**
   - Conduct end-to-end testing
   - Performance testing
   - Security testing

5. **Documentation**
   - Update runbooks
   - Document architecture decisions
   - Create troubleshooting guides

## Support

For issues or questions:
- **Project Team**: Datavail Infrastructure Team
- **Client Contact**: ElectroRent IT Team
- **Azure Support**: Open support ticket in Azure Portal
