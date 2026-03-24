terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
    
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
  
  backend "azurerm" {
    resource_group_name  = "tfstate-rg"
    storage_account_name = "tfstate6nbobi"
    container_name       = "terraform-state"
    key                  = "prod.terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
}
