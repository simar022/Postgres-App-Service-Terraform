resource "azurerm_resource_group" "main" {
  name     = "${var.project_name}-rg"
  location = var.location
}

module "network" {
  source              = "./modules/network"
  project_name        = var.project_name
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
}

module "database" {
  source              = "./modules/postgres"
  project_name        = var.project_name
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  db_user             = "psqladmin"
  db_password         = var.db_password
  subnet_id           = module.network.db_subnet_id
  dns_zone_id         = module.network.dns_zone_id
}

module "app_service" {
  source              = "./modules/app_service"
  project_name        = var.project_name
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  app_subnet_id       = module.network.app_subnet_id
  db_url              = "postgresql://psqladmin:${var.db_password}@${module.database.db_fqdn}:5432/postgres"
}
