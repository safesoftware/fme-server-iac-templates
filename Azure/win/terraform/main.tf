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
# source        = "./modules/database/pgsql"
  source        = "./modules/database/sql_server"
  owner         = var.owner 
  rg_name       = azurerm_resource_group.fme_server.name
  location      = azurerm_resource_group.fme_server.location
  be_snet_id    = module.network.be_snet_id
  db_admin_user = var.db_admin_user
  db_admin_pw   = var.db_admin_pw
}

module load_balancer {
  source = "./modules/lb-services/lb"
  owner         = var.owner 
  rg_name       = azurerm_resource_group.fme_server.name
  location      = azurerm_resource_group.fme_server.location
  lb_name       = var.lb_name
  be_snet_id    = module.network.be_snet_id
}

module application_gateway {
  source = "./modules/lb-services/agw"
  owner         = var.owner 
  rg_name       = azurerm_resource_group.fme_server.name
  location      = azurerm_resource_group.fme_server.location
  agw_name      = var.agw_name
  agw_snet_id   = module.network.agw_snet_id
  pip_id        = module.network.pip_id
}

resource "azurerm_windows_virtual_machine_scale_set" "fme_server_core" {
  name                = "core"
  resource_group_name = azurerm_resource_group.fme_server.name
  location            = azurerm_resource_group.fme_server.location
  sku                 = "Standard_D2s_v3"
  instances           = 1
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
      subnet_id                                    = module.network.be_snet_id
      load_balancer_backend_address_pool_ids       = [module.load_balancer.be_address_pool_id]
      application_gateway_backend_address_pool_ids = module.application_gateway.backend_address_pool_ids
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

  #Extension to use a default PostgreSQL database. This is only supported if the source of the module 'database' is set to ./modules/database/pgsql. 

  # extension {
  #   name                 = "core-script"
  #   publisher            = "Microsoft.Compute"
  #   type                 = "CustomScriptExtension"
  #   type_handler_version = "1.8"
  #   settings = jsonencode({
  #     "commandToExecute" = format("powershell -ExecutionPolicy Unrestricted -File C:\\config_fmeserver_confd.ps1 -databasehostname %s -databasePassword %s -databaseUsername %s -externalhostname %s -storageAccountName %s -storageAccountKey %s >C:\\confd-log.txt 2>&1", module.database.fqdn, var.db_admin_pw, var.db_admin_user, module.network.fqdn, module.storage.name, module.storage.primary_access_key)
  #   })
  # }
  
  #Custom script and extension to use a Azure SQL Server database. This is only supported if the source of the module 'database' is set to ./modules/database/sql_server. 
  
  custom_data = filebase64("./modules/database/sql_server/scripts/config_fmeserver_sql_confd.ps1")

  extension {
    name                 = "core-script"
    publisher            = "Microsoft.Compute"
    type                 = "CustomScriptExtension"
    type_handler_version = "1.8"
    settings = jsonencode({
      "commandToExecute" = format("powershell Copy-Item -Path C:\\AzureData\\CustomData.bin -Destination C:\\config_fmeserver_sql_confd.ps1; powershell -ExecutionPolicy Unrestricted -File C:\\config_fmeserver_sql_confd.ps1 -databasehostname %s -databasePassword %s -databaseUsername %s -adminPassword %s -adminUsername %s -externalhostname %s -storageAccountName %s -storageAccountKey %s >C:\\confd-log.txt 2>&1", module.database.fqdn, var.db_pw, var.db_user, var.db_admin_pw, var.db_admin_user, module.network.fqdn, module.storage.name, module.storage.primary_access_key)
    })
  }

  tags = local.default_tags
}

resource "azurerm_windows_virtual_machine_scale_set" "fme_server_engine" {
  name                = "engine"
  resource_group_name = azurerm_resource_group.fme_server.name
  location            = azurerm_resource_group.fme_server.location
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
      subnet_id = module.network.be_snet_id
    }
  }

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

  #Extension to use a default PostgreSQL database. This is only supported if the source of the module 'database' is set to ./modules/database/pgsql. 

  # extension {
  #   name                 = "engine-script"
  #   publisher            = "Microsoft.Compute"
  #   type                 = "CustomScriptExtension"
  #   type_handler_version = "1.8"
  #   settings = jsonencode({
  #     "commandToExecute" = format("powershell -ExecutionPolicy Unrestricted -File C:\\config_fmeserver_confd_engine.ps1 -databasehostname %s -engineregistrationhost %s -storageAccountName %s -storageAccountKey %s >C:\\confd-log.txt 2>&1", module.database.fqdn, module.load_balancer.private_ip_address, module.storage.name, module.storage.primary_access_key)
  #   })
  # }

  #Custom script and extension to use a Azure SQL Server database. This is only supported if the source of the module 'database' is set to ./modules/database/sql_server. 
  
  custom_data = filebase64("./modules/database/sql_server/scripts/config_fmeserver_sql_confd_engine.ps1")

  extension {
    name                 = "engine-script"
    publisher            = "Microsoft.Compute"
    type                 = "CustomScriptExtension"
    type_handler_version = "1.8"
    settings = jsonencode({
      "commandToExecute" = format("powershell Copy-Item -Path C:\\AzureData\\CustomData.bin -Destination C:\\config_fmeserver_sql_confd_engine.ps1; powershell -ExecutionPolicy Unrestricted -File C:\\config_fmeserver_sql_confd_engine.ps1 -databasehostname %s -databasePassword %s -databaseUsername %s -engineregistrationhost %s -storageAccountName %s -storageAccountKey %s >C:\\confd-log.txt 2>&1", module.database.fqdn, var.db_pw, var.db_user, module.load_balancer.private_ip_address, module.storage.name, module.storage.primary_access_key)
    })
  }

  tags = local.default_tags
}