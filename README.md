# ElectroRent AI Product Advisor

This repository contains the complete codebase for the ElectroRent AI Product Advisor MVP.

## Repository Structure

```
ai-product-advisor-repo/
├── backend/                    # Backend application code (Python/Node.js)
│   └── (to be developed)
├── infrastructure/             # Infrastructure as Code (Terraform)
│   ├── environments/
│   │   ├── sandbox/           # Sandbox/POC environment
│   │   ├── dev/               # Development environment  
│   │   └── prod/              # Production environment
│   ├── modules/               # Reusable Terraform modules
│   ├── scripts/               # Helper scripts
│   └── README.md
├── .azuredevops/              # Azure DevOps pipelines
│   ├── pipelines/
│   └── README.md
└── README.md                  # This file
```

## Getting Started

### Infrastructure Deployment

See [infrastructure/README.md](infrastructure/README.md) for complete infrastructure deployment instructions.

**Quick Start:**
```bash
cd infrastructure/environments/sandbox
terraform init
terraform plan
terraform apply
```

### Backend Development

Backend application code will be developed in the `backend/` directory.

**Technologies:**
- Azure Functions (Python)
- Azure OpenAI
- Azure AI Search
- Cosmos DB
- Redis Cache

### CI/CD Pipelines

Azure DevOps pipelines are located in `.azuredevops/pipelines/`

## Environments

| Environment | Purpose | Subscription |
|-------------|---------|--------------|
| **Sandbox** | POC and experimentation | electrorent-ai-poc-sub |
| **Dev** | Development and testing | electrorent-dev-sub |
| **Prod** | Production | electrorent-prod-sub |

## Architecture

The solution consists of:
- **Frontend**: Azure App Service (Chat UI)
- **Backend**: Azure Functions (API)
- **AI Services**: Azure OpenAI, Azure AI Search
- **Data**: Cosmos DB, Redis Cache, Storage (ADLS Gen2)
- **Analytics**: Microsoft Fabric (Lakehouse, Pipelines)
- **Security**: Managed Identities, Private Endpoints, Entra ID

## Documentation

- [Infrastructure Documentation](infrastructure/README.md)
- [Deployment Guide](infrastructure/DEPLOYMENT_GUIDE.md)
- [Quick Start Guide](infrastructure/QUICKSTART.md)
- [Business Requirements](../Business%20Requirements-Electro%20Rent%20AI%20Product%20Advisor-MVP%201.docx)

## Team

- **Client**: ElectroRent Corporation
- **Implementation**: Datavail
- **Project**: AI Product Advisor MVP

## Support

For issues or questions:
- **Azure Infrastructure**: Datavail Infrastructure Team
- **Application Development**: Datavail Development Team  
- **Client Contact**: ElectroRent IT Team

