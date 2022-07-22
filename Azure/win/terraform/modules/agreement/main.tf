resource "azurerm_marketplace_agreement" "fme_corem" {
  publisher = "safesoftwareinc"
  offer     = "fme-core"
  plan      = "fme-engine-2022-0-0-2-windows-byol"
}

resource "azurerm_marketplace_agreement" "fme_engine" {
  publisher = "safesoftwareinc"
  offer     = "fme-engine"
  plan      = "fme-engine-2022-0-0-2-windows-byol"
}