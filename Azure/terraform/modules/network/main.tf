locals {
  default_tags = { owner = var.owner }
}

resource "azurerm_virtual_network" "fme_flow" {
  name                = var.vnet_name
  address_space       = ["10.0.0.0/16"]
  location            = var.location
  resource_group_name = var.rg_name

  tags = local.default_tags
}

resource "azurerm_subnet" "fme_flow_be" {
  name                 = var.be_snet_name
  resource_group_name  = var.rg_name
  virtual_network_name = azurerm_virtual_network.fme_flow.name
  address_prefixes     = ["10.0.0.0/24"]
  service_endpoints    = ["Microsoft.Storage", "Microsoft.Sql"]
}

resource "azurerm_subnet" "fme_flow_agw" {
  name                 = var.agw_snet_name
  resource_group_name  = var.rg_name
  virtual_network_name = azurerm_virtual_network.fme_flow.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_public_ip" "fme_flow" {
  name                    = var.pip_name
  resource_group_name     = var.rg_name
  location                = var.location
  allocation_method       = "Dynamic"
  sku                     = "Basic"
  domain_name_label       = var.domain_name_label
  idle_timeout_in_minutes = 30

  tags = local.default_tags
}