output "db_url" {
  value     = "postgresql://admin_user:${var.db_password}@${azurerm_postgresql_flexible_server.db.fqdn}:5432/postgres?sslmode=require"
  sensitive = true
}

output "db_host" {
  description = "The FQDN of the PostgreSQL server"
  value       = azurerm_postgresql_flexible_server.db.fqdn
}