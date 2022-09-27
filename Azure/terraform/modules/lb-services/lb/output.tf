output "private_ip_address" {
  value       = azurerm_lb.fme_server.private_ip_address
  description = "Private IP address of the load balancer"
}

output "be_address_pool_id" {
  value       = azurerm_lb_backend_address_pool.fme_server.id
  description = "Backend address poll id of the load balancer"
}
