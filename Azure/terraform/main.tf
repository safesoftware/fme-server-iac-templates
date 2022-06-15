terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.9.0"
    }
  }

  required_version = ">= 1.1.0"
}

provider "azurerm" {
  features {}
}

locals {
  backend_address_pool_name      = "${module.network.vnet_name}-beap"
  http_frontend_port_name        = "${module.network.vnet_name}-http-feport"
  ws_frontend_port_name          = "${module.network.vnet_name}-ws-feport"
  frontend_ip_configuration_name = "${module.network.vnet_name}-feip"
  http_setting_name              = "${module.network.vnet_name}-be-htst"
  ws_setting_name                = "${module.network.vnet_name}-be-wsst"
  http_listener_name             = "${module.network.vnet_name}-httplstn"
  ws_listener_name               = "${module.network.vnet_name}-wslstn"
  http_request_routing_rule_name = "${module.network.vnet_name}-http-rqrt"
  ws_request_routing_rule_name   = "${module.network.vnet_name}-ws-rqrt"
  redirect_configuration_name    = "${module.network.vnet_name}-rdrcfg"
  default_tags                   = { owner = var.owner }
}

resource "azurerm_resource_group" "fme_server_dist" {
  name     = var.rg_name
  location = var.location

  tags = local.default_tags
}

module network {
  source = "./modules/network"
  owner             = var.owner 
  rg_name           = azurerm_resource_group.fme_server_dist.name
  location          = azurerm_resource_group.fme_server_dist.location
  vnet_name         = var.vnet_name
  be_snet_name      = var.be_snet_name
  agw_snet_name     = var.agw_snet_name
  pip_name          = var.pip_name
  domain_name_label = var.domain_name_label
}

module storage {
  source = "./modules/storage"
  owner         = var.owner 
  rg_name       = azurerm_resource_group.fme_server_dist.name
  location      = azurerm_resource_group.fme_server_dist.location
  be_snet_id    = module.network.be_snet_id
}

module database {
  source        = "./modules/database"
  owner         = var.owner 
  rg_name       = azurerm_resource_group.fme_server_dist.name
  location      = azurerm_resource_group.fme_server_dist.location
  be_snet_id    = module.network.be_snet_id
  db_admin_user = var.db_admin_user
  db_admin_pw   = var.db_admin_pw
}

resource "azurerm_lb" "fme_server_dist" {
  name                = var.lb_name
  location            = azurerm_resource_group.fme_server_dist.location
  resource_group_name = azurerm_resource_group.fme_server_dist.name

  frontend_ip_configuration {
    name                          = var.engine_registration_lb_frontend_name
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = module.network.be_snet_id
  }

  tags = local.default_tags
}

resource "azurerm_lb_backend_address_pool" "fme_server_dist" {
  loadbalancer_id = azurerm_lb.fme_server_dist.id
  name            = var.engine_registration_lb_backend_name
}

resource "azurerm_lb_rule" "example" {
  loadbalancer_id                = azurerm_lb.fme_server_dist.id
  name                           = "roundRobinEngineRegistrationRule"
  protocol                       = "Tcp"
  frontend_port                  = 7070
  backend_port                   = 7070
  frontend_ip_configuration_name = var.engine_registration_lb_frontend_name
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.fme_server_dist.id]
  idle_timeout_in_minutes        = 30
}

resource "azurerm_application_gateway" "fme_server_dist" {
  name                = var.agw_name
  resource_group_name = azurerm_resource_group.fme_server_dist.name
  location            = azurerm_resource_group.fme_server_dist.location

  sku {
    name     = "Standard_Medium"
    tier     = "Standard"
    capacity = 1
  }

  gateway_ip_configuration {
    name      = "my-gateway-ip-configuration"
    subnet_id = module.network.agw_snet_id
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
    public_ip_address_id          = module.network.pip_id
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

resource "azurerm_windows_virtual_machine_scale_set" "fme_server_dist_core" {
  name                = "core"
  resource_group_name = azurerm_resource_group.fme_server_dist.name
  location            = azurerm_resource_group.fme_server_dist.location
  sku                 = "Standard_D2s_v3"
  instances           = 2
  admin_password      = var.vm_admin_pw
  admin_username      = var.vm_admin_user

  os_disk {
    storage_account_type = "Premium_LRS"
    caching              = "ReadWrite"
  }

  network_interface {
    name    = "nic-core"
    primary = true

    ip_configuration {
      name                                         = "ipconfig"
      primary                                      = true
      subnet_id                                    = module.network.be_snet_id
      load_balancer_backend_address_pool_ids       = [azurerm_lb_backend_address_pool.fme_server_dist.id]
      application_gateway_backend_address_pool_ids = azurerm_application_gateway.fme_server_dist.backend_address_pool[*].id
    }
  }

  source_image_reference {
    publisher = "safesoftwareinc"
    offer     = "fme-core"
    sku       = "fme-core-2022-0-0-2-windows-byol"
    version   = "latest"
  }

  plan {
    name      = "fme-core-2022-0-0-2-windows-byol"
    publisher = "safesoftwareinc"
    product   = "fme-core"
  }

  extension {
    name                 = "core-script"
    publisher            = "Microsoft.Compute"
    type                 = "CustomScriptExtension"
    type_handler_version = "1.8"
    settings = jsonencode({
      "commandToExecute" = format("powershell -ExecutionPolicy Unrestricted -File C:\\config_fmeserver_confd.ps1 -databasehostname %s -databasePassword %s -databaseUsername %s -externalhostname %s -storageAccountName %s -storageAccountKey %s >C:\\confd-log.txt 2>&1", module.database.fqdn, var.db_admin_pw, var.db_admin_user, module.network.fqdn, module.storage.name, module.storage.primary_access_key)
    })
  }

  tags = local.default_tags
}

resource "azurerm_windows_virtual_machine_scale_set" "fme_server_dist_engine" {
  name                = "engine"
  resource_group_name = azurerm_resource_group.fme_server_dist.name
  location            = azurerm_resource_group.fme_server_dist.location
  sku                 = "Standard_D2s_v3"
  instances           = 2
  admin_password      = var.vm_admin_pw
  admin_username      = var.vm_admin_user

  os_disk {
    storage_account_type = "Premium_LRS"
    caching              = "ReadWrite"
  }

  network_interface {
    name    = "nic-engine"
    primary = true

    ip_configuration {
      name      = "ipconfig"
      primary   = true
      subnet_id = module.network.be_snet_id
    }
  }

  source_image_reference {
    publisher = "safesoftwareinc"
    offer     = "fme-engine"
    sku       = "fme-engine-2022-0-0-2-windows-byol"
    version   = "latest"
  }

  plan {
    name      = "fme-engine-2022-0-0-2-windows-byol"
    publisher = "safesoftwareinc"
    product   = "fme-engine"
  }

  extension {
    name                 = "engine-script"
    publisher            = "Microsoft.Compute"
    type                 = "CustomScriptExtension"
    type_handler_version = "1.8"
    settings = jsonencode({
      "commandToExecute" = format("powershell -ExecutionPolicy Unrestricted -File C:\\config_fmeserver_confd_engine.ps1 -databasehostname %s -engineregistrationhost %s -storageAccountName %s -storageAccountKey %s >C:\\confd-log.txt 2>&1", module.database.fqdn, azurerm_lb.fme_server_dist.private_ip_address, module.storage.name, module.storage.primary_access_key)
    })
  }

  tags = local.default_tags
}