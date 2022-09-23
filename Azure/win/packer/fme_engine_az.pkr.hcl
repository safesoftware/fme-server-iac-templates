variable "installer_url" {
  type = string
  default = "https://downloads.safe.com/fme/2022/fme-server-2022.1.2-b22627-win-x64.exe"
}

source "azure-arm" "fme_engine" {
  azure_tags = {
    owner = "gf"
  }
  use_azure_cli_auth                = true
  build_resource_group_name         = "fmeImages"
  communicator                      = "winrm"
  image_offer                       = "WindowsServer"
  image_publisher                   = "MicrosoftWindowsServer"
  image_sku                         = "2022-Datacenter"
  managed_image_name                = "fmeEngine22733"
  managed_image_resource_group_name = "fmeImages"
  os_type                           = "Windows"
  os_disk_size_gb                   = 150
  vm_size                           = "Standard_D3_v2"
  winrm_insecure                    = true
  winrm_timeout                     = "20m"
  winrm_use_ssl                     = true
  winrm_username                    = "packer"
}

build {
  sources = ["source.azure-arm.fme_engine"]

  provisioner "file" {
    source = "scripts/config_fmeserver_confd_engine.ps1"
    destination = "C:\\config_fmeserver_confd_engine.ps1"
  }

  provisioner "powershell" {
    script = "scripts/install-server-engine.ps1"
    environment_vars = ["INSTALLER_URL=${var.installer_url}"]
  }

  provisioner "powershell" {
    inline = [
      "& $env:SystemRoot\\System32\\Sysprep\\Sysprep.exe /oobe /generalize /quiet /quit /mode:vm",
      "while($true) { $imageState = Get-ItemProperty HKLM:\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Setup\\State | Select ImageState; if($imageState.ImageState -ne 'IMAGE_STATE_GENERALIZE_RESEAL_TO_OOBE') { Write-Output $imageState.ImageState; Start-Sleep -s 10  } else { break } }"
    ]
  }
}