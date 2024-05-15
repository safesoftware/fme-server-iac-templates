output "vnet_name" {
  value       = azurerm_virtual_network.fme_flow.name
  description = "Virtual network name"
}

output "be_snet_id" {
  value       = azurerm_subnet.fme_flow_be.id
  description = "Backend virtual network subnet id"
}

output "agw_snet_id" {
  value       = azurerm_subnet.fme_flow_agw.id
  description = "Application gateway virtual network subnet id"
}

output "pip_id" {
  value       = azurerm_public_ip.fme_flow.id
  description = "Public ip id"
}

output "fqdn" {
  value       = azurerm_public_ip.fme_flow.fqdn
  description = "Fully qualified domain name of the A DNS record associated with the public IP."
}
