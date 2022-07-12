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
    default_tags                   = { owner = var.owner }
}

resource "azurerm_resource_group" "fme_server" {
  name     = var.rg_name
  location = var.location

  tags = local.default_tags
}

module network {
  source = "./modules/network"
  owner             = var.owner 
  rg_name           = azurerm_resource_group.fme_server.name
  location          = azurerm_resource_group.fme_server.location
  vnet_name         = var.vnet_name
  be_snet_name      = var.be_snet_name
  agw_snet_name     = var.agw_snet_name
  pip_name          = var.pip_name
  domain_name_label = var.domain_name_label
}

module storage {
  source = "./modules/storage"
  owner         = var.owner 
  rg_name       = azurerm_resource_group.fme_server.name
  location      = azurerm_resource_group.fme_server.location
  be_snet_id    = module.network.be_snet_id
}

module database {
  source        = "./modules/database/pgsql"
# source        = "./modules/database/sql_server"
  owner         = var.owner 
  rg_name       = azurerm_resource_group.fme_server.name
  location      = azurerm_resource_group.fme_server.location
  be_snet_id    = module.network.be_snet_id
  db_admin_user = var.db_admin_user
  db_admin_pw   = var.db_admin_pw
}

module load_balancer {
  source        = "./modules/lb-services/lb"
  owner         = var.owner 
  rg_name       = azurerm_resource_group.fme_server.name
  location      = azurerm_resource_group.fme_server.location
  lb_name       = var.lb_name
  be_snet_id    = module.network.be_snet_id
}

module application_gateway {
  source        = "./modules/lb-services/agw"
  owner         = var.owner 
  rg_name       = azurerm_resource_group.fme_server.name
  location      = azurerm_resource_group.fme_server.location
  agw_name      = var.agw_name
  agw_snet_id   = module.network.agw_snet_id
  pip_id        = module.network.pip_id
}

module vmss_core {
  source                       = "./modules/vmss/vmss_core"
# source                       = "./modules/vmss/vmss_core_sql_server"
# db_user                      = var.db_user
# db_pw                        = var.db_pw
  owner                        = var.owner 
  rg_name                      = azurerm_resource_group.fme_server.name
  location                     = azurerm_resource_group.fme_server.location
  be_snet_id                   = module.network.be_snet_id
  lb_be_address_pool_id        = module.load_balancer.be_address_pool_id
  agw_backend_address_pool_ids = module.application_gateway.backend_address_pool_ids
  db_admin_user                = var.db_admin_user
  db_admin_pw                  = var.db_admin_pw
  db_fqdn                      = module.database.fqdn
  fqdn                         = module.network.fqdn
  storage_name                 = module.storage.name
  storage_key                  = module.storage.primary_access_key
  vm_admin_pw                  = var.vm_admin_pw
  vm_admin_user                = var.db_admin_user
}

module vmss_engine {
  source                       = "./modules/vmss/vmss_engine"
# source                       = "./modules/vmss/vmss_engine_sql_server"
# db_user                      = var.db_user
# db_pw                        = var.db_pw
  owner                        = var.owner 
  rg_name                      = azurerm_resource_group.fme_server.name
  location                     = azurerm_resource_group.fme_server.location
  be_snet_id                   = module.network.be_snet_id
  db_fqdn                      = module.database.fqdn
  lb_private_ip_address        = module.load_balancer.private_ip_address
  storage_name                 = module.storage.name
  storage_key                  = module.storage.primary_access_key
  vm_admin_pw                  = var.vm_admin_pw
  vm_admin_user                = var.db_admin_user
}