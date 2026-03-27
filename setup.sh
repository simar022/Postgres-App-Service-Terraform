#!/bin/bash

RESOURCE_GROUP_NAME="tfstate-rg"
STORAGE_ACCOUNT_NAME="tfstatelightspec0101" 
CONTAINER_NAME="terraform-state"
LOCATION="centralindia"
PROJECT_NAME="lightspec"
ENVIRONMENT="prod"
PASSWORD="123456"

echo "Step 1: Creating Resource Group for Terraform State..."
az group create --name $RESOURCE_GROUP_NAME --location $LOCATION

echo "Step 2: Creating Storage Account..."
az storage account create --name $STORAGE_ACCOUNT_NAME --resource-group $RESOURCE_GROUP_NAME --location $LOCATION --sku Standard_LRS --encryption-services blob --min-tls-version TLS1_2 --allow-blob-public-access false

echo "Step 3: Creating Blob Container..."
az storage container create --name $CONTAINER_NAME --account-name $STORAGE_ACCOUNT_NAME

echo "--------------------------------------------------------"
echo "STORAGE_ACCOUNT_NAME: $STORAGE_ACCOUNT_NAME"
echo "--------------------------------------------------------"
echo "Step 4: Initializing Terraform with Backend Configuration..."

terraform init \
    -backend-config="resource_group_name=$RESOURCE_GROUP_NAME" \
    -backend-config="storage_account_name=$STORAGE_ACCOUNT_NAME" \
    -backend-config="container_name=$CONTAINER_NAME" \
    -backend-config="key=$ENVIRONMENT.terraform.tfstate" \
    -migrate-state

cat <<EOF > terraform.tfvars.json
{
  "project_name": "$PROJECT_NAME",
  "location": "$LOCATION",
  "environment": "$ENVIRONMENT",
  "db_password": "$PASSWORD"
}
EOF

echo "Setup Complete! You can now run 'terraform plan' and 'terraform apply'."
