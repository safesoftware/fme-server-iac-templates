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

  source_image_reference {
    publisher = "safesoftwareinc"
    offer     = "fme-core"
    sku       = "fme-core-2022-0-0-2-windows-byol"
    version   = "latest"
  }

  plan {
    name      = "fme-core-2022-0-0-2-windows-byol"
    publisher = "safesoftwareinc"
    product   = "fme-core"
  }

  custom_data = filebase64("./modules/database/sql_server/scripts/config_fmeflow_sql_confd.ps1")

  extension {
    name                 = "core-script"
    publisher            = "Microsoft.Compute"
    type                 = "CustomScriptExtension"
    type_handler_version = "1.8"
    protected_settings = jsonencode({
      "commandToExecute" = format("powershell Copy-Item -Path C:\\AzureData\\CustomData.bin -Destination C:\\config_fmeflow_sql_confd.ps1; powershell -ExecutionPolicy Unrestricted -File C:\\config_fmeflow_sql_confd.ps1 -databasehostname %s -databasePassword %s -databaseUsername %s -adminPassword %s -adminUsername %s -externalhostname %s -storageAccountName %s -storageAccountKey %s >C:\\confd-log.txt 2>&1", var.db_fqdn, var.db_pw, var.db_user, var.db_admin_pw, var.db_admin_user, var.fqdn, var.storage_name, var.storage_key)
    })
  }

  tags = local.default_tags
}