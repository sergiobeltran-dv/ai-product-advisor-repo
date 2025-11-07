# Microsoft Fabric Terraform Module

## Overview

This module provides a structure for managing Microsoft Fabric resources. As of Terraform AzureRM provider 3.x, there is limited native support for Microsoft Fabric resources.

## Current Limitations

- **Limited Terraform Support**: Microsoft Fabric (Microsoft.Fabric/capacities) is a newer Azure service with evolving Terraform support
- **Manual Configuration Required**: Some Fabric resources may need to be created via:
  - Azure Portal
  - Azure CLI (with preview extensions)
  - PowerShell with Fabric modules
  - REST API calls
  - Microsoft Fabric portal (https://app.fabric.microsoft.com)

## Resources Covered

1. **Fabric Capacity**: The compute resource for Fabric workloads
2. **Fabric Workspace**: Logical container for Fabric items
3. **Fabric Lakehouse**: Data lake and warehouse hybrid
4. **Fabric Data Pipelines**: ETL/ELT orchestration

## Usage

```hcl
module "fabric" {
  source = "../../modules/fabric"

  location            = "eastus"
  resource_group_name = "rg-fabric"
  
  # Use existing capacity that was pre-created
  use_existing_capacity = true
  capacity_name         = "nonprodaiproductadvisoreastusfc"
  sku_name              = "F8"
  
  # Workspace configuration
  workspace_name = "ai-product-advisor-workspace"
  
  # Lakehouse configuration
  create_lakehouse = true
  lakehouse_name   = "productdata-lakehouse"
  
  # Data pipelines
  data_pipelines = [
    {
      name        = "d365-data-pipeline"
      description = "Pipeline to ingest D365 data"
    },
    {
      name        = "salesforce-data-pipeline"
      description = "Pipeline to ingest Salesforce data"
    }
  ]
  
  # Generate setup scripts
  generate_setup_script = true
  
  tags = {
    environment = "dev"
    project     = "ai-product-advisor"
  }
}
```

## Deployment Steps

### 1. Fabric Capacity

The Fabric Capacity is already deployed in the infrastructure. This module can reference it:

```hcl
use_existing_capacity = true
capacity_name         = "nonprodaiproductadvisoreastusfc"
```

### 2. Create Fabric Workspace

**Via Fabric Portal:**
1. Go to https://app.fabric.microsoft.com
2. Click "Workspaces" → "New Workspace"
3. Assign to the existing Fabric Capacity

**Via PowerShell:**
```powershell
# Install Fabric PowerShell module (if available)
Install-Module -Name Microsoft.Fabric.PowerShell

# Create workspace
New-FabricWorkspace -Name "ai-product-advisor-workspace" -CapacityId <capacity-id>
```

### 3. Create Fabric Lakehouse

**Via Fabric Portal:**
1. Navigate to your workspace
2. Click "+ New" → "Lakehouse"
3. Name it according to your configuration

### 4. Create Data Pipelines

**Via Fabric Portal:**
1. Navigate to your workspace
2. Click "+ New" → "Data Pipeline"
3. Configure source and destination
4. Set up schedules and triggers

### 5. Configure Private Endpoints

For security, configure private endpoints for Fabric resources:

```hcl
module "private_endpoints" {
  source = "../../modules/private-endpoints"
  
  # Fabric Lakehouse Private Endpoint
  private_endpoints = {
    fabric_lakehouse = {
      name                = "pe-fabric-lakehouse"
      subnet_id           = var.subnet_id
      private_connection_resource_id = var.fabric_lakehouse_id
      subresource_names   = ["dfs"]
    }
  }
}
```

## Required Permissions

To manage Fabric resources, you need:

1. **Azure Permissions:**
   - Contributor or Owner on the resource group
   - Microsoft.Fabric/capacities write permissions

2. **Fabric Permissions:**
   - Fabric Admin or Capacity Admin
   - Workspace Admin (for workspace-level operations)

## Outputs

- `capacity_name`: Name of the Fabric Capacity
- `workspace_name`: Name of the Fabric Workspace
- `lakehouse_name`: Name of the Fabric Lakehouse
- `setup_script_path_sh`: Path to bash setup script
- `setup_script_path_ps1`: Path to PowerShell setup script
- `fabric_portal_url`: URL to Fabric portal

## Future Enhancements

As Terraform support for Fabric improves, this module will be updated to include:
- Native Fabric Capacity resource creation
- Workspace creation and configuration
- Lakehouse and Data Pipeline resources
- RBAC and permissions management

## References

- [Microsoft Fabric Documentation](https://learn.microsoft.com/en-us/fabric/)
- [Fabric REST API](https://learn.microsoft.com/en-us/rest/api/fabric/)
- [Azure Resource Manager - Fabric](https://learn.microsoft.com/en-us/azure/templates/microsoft.fabric/capacities)
