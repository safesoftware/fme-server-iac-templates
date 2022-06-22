output private_ip_address {
  value       = azurerm_lb.fme_server_dist.private_ip_address
  description = "Private IP address of the load balancer"
}

output be_address_pool_id {
  value       = azurerm_lb_backend_address_pool.fme_server_dist.id
  description = "Backend address poll id of the load balancer"
}
