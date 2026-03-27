#!/bin/bash

TF_STATE_RG="tfstate-rg" 

echo "--------------------------------------------------------"
echo "⚠️  WARNING: This will delete ALL resources ⚠️"
echo "--------------------------------------------------------"
read -p "Are you sure you want to proceed? (y/n): " confirm

if [[ $confirm != "y" ]]; then
    echo "Cleanup cancelled."
    exit 1
fi

echo "Step 1: Destroying Terraform Managed Infrastructure..."
terraform destroy -auto-approve

echo "Step 2: Cleaning up local Terraform cache..."
rm -rf .terraform/
rm -f .terraform.lock.hcl
rm -f terraform.tfstate*
rm -f *.tfplan
rm -f terraform.tfvars.json

echo "Step 3: Deleting the Terraform State Resource Group ($TF_STATE_RG)..."
az group delete --name $TF_STATE_RG --yes --no-wait

echo "--------------------------------------------------------"
echo "✅ Cleanup Initiated!"
echo "Note: Azure background deletion may take 5-10 minutes."
echo "--------------------------------------------------------"
