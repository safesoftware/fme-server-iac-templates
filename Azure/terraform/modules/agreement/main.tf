resource "azurerm_marketplace_agreement" "fme_corem" {
  publisher = "safesoftwareinc"
  offer     = "fme-core"
  plan      = "fme-engine-2024-1-2-1-windows-byol"
}

resource "azurerm_marketplace_agreement" "fme_engine" {
  publisher = "safesoftwareinc"
  offer     = "fme-engine"
  plan      = "fme-engine-2024-1-2-1-windows-byol"
}