#!/bin/bash
# Setup Azure Storage Account for Terraform Backend State

set -e

# Variables
RESOURCE_GROUP="terraform-state-rg"
STORAGE_ACCOUNT="tfstateerprodadvisor"
CONTAINER_NAME="tfstate"
LOCATION="eastus"
SUBSCRIPTION_ID="${1}"

if [ -z "$SUBSCRIPTION_ID" ]; then
    echo "Usage: $0 <subscription-id>"
    echo "Example: $0 586cc063-2fd8-41c0-8871-682beb464ca9"
    exit 1
fi

echo "Setting Azure subscription..."
az account set --subscription "$SUBSCRIPTION_ID"

echo "Creating resource group for Terraform state..."
az group create \
  --name "$RESOURCE_GROUP" \
  --location "$LOCATION" \
  --tags "purpose=terraform-state" "managed-by=terraform" "project=aiproductadvisor"

echo "Creating storage account..."
az storage account create \
  --name "$STORAGE_ACCOUNT" \
  --resource-group "$RESOURCE_GROUP" \
  --location "$LOCATION" \
  --sku Standard_LRS \
  --encryption-services blob \
  --https-only true \
  --min-tls-version TLS1_2 \
  --allow-blob-public-access false \
  --tags "purpose=terraform-state" "managed-by=terraform" "project=aiproductadvisor"

echo "Getting storage account key..."
ACCOUNT_KEY=$(az storage account keys list \
  --resource-group "$RESOURCE_GROUP" \
  --account-name "$STORAGE_ACCOUNT" \
  --query '[0].value' -o tsv)

echo "Creating blob container..."
az storage container create \
  --name "$CONTAINER_NAME" \
  --account-name "$STORAGE_ACCOUNT" \
  --account-key "$ACCOUNT_KEY"

echo "Enabling versioning on storage account..."
az storage account blob-service-properties update \
  --account-name "$STORAGE_ACCOUNT" \
  --resource-group "$RESOURCE_GROUP" \
  --enable-versioning true

echo "Backend storage setup complete!"
echo ""
echo "Storage Account: $STORAGE_ACCOUNT"
echo "Container: $CONTAINER_NAME"
echo "Resource Group: $RESOURCE_GROUP"
echo ""
echo "Use these values in your backend.tf configuration"
