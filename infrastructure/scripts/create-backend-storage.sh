#!/bin/bash
# Bash script to create Azure Storage Account for Terraform state
# Usage: ./create-backend-storage.sh

set -e

# Variables
RESOURCE_GROUP_NAME="${1:-terraform-state-rg}"
STORAGE_ACCOUNT_NAME="${2:-tfstateerprodadvisor}"
CONTAINER_NAME="${3:-tfstate}"
LOCATION="${4:-eastus}"

echo "Creating Terraform Backend Storage..."

# Check if already logged in
if ! az account show &>/dev/null; then
    echo "Not logged in to Azure. Running az login..."
    az login
fi

SUBSCRIPTION=$(az account show --query name -o tsv)
echo "Current subscription: $SUBSCRIPTION"

# Create resource group
echo "Creating resource group: $RESOURCE_GROUP_NAME"
az group create \
    --name "$RESOURCE_GROUP_NAME" \
    --location "$LOCATION" \
    --output none

# Create storage account
echo "Creating storage account: $STORAGE_ACCOUNT_NAME"
az storage account create \
    --name "$STORAGE_ACCOUNT_NAME" \
    --resource-group "$RESOURCE_GROUP_NAME" \
    --location "$LOCATION" \
    --sku Standard_LRS \
    --kind StorageV2 \
    --encryption-services blob \
    --https-only true \
    --min-tls-version TLS1_2 \
    --allow-blob-public-access false \
    --output none

# Get storage account key
echo "Retrieving storage account key..."
STORAGE_KEY=$(az storage account keys list \
    --account-name "$STORAGE_ACCOUNT_NAME" \
    --resource-group "$RESOURCE_GROUP_NAME" \
    --query "[0].value" \
    --output tsv)

# Create blob container
echo "Creating blob container: $CONTAINER_NAME"
az storage container create \
    --name "$CONTAINER_NAME" \
    --account-name "$STORAGE_ACCOUNT_NAME" \
    --account-key "$STORAGE_KEY" \
    --output none

echo ""
echo "Terraform backend storage created successfully!"
echo ""
echo "Backend Configuration:"
echo "  Resource Group: $RESOURCE_GROUP_NAME"
echo "  Storage Account: $STORAGE_ACCOUNT_NAME"
echo "  Container: $CONTAINER_NAME"
echo "  Location: $LOCATION"
echo ""
echo "Add this to your backend.tf:"
cat <<EOF
terraform {
  backend "azurerm" {
    resource_group_name  = "$RESOURCE_GROUP_NAME"
    storage_account_name = "$STORAGE_ACCOUNT_NAME"
    container_name       = "$CONTAINER_NAME"
    key                  = "dev.tfstate"  # or prod.tfstate
  }
}
EOF

