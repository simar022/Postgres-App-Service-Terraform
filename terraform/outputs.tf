output "app_endpoints" {
  value = {
    production = "https://${module.app_service.webapp_hostname}"
    staging    = var.environment == "dev" ? "https://${module.app_service.staging_hostname}" : "N/A"
    dev        = var.environment == "dev" ? "https://${module.app_service.dev_hostname}" : "N/A"
  }
}

output "database_fqdn" {
  value = module.database.db_host
}
