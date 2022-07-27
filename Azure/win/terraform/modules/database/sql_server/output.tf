output "fqdn" {
  value       = azurerm_mssql_server.fme_server_dist.fully_qualified_domain_name
  description = "Fully qualified domain name of the SQL Server"
}
