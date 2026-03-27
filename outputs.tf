output "app_endpoints" {
  value = {
    production = "https://${module.app_service.webapp_hostname}"
    staging    = var.environment == "prod" ? "https://${module.app_service.staging_hostname}" : "N/A"
    dev        = var.environment == "prod" ? "https://${module.app_service.dev_hostname}" : "N/A"
  }
}

output "database_fqdn" {
  value = module.database.db_host
}

output "app_urls" {
  description = "Final deployment endpoints for the HealthSync project"
  value = {
    production = module.app_service.webapp_url
    staging    = module.app_service.staging_slot_url
    dev        = module.app_service.dev_slot_url
  }
}