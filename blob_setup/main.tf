provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "tfstate" {
  name     = "tfstate-rg"
  location = "Central India"
}

resource "azurerm_storage_account" "tfstate" {
  name                     = "tfstate${random_string.tfstate_suffix.result}"
  resource_group_name      = azurerm_resource_group.tfstate.name
  location                 = azurerm_resource_group.tfstate.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "tfstate" {
  name                  = "terraform-state"
  storage_account_id    = azurerm_storage_account.tfstate.id
  container_access_type = "private"
}

resource "random_string" "tfstate_suffix" {
  length  = 6
  special = false
  upper   = false
}

output "storage_account_name" {
  value = azurerm_storage_account.tfstate.name
}
