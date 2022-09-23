locals {
  default_tags = { owner = var.owner }
}


resource "azurerm_windows_virtual_machine_scale_set" "fme_server_engine" {
  name                = "engine"
  resource_group_name = var.rg_name
  location            = var.location
  sku                 = "Standard_D2s_v3"
  instances           = 1
  admin_password      = var.vm_admin_pw
  admin_username      = var.vm_admin_user

  os_disk {
    storage_account_type = "Premium_LRS"
    caching              = "ReadWrite"
  }

  network_interface {
    name    = "nic-engine"
    primary = true

    ip_configuration {
      name      = "ipconfig"
      primary   = true
      subnet_id = var.be_snet_id
    }
  }

  # source_image_id = ""
  source_image_reference {
    publisher = "safesoftwareinc"
    offer     = "fme-engine"
    sku       = "fme-engine-2022-0-0-2-windows-byol"
    version   = "latest"
  }

  plan {
    name      = "fme-engine-2022-0-0-2-windows-byol"
    publisher = "safesoftwareinc"
    product   = "fme-engine"
  }

  extension {
    name                 = "engine-script"
    publisher            = "Microsoft.Compute"
    type                 = "CustomScriptExtension"
    type_handler_version = "1.8"
    protected_settings = jsonencode({
      "commandToExecute" = format("powershell -ExecutionPolicy Unrestricted -File C:\\config_fmeserver_confd_engine.ps1 -databasehostname %s -engineregistrationhost %s -storageAccountName %s -storageAccountKey %s >C:\\confd-log.txt 2>&1", var.db_fqdn, var.lb_private_ip_address, var.storage_name, var.storage_key)
    })
  }

  tags = local.default_tags
}