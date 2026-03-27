resource "azurerm_service_plan" "plan" {
  name                = "${var.project_name}-plan"
  resource_group_name = var.resource_group_name
  location            = var.location
  os_type             = "Linux"
  sku_name = var.environment == "prod" ? "S1" : "B1" 
}

resource "azurerm_linux_web_app" "app" {
  name                = "${var.project_name}-webapp"
  resource_group_name = var.resource_group_name
  location            = var.location
  service_plan_id     = azurerm_service_plan.plan.id

  virtual_network_subnet_id = var.app_subnet_id

  site_config {
    vnet_route_all_enabled = true 
    application_stack {
      node_version = "24-lts"
    }
  }

  app_settings = {
    "DATABASE_URL" = var.db_url
    "WEBSITES_PORT" = "8080"
    "NODE_ENV"     = "staging"
  }
}

resource "azurerm_linux_web_app_slot" "staging" {
  count          = var.environment == "prod" ? 1 : 0
  name           = "staging"
  app_service_id = azurerm_linux_web_app.app.id
  virtual_network_subnet_id = var.app_subnet_id

  site_config {
    vnet_route_all_enabled = true
    app_command_line = "npm start"
    application_stack {
      node_version = "24-lts"
    }
  }
  app_settings = azurerm_linux_web_app.app.app_settings
}

resource "azurerm_linux_web_app_slot" "dev" {
  count          = var.environment == "prod" ? 1 : 0
  
  name           = "dev"
  app_service_id = azurerm_linux_web_app.app.id
  virtual_network_subnet_id = var.app_subnet_id

  site_config {
    vnet_route_all_enabled = true
    app_command_line = "npm start"
    application_stack {
      node_version = "24-lts"
    }
  }
  app_settings = azurerm_linux_web_app.app.app_settings
}
