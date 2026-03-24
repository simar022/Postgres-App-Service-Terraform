Azure Automated Web-App & PostgreSQL Infrastructure

This repository contains a modularized Terraform configuration designed to deploy a secure, high-availability web application environment on Microsoft Azure. It leverages VNet Integration and Private DNS to ensure the database remains entirely isolated from the public internet while remaining accessible to the App Service.

📝 Architecture Overview

The infrastructure is built with security and scalability as core priorities:

Network Isolation:

	A Virtual Network (VNet) containing two dedicated subnets.

        App Subnet: Configured with Microsoft.Web/serverFarms delegation for regional VNet integration.

        DB Subnet: Configured with Microsoft.DBforPostgreSQL/flexibleServers delegation for private injection.

Database Security: The PostgreSQL Flexible Server has public_network_access_enabled = false. It is reachable only via its private IP within the internal network.

Service Connectivity: The App Service uses VNet Integration to route outbound traffic into the VNet, resolving the database's Fully Qualified Domain Name (FQDN) via a Private DNS Zone.

State Management: Terraform state is stored remotely in an Azure Blob Storage container with state locking enabled to prevent concurrent execution conflicts.

📂 Project Structure

.
├── bootstrap/            # One-time setup for remote state storage resources
├── modules/
│   ├── network/          # VNet, Subnets, and Private DNS logic
│   ├── postgres/         # Private PostgreSQL Flexible Server logic
│   └── app_service/      # Linux Web App & App Service Plan logic
├── main.tf               # Root module orchestrating the module calls
├── providers.tf          # AzureRM and Random provider configurations
├── variables.tf          # Global input definitions
├── outputs.tf            # Web App URL and DB FQDN access points
└── setup.sh              # Automation script for backend initialization

🚀 Deployment Steps

Prerequisites

    Azure CLI installed and authenticated (az login).

    Terraform CLI (v1.5.0+) installed.

    Owner or Contributor permissions on your Azure Subscription.

Step 1: Initialize Remote State

Run the provided setup script. This creates the Storage Account required to hold your .tfstate file and initializes Terraform with a partial backend configuration.

    chmod +x setup.sh

    ./setup.sh

Step 2: Configure Variables

Create a terraform.tfvars file in the root directory to define your environment settings:

Terraform

project_name = "my-secure-app"
location     = "eastus"
db_password  = "YourSecurePassword123!"

Step 3: Deploy Infrastructure

Execute the following commands to build your environment:

    terraform plan

    terraform apply -auto-approve

🔑 Accessing the Services

Once the deployment is complete, Terraform will display the output details:
1. Web Application

The URL is provided in the output final_webapp_url.

    Access: Open the URL in any web browser.

    Note: While the app endpoint is public, its communication with the database is encrypted and handled internally over the Azure backbone.

2. Private Database

The database cannot be accessed from your local machine (unless using a VPN or Azure Bastion).

    Internal FQDN: [project-name]-db-private.[project-name].postgres.database.azure.com

    Verification: To test connectivity, use the SSH tool in the Azure Portal for your Web App and run:

        curl -v telnet://[DB_FQDN]:5432

🛠 Maintenance & Clean Up

    To Update: Modify your variable files or module logic and run terraform apply.

    To Destroy: To stop incurring costs and remove all resources:

        terraform destroy

    Note: The tfstate-rg and the Storage Account containing the state files will not be deleted by the destroy command. They must be removed manually if no longer required.
