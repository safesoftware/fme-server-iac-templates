output "fqdn" {
  value       = azurerm_postgresql_flexible_server.fme_flow.fqdn
  description = "Fully qualified domain name of the postgresql database server"
}
