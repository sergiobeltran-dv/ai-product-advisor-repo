# PowerShell script to create Azure Storage Account for Terraform state
# Usage: .\create-backend-storage.ps1

param(
    [Parameter(Mandatory=$false)]
    [string]$ResourceGroupName = "terraform-state-rg",
    
    [Parameter(Mandatory=$false)]
    [string]$StorageAccountName = "tfstateerprodadvisor",
    
    [Parameter(Mandatory=$false)]
    [string]$ContainerName = "tfstate",
    
    [Parameter(Mandatory=$false)]
    [string]$Location = "eastus"
)

Write-Host "Creating Terraform Backend Storage..." -ForegroundColor Green

# Check if already logged in
$account = az account show 2>$null | ConvertFrom-Json
if (-not $account) {
    Write-Host "Not logged in to Azure. Running az login..." -ForegroundColor Yellow
    az login
}

Write-Host "Current subscription: $($account.name)" -ForegroundColor Cyan

# Create resource group
Write-Host "Creating resource group: $ResourceGroupName" -ForegroundColor Yellow
az group create `
    --name $ResourceGroupName `
    --location $Location `
    --output none

if ($LASTEXITCODE -ne 0) {
    Write-Host "Failed to create resource group" -ForegroundColor Red
    exit 1
}

# Create storage account
Write-Host "Creating storage account: $StorageAccountName" -ForegroundColor Yellow
az storage account create `
    --name $StorageAccountName `
    --resource-group $ResourceGroupName `
    --location $Location `
    --sku Standard_LRS `
    --kind StorageV2 `
    --encryption-services blob `
    --https-only true `
    --min-tls-version TLS1_2 `
    --allow-blob-public-access false `
    --output none

if ($LASTEXITCODE -ne 0) {
    Write-Host "Failed to create storage account" -ForegroundColor Red
    exit 1
}

# Get storage account key
Write-Host "Retrieving storage account key..." -ForegroundColor Yellow
$storageKey = az storage account keys list `
    --account-name $StorageAccountName `
    --resource-group $ResourceGroupName `
    --query "[0].value" `
    --output tsv

# Create blob container
Write-Host "Creating blob container: $ContainerName" -ForegroundColor Yellow
az storage container create `
    --name $ContainerName `
    --account-name $StorageAccountName `
    --account-key $storageKey `
    --output none

if ($LASTEXITCODE -ne 0) {
    Write-Host "Failed to create blob container" -ForegroundColor Red
    exit 1
}

Write-Host "`nTerraform backend storage created successfully!" -ForegroundColor Green
Write-Host "`nBackend Configuration:" -ForegroundColor Cyan
Write-Host "  Resource Group: $ResourceGroupName"
Write-Host "  Storage Account: $StorageAccountName"
Write-Host "  Container: $ContainerName"
Write-Host "  Location: $Location"
Write-Host "`nAdd this to your backend.tf:" -ForegroundColor Yellow
Write-Host @"
terraform {
  backend "azurerm" {
    resource_group_name  = "$ResourceGroupName"
    storage_account_name = "$StorageAccountName"
    container_name       = "$ContainerName"
    key                  = "dev.tfstate"  # or prod.tfstate
  }
}
"@

