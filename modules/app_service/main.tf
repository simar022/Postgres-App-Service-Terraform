resource "azurerm_service_plan" "plan" {
  name                = "${var.project_name}-plan"
  resource_group_name = var.resource_group_name
  location            = var.location
  os_type             = var.os_type
  sku_name = var.environment == "prod" ? "S1" : "B1" 
}

resource "azurerm_linux_web_app" "app" {
  name                = "${var.project_name}-webapp"
  resource_group_name = var.resource_group_name
  location            = var.location
  service_plan_id     = azurerm_service_plan.plan.id

  site_config {
    vnet_route_all_enabled = true 
    application_stack {
      node_version = var.node_version
    }
  }

  app_settings = {
    "DATABASE_URL" = var.db_url
    "WEBSITES_PORT" = "8080"
    "NODE_ENV"          = var.environment
    "DB_SSL_MODE"       = "require"
    "AZURE_VNET_STATUS" = "Enabled"
  }

  lifecycle {
    ignore_changes = [
      virtual_network_subnet_id,
    ]
  }
}

resource "azurerm_app_service_virtual_network_swift_connection" "vnet_config" {
  app_service_id = azurerm_linux_web_app.app.id
  subnet_id      = var.app_subnet_id

  lifecycle {
    create_before_destroy = true
  }
}

resource "azurerm_linux_web_app_slot" "staging" {
  count          = var.environment == "prod" ? 1 : 0
  name           = "staging"
  app_service_id = azurerm_linux_web_app.app.id
  virtual_network_subnet_id = var.app_subnet_id

  site_config {
    always_on = true
    worker_count = 1
    vnet_route_all_enabled = true
    app_command_line = "npm start"
    application_stack {
      node_version = var.node_version
    }
  }
  app_settings = merge(azurerm_linux_web_app.app.app_settings, {
    "NODE_ENV" = var.environment == "prod" ? "staging" : "development"
  })
}

resource "azurerm_linux_web_app_slot" "dev" {
  count          = var.environment == "prod" ? 1 : 0
  name           = "dev"
  app_service_id = azurerm_linux_web_app.app.id
  virtual_network_subnet_id = var.app_subnet_id

  site_config {
    always_on = true
    worker_count = 1
    vnet_route_all_enabled = true
    app_command_line = "npm start"
    application_stack {
      node_version = var.node_version
    }
  }
  app_settings = merge(azurerm_linux_web_app.app.app_settings, {
    "NODE_ENV" = var.environment == "prod" ? "staging" : "development"
  })
}