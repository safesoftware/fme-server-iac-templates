locals {
  backend_address_pool_name      = "${var.vnet_name}-beap"
  http_frontend_port_name        = "${var.vnet_name}-http-feport"
  ws_frontend_port_name          = "${var.vnet_name}-ws-feport"
  frontend_ip_configuration_name = "${var.vnet_name}-feip"
  http_setting_name              = "${var.vnet_name}-be-htst"
  ws_setting_name                = "${var.vnet_name}-be-wsst"
  http_listener_name             = "${var.vnet_name}-httplstn"
  ws_listener_name               = "${var.vnet_name}-wslstn"
  http_request_routing_rule_name = "${var.vnet_name}-http-rqrt"
  ws_request_routing_rule_name   = "${var.vnet_name}-ws-rqrt"
  redirect_configuration_name    = "${var.vnet_name}-rdrcfg"
  default_tags                   = { owner = var.owner }
}

resource "azurerm_application_gateway" "fme_flow" {
  name                = var.agw_name
  resource_group_name = var.rg_name
  location            = var.location

  sku {
    name     = "Standard_Medium"
    tier     = "Standard"
    capacity = 1
  }

  gateway_ip_configuration {
    name      = "my-gateway-ip-configuration"
    subnet_id = var.agw_snet_id
  }

  frontend_port {
    name = local.http_frontend_port_name
    port = 80
  }

  frontend_port {
    name = local.ws_frontend_port_name
    port = 7078
  }

  frontend_ip_configuration {
    name                          = local.frontend_ip_configuration_name
    public_ip_address_id          = var.pip_id
    private_ip_address_allocation = "Dynamic"
  }

  backend_address_pool {
    name = local.backend_address_pool_name
  }

  probe {
    name                                      = "websocketProbe"
    protocol                                  = "Http"
    path                                      = "/"
    interval                                  = 30
    timeout                                   = 30
    unhealthy_threshold                       = 3
    pick_host_name_from_backend_http_settings = true

    match {
      status_code = ["200-400"]
      body        = ""
    }
  }

  backend_http_settings {
    name                                = local.http_setting_name
    port                                = 8080
    protocol                            = "Http"
    request_timeout                     = 86400
    cookie_based_affinity               = "Disabled"
    pick_host_name_from_backend_address = false
  }

  backend_http_settings {
    name                                = local.ws_setting_name
    port                                = 7078
    protocol                            = "Http"
    request_timeout                     = 86400
    cookie_based_affinity               = "Disabled"
    pick_host_name_from_backend_address = true
    probe_name                          = "websocketProbe"

  }

  http_listener {
    name                           = local.http_listener_name
    frontend_ip_configuration_name = local.frontend_ip_configuration_name
    frontend_port_name             = local.http_frontend_port_name
    protocol                       = "Http"
  }

  http_listener {
    name                           = local.ws_listener_name
    frontend_ip_configuration_name = local.frontend_ip_configuration_name
    frontend_port_name             = local.ws_frontend_port_name
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = local.http_request_routing_rule_name
    rule_type                  = "Basic"
    http_listener_name         = local.http_listener_name
    backend_address_pool_name  = local.backend_address_pool_name
    backend_http_settings_name = local.http_setting_name
  }

  request_routing_rule {
    name                       = local.ws_request_routing_rule_name
    rule_type                  = "Basic"
    http_listener_name         = local.ws_listener_name
    backend_address_pool_name  = local.backend_address_pool_name
    backend_http_settings_name = local.ws_setting_name
  }

  tags = local.default_tags
}
