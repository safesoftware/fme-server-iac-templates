output "name" {
  value       = azurerm_storage_account.fme_flow.name
  description = "Name of the Azure storage account for the FME Sever file share"
}

output "primary_access_key" {
  value       = azurerm_storage_account.fme_flow.primary_access_key
  sensitive   = true
  description = "The primary access key for the storage account."
}
