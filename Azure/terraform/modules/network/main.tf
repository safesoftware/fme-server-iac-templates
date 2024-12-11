locals {
  default_tags = { owner = var.owner }
}

resource "azurerm_public_ip" "fme_flow" {
  name                    = var.pip_name
  resource_group_name     = var.rg_name
  location                = var.location
  allocation_method       = "Static"
  sku                     = "Standard"
  domain_name_label       = var.domain_name_label
  idle_timeout_in_minutes = 30

  tags = local.default_tags
}

resource "azurerm_public_ip" "fmeflow_ng_pip" {
  name                = var.publicip_nat_name
  location            = var.location
  resource_group_name = var.rg_name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_nat_gateway" "fmeflow_ng" {
  name                    = var.nat_gateway_name
  location                = var.location
  resource_group_name     = var.rg_name
  sku_name                = "Standard"
  idle_timeout_in_minutes = 10
}

resource "azurerm_nat_gateway_public_ip_association" "fmeflow_ngpip_asc" {
  nat_gateway_id       = azurerm_nat_gateway.fmeflow_ng.id
  public_ip_address_id = azurerm_public_ip.fmeflow_ng_pip.id
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
  private_endpoint_network_policies = "Enabled"
  service_endpoints    = ["Microsoft.Storage", "Microsoft.Sql"]
}

resource "azurerm_subnet_nat_gateway_association" "fmeflow_subnet_ng_asc" {
  subnet_id      = azurerm_subnet.fme_flow_be.id
  nat_gateway_id = azurerm_nat_gateway.fmeflow_ng.id
}

resource "azurerm_subnet" "fme_flow_agw" {
  name                 = var.agw_snet_name
  resource_group_name  = var.rg_name
  virtual_network_name = azurerm_virtual_network.fme_flow.name
  private_endpoint_network_policies = "Enabled"
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_subnet" "fme_flow_pgsql" {
  name                 = var.pgsql_snet_name
  resource_group_name  = var.rg_name
  virtual_network_name = azurerm_virtual_network.fme_flow.name
  address_prefixes     = ["10.0.2.0/28"]
  private_endpoint_network_policies = "Enabled"
  service_endpoints    = ["Microsoft.Storage", "Microsoft.Sql"]
  delegation {
    name = "fs"
    service_delegation {
      name = "Microsoft.DBforPostgreSQL/flexibleServers"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action",
      ]
    }
  }
}

resource "azurerm_private_dns_zone" "dns_zone" {
  name                = "${var.dns_zone_name}.postgres.database.azure.com"
  resource_group_name = var.rg_name
}

resource "azurerm_private_dns_zone_virtual_network_link" "dns_zone_vlink" {
  name                  = var.vnet_name
  private_dns_zone_name = azurerm_private_dns_zone.dns_zone.name
  resource_group_name   = var.rg_name
  virtual_network_id    = azurerm_virtual_network.fme_flow.id
}

