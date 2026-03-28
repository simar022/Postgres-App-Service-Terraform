resource "azurerm_postgresql_flexible_server" "db" {
  name                   = var.server_name
  resource_group_name    = var.resource_group_name
  location               = var.location
  version                = var.db_version
  administrator_login    = var.db_user
  administrator_password = var.db_password
  private_dns_zone_id    = var.dns_zone_id
  delegated_subnet_id    = var.subnet_id
  public_network_access_enabled = false
  sku_name   = var.sku_name
  storage_mb = var.storage_mb
  backup_retention_days        = 7
  geo_redundant_backup_enabled = false

  lifecycle {
    ignore_changes = [
      zone,
      high_availability[0].standby_availability_zone
    ]
  }
}
resource "azurerm_postgresql_flexible_server_firewall_rule" "allow_app_subnet" {
  name             = "allow-app-vnet"
  server_id        = azurerm_postgresql_flexible_server.db.id
  start_ip_address = "10.0.1.0"
  end_ip_address   = "10.0.1.255"
}

