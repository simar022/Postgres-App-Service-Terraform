output "webapp_url" {
  description = "The primary production URL (Always created)"
  value       = "https://${azurerm_linux_web_app.app.default_hostname}"
}

output "staging_slot_url" {
  description = "The URL for the staging slot (Only in 'prod' environment)"
  # 'one' returns the string if count is 1, or 'null' if count is 0
  value       = one(azurerm_linux_web_app_slot.staging[*].default_hostname) != null ? "https://${one(azurerm_linux_web_app_slot.staging[*].default_hostname)}" : "Slot Not Created (Basic SKU)"
}

output "dev_slot_url" {
  description = "The URL for the dev slot (Only in 'prod' environment)"
  value       = one(azurerm_linux_web_app_slot.dev[*].default_hostname) != null ? "https://${one(azurerm_linux_web_app_slot.dev[*].default_hostname)}" : "Slot Not Created (Basic SKU)"
}

output "webapp_hostname" {
  description = "The default hostname of the web app"
  value       = azurerm_linux_web_app.app.default_hostname
}

# Add these as well to support your Staging/Dev logic
output "staging_hostname" {
  value = one(azurerm_linux_web_app_slot.staging[*].default_hostname)
}

output "dev_hostname" {
  value = one(azurerm_linux_web_app_slot.dev[*].default_hostname)
}