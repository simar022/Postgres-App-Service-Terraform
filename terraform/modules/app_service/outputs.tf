output "webapp_hostname" {
  value       = azurerm_linux_web_app.app.default_hostname
}

output "staging_hostname" {
  value = one(azurerm_linux_web_app_slot.staging[*].default_hostname)
}

output "dev_hostname" {
  value = one(azurerm_linux_web_app_slot.dev[*].default_hostname)
}