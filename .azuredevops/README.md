# Azure DevOps Pipelines

This directory contains CI/CD pipeline definitions for the AI Product Advisor project.

## Pipeline Structure

```
.azuredevops/
├── pipelines/
│   ├── infrastructure/
│   │   ├── terraform-plan.yml        # Terraform plan (validation)
│   │   ├── terraform-apply-sandbox.yml
│   │   ├── terraform-apply-dev.yml
│   │   └── terraform-apply-prod.yml
│   ├── backend/
│   │   ├── build-backend.yml         # Build and test
│   │   ├── deploy-sandbox.yml
│   │   ├── deploy-dev.yml
│   │   └── deploy-prod.yml
│   └── frontend/
│       ├── build-frontend.yml
│       ├── deploy-sandbox.yml
│       ├── deploy-dev.yml
│       └── deploy-prod.yml
└── README.md                          # This file
```

## Pipelines Overview

### Infrastructure Pipelines

**terraform-plan.yml**
- Triggers: On PR to main
- Validates Terraform syntax
- Generates plan for review
- Posts plan as PR comment

**terraform-apply-{env}.yml**
- Triggers: Manual or on merge to main
- Applies Terraform changes
- Requires approval for prod

### Backend Pipelines

**build-backend.yml**
- Triggers: On commit to backend/
- Runs unit tests
- Builds Function App
- Creates artifact

**deploy-{env}.yml**
- Triggers: After successful build
- Deploys to Function App
- Runs smoke tests
- Requires approval for prod

### Frontend Pipelines

_To be created when frontend development begins_

## Service Connections

Required Azure DevOps service connections:

1. **Azure Subscription Connections**:
   - `electrorent-ai-poc-sub` (Sandbox)
   - `electrorent-dev-sub` (Dev)
   - `electrorent-prod-sub` (Prod)

2. **Azure Container Registry** (if using containers)

## Variable Groups

Create these variable groups in Azure DevOps:

**infrastructure-common**
- `TF_STATE_RESOURCE_GROUP`: terraform-state-rg
- `TF_STATE_STORAGE_ACCOUNT`: tfstateerprodadvisor
- `TF_STATE_CONTAINER`: tfstate

**backend-sandbox**
- `AZURE_SUBSCRIPTION_ID`: ca9f1f9c-1617-4cfa-8f5a-55346b27c16c
- `FUNCTION_APP_NAME`: sandbox-aiproductadvisor-eastus-fa

**backend-dev**
- `AZURE_SUBSCRIPTION_ID`: 586cc063-2fd8-41c0-8871-682beb464ca9
- `FUNCTION_APP_NAME`: nonprod-aiproductadvisor-eastus-fa

**backend-prod**
- `AZURE_SUBSCRIPTION_ID`: cf5782a6-c27d-4355-946a-e6e1a943540a
- `FUNCTION_APP_NAME`: prod-aiproductadvisor-eastus-fa

## Deployment Strategy

### Infrastructure
1. **Sandbox**: Auto-deploy on merge to main (no approval)
2. **Dev**: Auto-deploy on merge to main (no approval)
3. **Prod**: Manual approval required

### Application Code
1. **Sandbox**: Auto-deploy (no approval)
2. **Dev**: Manual approval  
3. **Prod**: Manual approval + release manager sign-off

## Branch Protection

Recommended branch policies for `main`:

- ✅ Require pull request
- ✅ Minimum 1 reviewer
- ✅ Build validation (terraform-plan)
- ✅ No force push
- ✅ Delete branch after merge

## Getting Started

1. **Set up Service Connections** in Azure DevOps
2. **Create Variable Groups** with environment-specific values
3. **Import pipeline definitions** from `.azuredevops/pipelines/`
4. **Configure branch policies** on main branch
5. **Test pipelines** with a PR

## Pipeline Triggers

### Infrastructure
```yaml
trigger:
  branches:
    include:
      - main
  paths:
    include:
      - infrastructure/**
```

### Backend
```yaml
trigger:
  branches:
    include:
      - main
      - develop
  paths:
    include:
      - backend/**
```

## Best Practices

1. **Always use PR-based workflow** for main branch
2. **Test in sandbox first** before promoting to dev/prod
3. **Use approval gates** for production deployments
4. **Keep secrets in Azure Key Vault** or Azure DevOps Library
5. **Tag releases** with semantic versioning
6. **Monitor pipeline runs** and fix failures promptly

## Support

For pipeline issues:
- Check pipeline logs in Azure DevOps
- Review service connection permissions
- Verify variable group values
- Contact: Datavail DevOps Team

