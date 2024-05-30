locals {
  default_tags = { owner = var.owner }
}

resource "azurerm_windows_virtual_machine_scale_set" "fme_flow_core" {
  name                = "core"
  resource_group_name = var.rg_name
  location            = var.location
  sku                 = "Standard_D2s_v3"
  instances           = var.instance_count_core
  admin_password      = var.vm_admin_pw
  admin_username      = var.vm_admin_user

  os_disk {
    storage_account_type = "Premium_LRS"
    caching              = "ReadWrite"
  }

  network_interface {
    name    = "nic-core"
    primary = true

    ip_configuration {
      name                                         = "ipconfig"
      primary                                      = true
      subnet_id                                    = var.be_snet_id
      load_balancer_backend_address_pool_ids       = [var.lb_be_address_pool_id]
      application_gateway_backend_address_pool_ids = var.agw_backend_address_pool_ids
    }
  }

  # To use a custom source_image_id instead of the Azure Marketplace image the 'source_image_reference' and 'plan' blocks need to be commented
  # source_image_id = ""
  source_image_reference {
    
    publisher = "safesoftwareinc"
    offer     = "fme-core"
    sku       = "fme-core-2024-0-2-1-windows-byol"
    version   = "latest"
  }

  plan {
    name      = "fme-core-2024-0-2-1-windows-byol"
    publisher = "safesoftwareinc"
    product   = "fme-core"
  }

  extension {
    name                 = "core-script"
    publisher            = "Microsoft.Compute"
    type                 = "CustomScriptExtension"
    type_handler_version = "1.8"
    protected_settings = jsonencode({
      "commandToExecute" = format("powershell -ExecutionPolicy Unrestricted -File C:\\config_fmeflow_confd.ps1 -databasehostname %s -databasePassword %s -databaseUsername %s -externalhostname %s -storageAccountName %s -storageAccountKey %s >C:\\confd-log.txt 2>&1", var.db_fqdn, var.db_admin_pw, var.db_admin_user, var.fqdn, var.storage_name, var.storage_key)
    })
  }

  tags = local.default_tags
}
