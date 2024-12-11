locals {
  default_tags = { owner = var.owner }
}

resource "random_string" "db_name" {
  length  = 8
  upper   = false
  special = false
}

resource "azurerm_postgresql_flexible_server" "fme_flow" {
  name                          = format("fmeflow-psql-%s", random_string.db_name.result)
  administrator_login           = var.db_admin_user
  administrator_password        = var.db_admin_pw
  create_mode                   = "Default"
  resource_group_name           = var.rg_name
  location                      = var.location
  delegated_subnet_id           = var.pgsql_snet_id
  private_dns_zone_id           = var.dns_zone_id
  public_network_access_enabled = false
  version                       = "16"
  storage_mb                    = 32768
  sku_name                      = "GP_Standard_D4s_v3"
  tags = local.default_tags
}