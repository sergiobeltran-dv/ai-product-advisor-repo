# Quick Start Guide - ElectroRent AI Product Advisor

This guide will help you get the infrastructure up and running quickly.

## Prerequisites Check

```bash
# Check Terraform
terraform version

# Check Azure CLI
az --version

# Login to Azure
az login

# Set subscription
az account set --subscription "electrorent-dev-sub"
az account show
```

## 5-Minute Setup (Dev Environment)

### 1. Create Terraform Backend

```powershell
cd terraform/scripts
.\setup-backend.ps1 -SubscriptionId "586cc063-2fd8-41c0-8871-682beb464ca9"
```

### 2. Configure Variables

```powershell
cd ..\environments\dev
cp terraform.tfvars.example terraform.tfvars

# Edit terraform.tfvars with your values
# At minimum, update:
# - subscription_id
# - tenant_id
# - fabric_capacity_name
```

### 3. Deploy

```powershell
# Initialize
terraform init

# Review plan
terraform plan -out=tfplan

# Apply (this takes 30-45 minutes)
terraform apply tfplan
```

### 4. Get Outputs

```powershell
# View all outputs
terraform output

# Get specific values
terraform output -raw key_vault_uri
terraform output -raw openai_endpoint
terraform output -raw app_service_default_hostname
```

## What Gets Deployed?

After successful deployment, you'll have:

### ✅ Networking
- Virtual Network with 5 subnets
- Network Security Groups
- 9 Private DNS Zones

### ✅ AI Services
- Azure OpenAI (GPT-4, GPT-3.5, Embeddings)
- Azure AI Search

### ✅ Data Services
- Cosmos DB (2 databases, 3 containers)
- Redis Cache
- Storage Account with ADLS Gen2

### ✅ Compute
- App Service (for Chat UI)
- Function App (for API)

### ✅ Security
- Key Vault
- Managed Identities
- Private Endpoints (9 endpoints)

### ✅ Monitoring
- Log Analytics Workspace
- Application Insights

### ✅ Fabric
- Fabric Capacity (existing, referenced)
- Workspace (to be configured)
- Lakehouse (to be configured)

## Post-Deployment Steps

### Configure Fabric (Manual)

1. Go to https://app.fabric.microsoft.com
2. Create workspace: `nonprod-aiproductadvisor-workspace`
3. Create lakehouse: `nonprod-aiproductadvisor-lakehouse`
4. Set up data pipelines for D365, Salesforce, Perfect Server

### Store Secrets in Key Vault

```bash
KV_NAME=$(terraform output -raw key_vault_name)

# OpenAI Key
az keyvault secret set --vault-name $KV_NAME \
  --name "OpenAI-Key" \
  --value "<key-from-portal>"

# Search Admin Key
az keyvault secret set --vault-name $KV_NAME \
  --name "Search-AdminKey" \
  --value "<key-from-portal>"

# Cosmos Primary Key
az keyvault secret set --vault-name $KV_NAME \
  --name "Cosmos-PrimaryKey" \
  --value "<key-from-portal>"
```

### Deploy Application Code

```bash
# App Service (Chat UI)
APP_SERVICE=$(terraform output -raw app_service_name)
# Deploy your frontend code here

# Function App (API)
FUNCTION_APP=$(terraform output -raw function_app_name)
# Deploy your backend code here
```

## Verify Deployment

### Check Resources in Portal

```bash
RG_NAME=$(terraform output -raw resource_group_name)

# List all resources
az resource list --resource-group $RG_NAME --output table

# Check specific services
az cognitiveservices account show --name $(terraform output -raw openai_name) --resource-group $RG_NAME
az search service show --name $(terraform output -raw search_name) --resource-group $RG_NAME
```

### Test Private Endpoints (from VNet VM)

```bash
# Should resolve to private IP (10.0.3.x)
nslookup nonprod-aiproductadvisor-aoai.openai.azure.com
nslookup nonprod-aiproductadvisor-eastus-aais.search.windows.net
```

## Common Issues

### Issue: Backend initialization fails

**Solution:**
```bash
# Ensure backend storage exists
az storage account show --name tfstateerprodadvisor --resource-group terraform-state-rg
```

### Issue: Resource name already exists

**Solution:**
Check if resources were manually created. Either import them or use different names.

### Issue: Permission denied

**Solution:**
```bash
# Verify permissions
az role assignment list --assignee $(az account show --query user.name -o tsv) --scope /subscriptions/586cc063-2fd8-41c0-8871-682beb464ca9
```

## Cleanup (Delete Everything)

**WARNING:** This destroys all resources!

```bash
cd terraform/environments/dev
terraform destroy
```

## Cost Estimate

**Development Environment:** ~$500-800/month
- Basic/Standard SKUs
- Single region
- No redundancy

## Next Steps

1. ✅ Infrastructure deployed
2. Configure Fabric workspace and lakehouse
3. Deploy application code
4. Set up CI/CD pipelines
5. Configure monitoring and alerts
6. Set up data ingestion pipelines
7. Conduct testing
8. Prepare for production deployment

## Resources

- [Full Deployment Guide](DEPLOYMENT_GUIDE.md)
- [Main README](README.md)
- [Module Documentation](modules/)
- [Azure OpenAI Documentation](https://learn.microsoft.com/azure/ai-services/openai/)
- [Azure AI Search Documentation](https://learn.microsoft.com/azure/search/)

## Support

- **Issues:** Contact Datavail Infrastructure Team
- **Azure Support:** Open ticket in Azure Portal
- **Documentation:** See `/terraform/README.md`

