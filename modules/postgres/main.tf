resource "azurerm_postgresql_flexible_server" "db" {
  name                   = "${var.project_name}-db-private"
  resource_group_name    = var.resource_group_name
  location               = var.location
  version                = "14"
  administrator_login    = var.db_user
  administrator_password = var.db_password
  private_dns_zone_id    = var.dns_zone_id
  delegated_subnet_id    = var.subnet_id
  public_network_access_enabled = false
  sku_name   = "B_Standard_B1ms"
  storage_mb = 32768
}
