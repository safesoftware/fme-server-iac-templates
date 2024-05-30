output "private_ip_address" {
  value       = azurerm_lb.fme_flow.private_ip_address
  description = "Private IP address of the load balancer"
}

output "be_address_pool_id" {
  value       = azurerm_lb_backend_address_pool.fme_flow.id
  description = "Backend address poll id of the load balancer"
}
