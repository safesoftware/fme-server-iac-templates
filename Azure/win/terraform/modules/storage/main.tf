locals {
  default_tags = { owner = var.owner }
}

resource "random_string" "st_name" {
  length  = 8
  lower   = false
  upper   = false
  special = false
}

resource "azurerm_storage_account" "fme_server" {
  name                     = format("fmeserver%s", random_string.st_name.result)
  resource_group_name      = var.rg_name
  location                 = var.location
  account_kind             = "FileStorage"
  account_tier             = "Premium"
  account_replication_type = "LRS"

  network_rules {
    default_action             = "Deny"
    bypass                     = ["AzureServices"]
    virtual_network_subnet_ids = [var.be_snet_id]
    ip_rules                   = ["50.68.182.79"]
  }

  tags = local.default_tags
}

resource "azurerm_storage_share" "fme_server" {
  name                 = "fmeserverdata"
  storage_account_name = azurerm_storage_account.fme_server.name
  quota                = 100
}