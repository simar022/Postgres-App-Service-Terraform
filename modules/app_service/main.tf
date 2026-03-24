resource "azurerm_service_plan" "plan" {
  name                = "${var.project_name}-plan"
  resource_group_name = var.resource_group_name
  location            = var.location
  os_type             = "Linux"
  sku_name            = "B1" 
}

resource "azurerm_linux_web_app" "web" {
  name                = "${var.project_name}-webapp"
  resource_group_name = var.resource_group_name
  location            = var.location
  service_plan_id     = azurerm_service_plan.plan.id

  virtual_network_subnet_id = var.app_subnet_id

  site_config {
    vnet_route_all_enabled = true 
  }

  app_settings = {
    "DATABASE_URL" = var.db_url
  }
}
