locals {
  default_tags = { owner = var.owner }
}

resource "random_string" "st_name" {
  length  = 8
  lower   = false
  upper   = false
  special = false
}

resource "azurerm_storage_account" "fme_flow" {
  name                     = format("fmeflow%s", random_string.st_name.result)
  resource_group_name      = var.rg_name
  location                 = var.location
  account_kind             = "FileStorage"
  account_tier             = "Premium"
  account_replication_type = "LRS"

  network_rules {
    default_action             = "Deny"
    bypass                     = ["AzureServices"]
    virtual_network_subnet_ids = [var.be_snet_id]
    ip_rules                   = [var.build_agent_public_ip]
  }

  tags = local.default_tags
}

resource "azurerm_storage_share" "fme_flow" {
  name                 = "fmeflowdata"
  storage_account_name = azurerm_storage_account.fme_flow.name
  quota                = 100
}