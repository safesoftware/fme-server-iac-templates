locals {
  default_tags = { owner = var.owner }
}

resource "random_string" "db_name" {
  length  = 8
  upper   = false
  special = false
}

resource "azurerm_postgresql_server" "fme_flow" {
  name                         = format("fmeflow-psql-%s", random_string.db_name.result)
  resource_group_name          = var.rg_name
  location                     = var.location
  administrator_login          = var.db_admin_user
  administrator_login_password = var.db_admin_pw
  sku_name                     = "GP_Gen5_2"
  version                      = "10"
  storage_mb                   = 51200
  ssl_enforcement_enabled      = true

  tags = local.default_tags
}

resource "azurerm_postgresql_virtual_network_rule" "fme_flow" {
  name                                 = "postgresql-vnet-rule"
  resource_group_name                  = var.rg_name
  server_name                          = azurerm_postgresql_server.fme_flow.name
  subnet_id                            = var.be_snet_id
  ignore_missing_vnet_service_endpoint = true
}