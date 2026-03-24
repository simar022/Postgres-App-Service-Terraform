Azure Automated Web-App & PostgreSQL Infrastructure

This repository contains a modularized Terraform configuration to deploy a secure, high-availability web application environment on Microsoft Azure. It leverages VNet Integration and Private DNS to ensure the database remains entirely isolated from the public internet while remaining accessible to the App Service.
📝 Architecture Overview

The infrastructure is designed with security and scalability as priorities:

    Network Isolation: * A Virtual Network (VNet) with two dedicated subnets.

        App Subnet: Configured with Microsoft.Web/serverFarms delegation for regional VNet integration.

        DB Subnet: Configured with Microsoft.DBforPostgreSQL/flexibleServers delegation.

    Database Security: The PostgreSQL Flexible Server has public_network_access_enabled = false. It is only reachable via its private IP within the VNet.

    Service Connectivity: The App Service uses VNet Integration to route outbound traffic into the VNet, resolving the database's FQDN via a Private DNS Zone.

    State Management: Terraform state is stored remotely in an Azure Blob Storage container with state locking enabled to prevent concurrent execution conflicts.

📂 Project Structure

.
├── bootstrap/            # One-time setup for remote state storage
├── modules/
│   ├── network/          # VNet, Subnets, and Private DNS
│   ├── postgres/         # Private PostgreSQL Flexible Server
│   └── app_service/      # Linux Web App & App Service Plan
├── main.tf               # Root module orchestrating the deployment
├── providers.tf          # AzureRM and Random provider configurations
├── variables.tf          # Global input definitions
├── outputs.tf            # Web App URL and DB FQDN
└── setup.sh              # Automation script for backend initialization

🚀 Deployment Steps
Prerequisites

    Azure CLI installed and authenticated (az login).

    Terraform CLI (v1.5.0+) installed.

    Appropriate permissions on your Azure Subscription.

Step 1: Initialize Remote State

Run the provided setup script. This creates the Storage Account required to hold your .tfstate file and initializes Terraform with a partial backend configuration.
 chmod +x setup.sh
./setup.sh

 Gemini said

This is a professional-grade README designed for a DevOps repository. It explains the "Why" and "How" of your architecture, making it suitable for both your personal project and your AZ-104 certification portfolio.
Azure Automated Web-App & PostgreSQL Infrastructure

This repository contains a modularized Terraform configuration to deploy a secure, high-availability web application environment on Microsoft Azure. It leverages VNet Integration and Private DNS to ensure the database remains entirely isolated from the public internet while remaining accessible to the App Service.
📝 Architecture Overview

The infrastructure is designed with security and scalability as priorities:

    Network Isolation: * A Virtual Network (VNet) with two dedicated subnets.

        App Subnet: Configured with Microsoft.Web/serverFarms delegation for regional VNet integration.

        DB Subnet: Configured with Microsoft.DBforPostgreSQL/flexibleServers delegation.

    Database Security: The PostgreSQL Flexible Server has public_network_access_enabled = false. It is only reachable via its private IP within the VNet.

    Service Connectivity: The App Service uses VNet Integration to route outbound traffic into the VNet, resolving the database's FQDN via a Private DNS Zone.

    State Management: Terraform state is stored remotely in an Azure Blob Storage container with state locking enabled to prevent concurrent execution conflicts.

📂 Project Structure
Plaintext

.
├── bootstrap/            # One-time setup for remote state storage
├── modules/
│   ├── network/          # VNet, Subnets, and Private DNS
│   ├── postgres/         # Private PostgreSQL Flexible Server
│   └── app_service/      # Linux Web App & App Service Plan
├── main.tf               # Root module orchestrating the deployment
├── providers.tf          # AzureRM and Random provider configurations
├── variables.tf          # Global input definitions
├── outputs.tf            # Web App URL and DB FQDN
└── setup.sh              # Automation script for backend initialization

🚀 Deployment Steps
Prerequisites

    Azure CLI installed and authenticated (az login).

    Terraform CLI (v1.5.0+) installed.

    Appropriate permissions on your Azure Subscription.

Step 1: Initialize Remote State

Run the provided setup script. This creates the Storage Account required to hold your .tfstate file and initializes Terraform with a partial backend configuration.
Bash

chmod +x setup.sh
./setup.sh

Step 2: Configure Variables

Create a terraform.tfvars file in the root directory:
project_name = "my-secure-app"
location     = "eastus"
db_password  = "YourSecurePassword123!"

Step 3: Deploy Infrastructure

terraform plan
terraform apply -auto-approve

🔑 Accessing the Services

Once the deployment is complete, Terraform will output the following details:
1. Web Application

The URL will be provided in the output final_webapp_url.

    Access: Open the URL in any browser.

    Note: The app is public, but its connection to the database is handled internally over the Azure backbone.

2. Private Database

The database cannot be accessed from your local machine (unless you use a VPN or Bastion).

    Internal FQDN: [project-name]-db-private.[project-name].postgres.database.azure.com

    Verification: To test connectivity, use the SSH tool in the Azure Portal for your Web App and run:
    curl -v telnet://[DB_FQDN]:5432

🛠 Maintenance & Clean up

To update the infrastructure (e.g., changing the App Service SKU), modify the variables and run terraform apply.

To destroy all resources and avoid ongoing Azure costs:

terraform destroy

