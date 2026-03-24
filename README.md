# 🌐 Azure Automated Web-App & PostgreSQL Infrastructure

This repository contains a modularized **Terraform** configuration to deploy a secure, high-availability web application environment on **Microsoft Azure**. It leverages **VNet Integration** and **Private DNS** to ensure the database remains entirely isolated from the public internet while remaining accessible to the App Service.

---

## 🏗️ Architecture Overview

The infrastructure is designed with security and scalability as core priorities:

* **Network Isolation**
    * **Virtual Network (VNet)**: Contains two dedicated subnets for tier separation.
    * **App Subnet**: Configured with `Microsoft.Web/serverFarms` delegation for regional VNet integration.
    * **DB Subnet**: Configured with `Microsoft.DBforPostgreSQL/flexibleServers` delegation for private injection.
* **Database Security**
    * The PostgreSQL Flexible Server has `public_network_access_enabled = false`.
    * It is reachable **only** via its private IP within the internal network.
* **Service Connectivity**
    * The App Service uses **VNet Integration** to route outbound traffic into the VNet.
    * Resolves the database's FQDN via a **Private DNS Zone**.
* **State Management**
    * Terraform state is stored remotely in an **Azure Blob Storage** container.
    * **State Locking** is enabled via Blob Lease to prevent concurrent execution conflicts.

---

## 📂 Project Structure

```text
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

```

---

## 🚀 Deployment Steps

**Prerequisites**

1.  Azure CLI installed and authenticated (az login).

2.  Terraform CLI (v1.5.0+) installed.

3.  Appropriate permissions on your Azure Subscription.

**Step 1: Initialize Remote State**

Run the provided setup script. This creates the Storage Account required to hold your *.tfstate* file and initializes Terraform with a partial backend configuration.

chmod +x setup.sh
./setup.sh

**Step 2: Configure Variables**

Create a terraform.tfvars file in the root directory:

project_name = "my-secure-app"
location     = "eastus"
db_password  = "YourSecurePassword123!"

**Step 3: Deploy Infrastructure**

terraform plan
terraform apply -auto-approve

---

## 🔑 Accessing the Services

Once the deployment is complete, Terraform will output the following details:

* **1. Web Application**

The URL will be provided in the output final_webapp_url.

    Access: Open the URL in any browser.

    Note: The app is public, but its connection to the database is handled internally over the Azure backbone.

* **2. Private Database**

The database cannot be accessed from your local machine (unless you use a VPN or Bastion).

    Internal FQDN: [project-name]-db-private.[project-name].postgres.database.azure.com

    Verification: To test connectivity, use the SSH tool in the Azure Portal for your Web App and run:
    
    curl -v telnet://[DB_FQDN]:5432

---
   
## 🛠 Maintenance & Clean up

To update the infrastructure (e.g., changing the App Service SKU), modify the variables and run terraform apply.

To destroy all resources and avoid ongoing Azure costs:

terraform destroy
