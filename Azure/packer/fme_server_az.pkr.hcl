variable "resource_group" {
  type    = string
}

variable "installer_url" {
  type = string
}

variable "tags" {
  type = map(string)
}

locals { timestamp = regex_replace(timestamp(), "[- TZ:]", "") }

source "azure-arm" "fme_core" {
  azure_tags                        = "${var.tags}"
  use_azure_cli_auth                = true
  build_resource_group_name         = "${var.resource_group}"
  communicator                      = "winrm"
  image_offer                       = "WindowsServer"
  image_publisher                   = "MicrosoftWindowsServer"
  image_sku                         = "2022-Datacenter"
  managed_image_name                = "fmeCore-${local.timestamp}"
  managed_image_resource_group_name = "${var.resource_group}"
  os_type                           = "Windows"
  os_disk_size_gb                   = 150
  vm_size                           = "Standard_D3_v2"
  winrm_insecure                    = true
  winrm_timeout                     = "20m"
  winrm_use_ssl                     = true
  winrm_username                    = "packer"
}

source "azure-arm" "fme_engine" {
  azure_tags                        = "${var.tags}"
  use_azure_cli_auth                = true
  build_resource_group_name         = "${var.resource_group}"
  communicator                      = "winrm"
  image_offer                       = "WindowsServer"
  image_publisher                   = "MicrosoftWindowsServer"
  image_sku                         = "2022-Datacenter"
  managed_image_name                = "fmeEngine-${local.timestamp}"
  managed_image_resource_group_name = "${var.resource_group}"
  os_type                           = "Windows"
  os_disk_size_gb                   = 150
  vm_size                           = "Standard_D3_v2"
  winrm_insecure                    = true
  winrm_timeout                     = "20m"
  winrm_use_ssl                     = true
  winrm_username                    = "packer"
}

build {
  sources = ["source.azure-arm.fme_core"]

  provisioner "file" {
    source = "../../config/powershell/config_fmeserver_confd.ps1"
    destination = "C:\\config_fmeserver_confd.ps1"
  }

  provisioner "powershell" {
    script = "../../config/powershell/install-flow-core.ps1"
    environment_vars = ["INSTALLER_URL=${var.installer_url}"]
  }

  provisioner "powershell" {
    inline = [
      "& $env:SystemRoot\\System32\\Sysprep\\Sysprep.exe /oobe /generalize /quiet /quit /mode:vm",
      "while($true) { $imageState = Get-ItemProperty HKLM:\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Setup\\State | Select ImageState; if($imageState.ImageState -ne 'IMAGE_STATE_GENERALIZE_RESEAL_TO_OOBE') { Write-Output $imageState.ImageState; Start-Sleep -s 10  } else { break } }"
    ]
  }
}

build {
  sources = ["source.azure-arm.fme_engine"]

  provisioner "file" {
    source = "../../config/powershell/config_fmeserver_confd_engine.ps1"
    destination = "C:\\config_fmeserver_confd_engine.ps1"
  }

  provisioner "powershell" {
    script = "../../config/powershell/install-flow-engine.ps1"
    environment_vars = ["INSTALLER_URL=${var.installer_url}"]
  }

  provisioner "powershell" {
    inline = [
      "& $env:SystemRoot\\System32\\Sysprep\\Sysprep.exe /oobe /generalize /quiet /quit /mode:vm",
      "while($true) { $imageState = Get-ItemProperty HKLM:\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Setup\\State | Select ImageState; if($imageState.ImageState -ne 'IMAGE_STATE_GENERALIZE_RESEAL_TO_OOBE') { Write-Output $imageState.ImageState; Start-Sleep -s 10  } else { break } }"
    ]
  }
}