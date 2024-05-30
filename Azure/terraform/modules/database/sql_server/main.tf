locals {
  default_tags = { owner = var.owner }
}

resource "random_string" "db_name" {
  length  = 8
  upper   = false
  special = false
}

resource "azurerm_mssql_server" "fme_flow_dist" {
  name                         = format("fmeflow-sql-%s", random_string.db_name.result)
  resource_group_name          = var.rg_name
  location                     = var.location
  version                      = "12.0"
  administrator_login          = var.db_admin_user
  administrator_login_password = var.db_admin_pw

  tags = local.default_tags
}

resource "azurerm_mssql_virtual_network_rule" "fme_flow_dist" {
  name      = "sql-vnet-rule"
  server_id = azurerm_mssql_server.fme_flow_dist.id
  subnet_id = var.be_snet_id
}

resource "azurerm_mssql_database" "fme_flow_dist" {
  name         = "fmeflow"
  server_id    = azurerm_mssql_server.fme_flow_dist.id
  collation    = "SQL_Latin1_General_CP1_CI_AS"
  license_type = "LicenseIncluded"
  max_size_gb  = 2
  sku_name     = "Basic"

  tags = local.default_tags

}