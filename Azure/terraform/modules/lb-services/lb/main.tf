locals {
  default_tags = { owner = var.owner }
}

resource "azurerm_lb" "fme_flow" {
  name                = var.lb_name
  location            = var.location
  resource_group_name = var.rg_name

  frontend_ip_configuration {
    name                          = "engineRegistrationFrontend"
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = var.be_snet_id
  }

  tags = local.default_tags
}

resource "azurerm_lb_backend_address_pool" "fme_flow" {
  loadbalancer_id = azurerm_lb.fme_flow.id
  name            = "engineRegistrationBackend"
}

resource "azurerm_lb_rule" "fme_flow" {
  loadbalancer_id                = azurerm_lb.fme_flow.id
  name                           = "roundRobinEngineRegistrationRule"
  protocol                       = "Tcp"
  frontend_port                  = 7070
  backend_port                   = 7070
  frontend_ip_configuration_name = "engineRegistrationFrontend"
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.fme_flow.id]
  idle_timeout_in_minutes        = 30
}