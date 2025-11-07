# Setup Azure Storage Account for Terraform Backend State
# PowerShell version for Windows

param(
    [Parameter(Mandatory=$true)]
    [string]$SubscriptionId
)

$ErrorActionPreference = "Stop"

# Variables
$ResourceGroup = "terraform-state-rg"
$StorageAccount = "tfstateerprodadvisor"
$ContainerName = "tfstate"
$Location = "eastus"

Write-Host "Setting Azure subscription..." -ForegroundColor Green
az account set --subscription $SubscriptionId

Write-Host "Creating resource group for Terraform state..." -ForegroundColor Green
az group create `
  --name $ResourceGroup `
  --location $Location `
  --tags "purpose=terraform-state" "managed-by=terraform" "project=aiproductadvisor"

Write-Host "Creating storage account..." -ForegroundColor Green
az storage account create `
  --name $StorageAccount `
  --resource-group $ResourceGroup `
  --location $Location `
  --sku Standard_LRS `
  --encryption-services blob `
  --https-only true `
  --min-tls-version TLS1_2 `
  --allow-blob-public-access false `
  --tags "purpose=terraform-state" "managed-by=terraform" "project=aiproductadvisor"

Write-Host "Getting storage account key..." -ForegroundColor Green
$AccountKey = (az storage account keys list `
  --resource-group $ResourceGroup `
  --account-name $StorageAccount `
  --query '[0].value' -o tsv)

Write-Host "Creating blob container..." -ForegroundColor Green
az storage container create `
  --name $ContainerName `
  --account-name $StorageAccount `
  --account-key $AccountKey

Write-Host "Enabling versioning on storage account..." -ForegroundColor Green
az storage account blob-service-properties update `
  --account-name $StorageAccount `
  --resource-group $ResourceGroup `
  --enable-versioning true

Write-Host ""
Write-Host "Backend storage setup complete!" -ForegroundColor Green
Write-Host ""
Write-Host "Storage Account: $StorageAccount" -ForegroundColor Yellow
Write-Host "Container: $ContainerName" -ForegroundColor Yellow
Write-Host "Resource Group: $ResourceGroup" -ForegroundColor Yellow
Write-Host ""
Write-Host "Use these values in your backend.tf configuration" -ForegroundColor Cyan
