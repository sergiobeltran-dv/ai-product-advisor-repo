# Claude Code Continuation Prompt

## Project Context

This is the **ElectroRent AI Product Advisor MVP** - an intelligent chatbot for the sales team to get product recommendations, specifications, and pricing.

### Current Status
- ✅ **Infrastructure as Code (IaC)**: Complete Terraform configuration for 3 environments (Sandbox/Dev/Prod)
- ✅ **Architecture**: 15 Terraform modules with all Azure services configured
- ✅ **Azure DevOps**: Repository structure and CI/CD pipeline templates ready
- ⏳ **Next Phase**: Deploy infrastructure and develop backend application

### Technology Stack
- **Infrastructure**: Terraform, Azure (VNet, App Service, Functions, OpenAI, AI Search, Cosmos DB, Redis, Fabric)
- **Backend**: Azure Functions (Python 3.11)
- **Frontend**: Azure App Service (Node.js/React)
- **AI Services**: Azure OpenAI (GPT-4, GPT-3.5, Embeddings)
- **Data**: Cosmos DB (chat history), Redis Cache (semantic cache), ADLS Gen2
- **Analytics**: Microsoft Fabric (Lakehouse, Pipelines)
- **Authentication**: Managed Identities + Entra ID (no Key Vault)

---

## Immediate Tasks (Next Steps)

### 1. Push Repository to Azure DevOps
**Goal**: Get the codebase into Azure DevOps for team collaboration

**Steps**:
```bash
# Navigate to the repo folder
cd C:\Users\sergio.beltran\Downloads\ERchat\ai-product-advisor-repo

# Initialize git (if needed)
git init

# Configure user
git config user.email "sergio.beltran@datavail.com"
git config user.name "Sergio Beltran"

# Add and commit
git add .
git commit -m "Initial commit: Infrastructure as Code and project structure"

# Add remote (ask user for the Azure DevOps HTTPS URL)
git remote add origin <AZURE_DEVOPS_REPO_URL>

# Push to Azure DevOps
git push -u origin main
```

**Note**: User may need to install Git first if not already installed

---

### 2. Deploy Infrastructure to Sandbox
**Goal**: Validate Terraform configuration and deploy to sandbox POC environment

**Prerequisites**:
- Azure subscription: `electrorent-ai-poc-sub` (ca9f1f9c-1617-4cfa-8f5a-55346b27c16c)
- Azure CLI authenticated
- Terraform 1.5+ installed

**Steps**:

#### a. Initialize Terraform Backend
```bash
cd infrastructure/scripts
.\setup-backend.ps1 -SubscriptionId "ca9f1f9c-1617-4cfa-8f5a-55346b27c16c"
```
This creates:
- Resource Group: `terraform-state-rg`
- Storage Account: `tfstateerprodadvisor`
- Container: `tfstate`

#### b. Prepare Sandbox Environment
```bash
cd ..\..\environments\sandbox

# Copy tfvars template
cp terraform.tfvars.example terraform.tfvars

# Edit terraform.tfvars and update:
# - subscription_id: ca9f1f9c-1617-4cfa-8f5a-55346b27c16c
# - tenant_id: 56a19319-c3b2-4e35-8892-6ccd137b4321
# - fabric_capacity_name: (get from Azure Portal or user input)
```

**Key values for sandbox:**
```hcl
subscription_id = "ca9f1f9c-1617-4cfa-8f5a-55346b27c16c"
tenant_id       = "56a19319-c3b2-4e35-8892-6ccd137b4321"
environment     = "sandbox"
fabric_capacity_name = "sandboxaiproductadvisorfc"  # Update if different
```

#### c. Initialize Terraform
```bash
terraform init
```

**Known Issue**: If you get SSL certificate errors:
- Temporarily disable backend: `mv backend.tf backend.tf.disabled`
- Run: `terraform init`
- Later: `mv backend.tf.disabled backend.tf`

#### d. Validate Configuration
```bash
terraform validate
terraform fmt -check
```

#### e. Create Plan
```bash
terraform plan -out=tfplan
```

**Expected output**: Should show ~60-80 resources to be created

#### f. Review and Apply
```bash
# If plan looks good, apply
terraform apply tfplan
```

**Deployment time**: 30-45 minutes for first deployment

#### g. Verify Deployment
```bash
# Get outputs
terraform output

# Check specific resources
az resource list --resource-group sandbox-aiproductadvisor-eastus-rg --output table
```

---

### 3. Backend Application Setup
**Goal**: Set up the Azure Functions backend API structure

**Structure to create**:
```
backend/
├── function-app/
│   ├── functions/
│   │   ├── chat_endpoint.py
│   │   ├── search_endpoint.py
│   │   └── health_check.py
│   ├── shared/
│   │   ├── ai_services.py
│   │   ├── data_access.py
│   │   └── utils.py
│   ├── requirements.txt
│   ├── host.json
│   ├── local.settings.json
│   └── function_app.py
├── tests/
│   ├── unit/
│   └── integration/
└── README.md
```

**Tasks**:
1. Create Azure Functions project structure
2. Set up Python dependencies (azure-functions, openai, azure-search, azure-cosmos, redis)
3. Create base utility modules
4. Implement health check endpoint
5. Set up local development environment

---

## File Locations

**Repository Structure**:
```
ai-product-advisor-repo/
├── infrastructure/
│   ├── environments/
│   │   ├── sandbox/
│   │   ├── dev/
│   │   └── prod/
│   ├── modules/          # 15 reusable modules
│   └── scripts/
├── backend/              # Python Azure Functions
├── .azuredevops/         # CI/CD pipelines
└── SETUP_INSTRUCTIONS.md # Complete setup guide
```

**Key Configuration Files**:
- `infrastructure/environments/sandbox/terraform.tfvars` (template: `.example`)
- `infrastructure/environments/sandbox/main.tf` (module composition)
- `infrastructure/environments/sandbox/variables.tf` (input variables)

---

## Important Considerations

### Environment Variables & Secrets
- **No Key Vault**: Using Managed Identities + Entra ID for auth
- Secrets stored in: Azure App Configuration or Function App Settings
- Never commit secrets or `.tfvars` files with actual values

### Networking
- All PaaS services behind Private Endpoints
- VNet address space: Sandbox: 10.2.0.0/16, Dev: 10.0.0.0/16, Prod: 10.1.0.0/16
- Private DNS Zones configured for all services

### Resource Naming Convention
- **Sandbox**: `sandbox-aiproductadvisor-eastus-{shortform}`
- **Dev**: `nonprod-aiproductadvisor-eastus-{shortform}`
- **Prod**: `prod-aiproductadvisor-eastus-{shortform}`

Example:
- `sandbox-aiproductadvisor-eastus-aoai` (Azure OpenAI)
- `sandbox-aiproductadvisor-eastus-aais` (AI Search)
- `sandbox-aiproductadvisor-eastus-codb` (Cosmos DB)

---

## Expected Deployment Output

After successful `terraform apply`, you should have:

### Networking
- ✅ Virtual Network (10.2.0.0/16 for sandbox)
- ✅ 3 Subnets (App Service, Functions, Private Endpoints)
- ✅ Network Security Groups
- ✅ 7 Private DNS Zones

### AI & Cognitive Services
- ✅ Azure OpenAI (with GPT-4, GPT-3.5, Embeddings models)
- ✅ Azure AI Search (Basic tier)

### Data Services
- ✅ Cosmos DB (2 databases, 3 containers)
- ✅ Azure Cache for Redis (C0 tier)
- ✅ Storage Account with ADLS Gen2

### Compute
- ✅ App Service Plan (B1 tier)
- ✅ App Service for Chat UI
- ✅ Function App for Backend API
- ✅ Function App Storage Account

### Security & Monitoring
- ✅ Managed Identities (App Service, Functions)
- ✅ Log Analytics Workspace
- ✅ Application Insights
- ✅ 7 Private Endpoints

### Outputs You Need
```
resource_group_name = "sandbox-aiproductadvisor-eastus-rg"
app_service_default_hostname = "sandbox-aiproductadvisor-eastus-as.azurewebsites.net"
function_app_default_hostname = "sandbox-aiproductadvisor-eastus-fa.azurewebsites.net"
openai_endpoint = "https://sandbox-aiproductadvisor-aoai.openai.azure.com/"
search_endpoint = "https://sandbox-aiproductadvisor-eastus-aais.search.windows.net"
cosmos_endpoint = "https://sandbox-aiproductadvisor-eastus-codb.documents.azure.com:443/"
redis_hostname = "sandbox-aiproductadvisor-eastus-acr.redis.cache.windows.net"
```

---

## Troubleshooting Commands

```bash
# Check current subscription
az account show

# Switch subscription
az account set --subscription "ca9f1f9c-1617-4cfa-8f5a-55346b27c16c"

# List all resources in resource group
az resource list --resource-group sandbox-aiproductadvisor-eastus-rg --output table

# Show resource group
az group show --name sandbox-aiproductadvisor-eastus-rg

# View Terraform state
terraform state list
terraform state show 'azurerm_resource_group.main'

# Destroy infrastructure (if needed)
terraform destroy
```

---

## Next Phase (After Infrastructure Deployment)

1. **Backend Development**
   - Create Azure Functions endpoints
   - Integrate Azure OpenAI
   - Integrate Azure AI Search
   - Set up Cosmos DB data models
   - Implement Redis caching

2. **Frontend Development**
   - Build Chat UI (React)
   - Deploy to App Service
   - Set up CI/CD pipeline

3. **Testing & Validation**
   - Unit tests
   - Integration tests
   - End-to-end tests
   - Performance testing

---

## Resources & Documentation

- **Terraform README**: `infrastructure/README.md`
- **Deployment Guide**: `infrastructure/DEPLOYMENT_GUIDE.md`
- **Quick Start**: `infrastructure/QUICKSTART.md`
- **Setup Instructions**: `SETUP_INSTRUCTIONS.md`
- **Backend README**: `backend/README.md`
- **Azure DevOps Pipelines**: `.azuredevops/README.md`

---

## Team & Contacts

- **Project**: ElectroRent AI Product Advisor MVP
- **Client**: ElectroRent Corporation
- **Implementation**: Datavail
- **Cloud Platform**: Microsoft Azure
- **Infrastructure Code**: Terraform
- **Backend**: Python (Azure Functions)

---

## Success Criteria

✅ **Sandbox Deployment Complete** when:
1. All Terraform resources deployed successfully
2. Azure OpenAI models responding
3. Azure AI Search service accessible
4. Cosmos DB databases created
5. Redis Cache operational
6. App Service and Function App running
7. Private Endpoints all working
8. Managed Identities configured

---

## Claude Code Instructions

When continuing with Claude Code, prioritize in this order:

1. **Git Push to Azure DevOps** (if Git is installed)
2. **Terraform Backend Setup** (if not already done)
3. **Sandbox Terraform Deployment**
4. **Backend Application Scaffolding**
5. **Azure DevOps Pipelines Configuration**

Feel free to break down tasks further, ask clarifying questions about environment-specific values, and validate configurations before applying changes.

