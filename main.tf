locals {
  app_sku      = var.environment == "prod" ? "S1" : "B1"
  db_sku       = var.environment == "prod" ? "B_Standard_B1ms" : "GP_Standard_D2ds_v4"
  node_version = "24-lts"
  resource_group_name = "${var.project_name}-${var.environment}-rg"
}

module "network" {
  source              = "./modules/network"
  project_name        = var.project_name
  location            = var.location
  resource_group_name = local.resource_group_name
}

module "database" {
  source              = "./modules/postgres"
  project_name        = var.project_name
  server_name         = "${var.project_name}-db"
  resource_group_name = local.resource_group_name
  location            = var.location
  sku_name            = local.db_sku
  db_user             = "psqladmin"
  db_password         = var.db_password
  subnet_id           = module.network.db_subnet_id 
  dns_zone_id         = module.network.dns_zone_id
}

module "app_service" {
  source              = "./modules/app_service"
  project_name        = var.project_name
  location            = var.location
  resource_group_name = local.resource_group_name
  
  sku_name            = local.app_sku
  node_version        = local.node_version
  app_subnet_id       = module.network.app_subnet_id 
  db_url              = module.database.db_url        
  environment         = var.environment
}