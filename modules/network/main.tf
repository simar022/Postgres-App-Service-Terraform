resource "azurerm_virtual_network" "vnet" {
  name                = "${var.project_name}-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = var.location
  resource_group_name = var.resource_group_name
}

resource "azurerm_subnet" "app_subnet" {
  name                 = "snet-app"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]

  delegation {
    name = "appservice-delegation"
    service_delegation {
      name    = "Microsoft.Web/serverFarms"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }
}

resource "azurerm_subnet" "db_subnet" {
  name                 = "snet-db"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.2.0/24"]

  delegation {
    name = "fs-delegation"
    service_delegation {
      name    = "Microsoft.DBforPostgreSQL/flexibleServers"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }
}

resource "azurerm_private_dns_zone" "db_zone" {
  name                = "${var.project_name}.postgres.database.azure.com"
  resource_group_name = var.resource_group_name
}

resource "azurerm_private_dns_zone_virtual_network_link" "link" {
  name                  = "db-vnet-link"
  private_dns_zone_name = azurerm_private_dns_zone.db_zone.name
  resource_group_name   = var.resource_group_name
  virtual_network_id    = azurerm_virtual_network.vnet.id
}
