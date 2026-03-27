output "webapp_url" {
  value = azurerm_linux_web_app.app.default_hostname
}

output "staging_slot_url" {
  # Returns the URL if it exists, otherwise returns null
  value = try(azurerm_linux_web_app_slot.staging[0].default_hostname, "Not Created")
}