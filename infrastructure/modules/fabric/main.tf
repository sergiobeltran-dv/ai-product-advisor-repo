# Note: Data source for resource group removed to avoid dependency issues during creation
# The resource group name is passed via variable and should already exist when this module is called

# Note: As of Terraform AzureRM provider 3.x, there is limited support for Microsoft Fabric resources.
# The Fabric Capacity resource seen in Azure is Microsoft.Fabric/capacities
# This module provides a placeholder structure for when full Terraform support is available.
# Currently, Fabric resources may need to be created via Azure Portal, ARM templates, or Azure CLI.

# Placeholder for Fabric Capacity (when Terraform provider support is available)
# resource "azurerm_fabric_capacity" "capacity" {
#   count               = var.use_existing_capacity ? 0 : 1
#   name                = var.capacity_name
#   location            = var.location
#   resource_group_name = var.resource_group_name
#   sku_name            = var.sku_name
#   tags                = var.tags
# }

# For now, we'll create a local file with Azure CLI commands to create Fabric resources
resource "local_file" "fabric_setup_script" {
  count    = var.generate_setup_script ? 1 : 0
  filename = "${path.module}/../../scripts/create-fabric-resources.sh"
  content  = <<-EOT
    #!/bin/bash
    # Script to create Microsoft Fabric resources
    # Note: Fabric resources may require specific Azure CLI extensions or REST API calls
    
    RESOURCE_GROUP="${var.resource_group_name}"
    LOCATION="${var.location}"
    
    echo "Creating Microsoft Fabric resources..."
    echo "Resource Group: $RESOURCE_GROUP"
    echo "Location: $LOCATION"
    
    # Fabric Capacity
    # Note: Replace with actual Azure CLI or REST API commands when available
    ${var.use_existing_capacity ? "echo 'Using existing Fabric Capacity: ${var.capacity_name}'" : "echo 'Create Fabric Capacity: ${var.capacity_name} with SKU ${var.sku_name}'"}
    
    # Fabric Workspace
    echo "Create Fabric Workspace: ${var.workspace_name}"
    
    # Fabric Lakehouse
    ${var.create_lakehouse ? "echo 'Create Fabric Lakehouse: ${var.lakehouse_name}'" : ""}
    
    # Fabric Data Pipelines
    ${length(var.data_pipelines) > 0 ? "echo 'Create ${length(var.data_pipelines)} Fabric Data Pipeline(s)'" : ""}
    
    echo ""
    echo "Note: Microsoft Fabric resources may require:"
    echo "  1. Specific Azure permissions (Fabric Admin)"
    echo "  2. PowerShell modules or REST API access"
    echo "  3. Manual configuration via Fabric portal"
    echo ""
    echo "Visit: https://app.fabric.microsoft.com"
  EOT
}

# PowerShell version of the setup script
resource "local_file" "fabric_setup_script_ps1" {
  count    = var.generate_setup_script ? 1 : 0
  filename = "${path.module}/../../scripts/create-fabric-resources.ps1"
  content  = <<-EOT
    # Script to create Microsoft Fabric resources
    # Note: Fabric resources may require specific PowerShell modules or REST API calls
    
    $ResourceGroup = "${var.resource_group_name}"
    $Location = "${var.location}"
    
    Write-Host "Creating Microsoft Fabric resources..." -ForegroundColor Green
    Write-Host "Resource Group: $ResourceGroup"
    Write-Host "Location: $Location"
    Write-Host ""
    
    # Fabric Capacity
    ${var.use_existing_capacity ? "Write-Host 'Using existing Fabric Capacity: ${var.capacity_name}' -ForegroundColor Yellow" : "Write-Host 'Create Fabric Capacity: ${var.capacity_name} with SKU ${var.sku_name}' -ForegroundColor Cyan"}
    
    # Fabric Workspace
    Write-Host "Create Fabric Workspace: ${var.workspace_name}" -ForegroundColor Cyan
    
    # Fabric Lakehouse
    ${var.create_lakehouse ? "Write-Host 'Create Fabric Lakehouse: ${var.lakehouse_name}' -ForegroundColor Cyan" : ""}
    
    # Fabric Data Pipelines
    ${length(var.data_pipelines) > 0 ? "Write-Host 'Create ${length(var.data_pipelines)} Fabric Data Pipeline(s)' -ForegroundColor Cyan" : ""}
    
    Write-Host ""
    Write-Host "Note: Microsoft Fabric resources may require:" -ForegroundColor Yellow
    Write-Host "  1. Specific Azure permissions (Fabric Admin)" -ForegroundColor Yellow
    Write-Host "  2. PowerShell modules or REST API access" -ForegroundColor Yellow
    Write-Host "  3. Manual configuration via Fabric portal" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Visit: https://app.fabric.microsoft.com" -ForegroundColor Green
  EOT
}
