locals {
  default_tags = { owner = var.owner }
  engine_type = var.engine_type == "STANDARD" ? "" : "-engineType DYNAMIC -nodeManaged false"
}

resource "azurerm_windows_virtual_machine_scale_set" "fme_flow_engine" {
  name                = var.vmss_name
  resource_group_name = var.rg_name
  location            = var.location
  sku                 = "Standard_D2s_v3"
  instances           = var.instance_count_engine
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

  # To use a custom source_image_id instead of the Azure Marketplace image the 'source_image_reference' and 'plan' blocks need to be commented
  # source_image_id = ""
  source_image_reference {
    publisher = "safesoftwareinc"
    offer     = "fme-engine"
    sku       = "fme-engine-2024-0-2-1-windows-byol"
    version   = "latest"
  }

  plan {
    name      = "fme-engine-2024-0-2-1-windows-byol"
    publisher = "safesoftwareinc"
    product   = "fme-engine"
  }

  extension {
    name                 = "engine-script"
    publisher            = "Microsoft.Compute"
    type                 = "CustomScriptExtension"
    type_handler_version = "1.8" 
    protected_settings = jsonencode({
      "commandToExecute" = format("powershell -ExecutionPolicy Unrestricted -File C:\\config_fmeflow_confd_engine.ps1 -databasehostname %s -engineregistrationhost %s -storageAccountName %s -storageAccountKey %s %s >C:\\confd-log.txt 2>&1", var.db_fqdn, var.lb_private_ip_address, var.storage_name, var.storage_key, local.engine_type)
    })
  }

  tags = local.default_tags
}
