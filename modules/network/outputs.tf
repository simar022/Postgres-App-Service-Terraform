output "app_subnet_id" {
  value = azurerm_subnet.app_subnet.id
}

output "db_subnet_id" {
  value = azurerm_subnet.db_subnet.id
}

output "dns_zone_id" {
  value = azurerm_private_dns_zone.db_zone.id
}
