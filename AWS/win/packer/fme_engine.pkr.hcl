packer {
  required_plugins {
    amazon = {
      version = ">= 0.0.1"
      source = "github.com/hashicorp/amazon"
    }
  }
}

variable "region" {
  type    = string
  default = "us-west-2"
}

variable "tags" {
  type = map(string)
  default = {
    Owner = "gf"
  }
}

locals { timestamp = regex_replace(timestamp(), "[- TZ:]", "") }

# source blocks are generated from your builders; a source can be referenced in
# build blocks. A build block runs provisioner and post-processors on a
# source.
source "amazon-ebs" "windows" {
  ami_name       = "fme-engine-2022-win-${local.timestamp}"
  communicator   = "winrm"
  instance_type  = "t3.large"
  region         = "${var.region}"
  source_ami     = "ami-0280d580c37d161bf"
  user_data_file = "scripts/bootstrap_win.txt"
  winrm_password = "SuperS3cr3t!!!!"
  winrm_username = "Administrator"
  disable_stop_instance = true
  
  launch_block_device_mappings {
    device_name = "/dev/sda1"
    volume_size = 150
    volume_type = "gp2"
    delete_on_termination = true
  }
  
  tags            = "${var.tags}"
  run_tags        = "${var.tags}"
  run_volume_tags = "${var.tags}"
  snapshot_tags   = "${var.tags}"
}

# a build block invokes sources and runs provisioning steps on them.
build {
  name    = "fme-engine-2022"
  sources = ["source.amazon-ebs.windows"]
  
  provisioner "file" {
    source = "scripts/config_fmeserver_confd_engine_aws.ps1"
    destination = "C:\\config_fmeserver_confd_engine_aws.ps1"
  }

  provisioner "powershell" {
    script = "scripts/install-server-engine.ps1"
    environment_vars = ["INSTALLER_URL=https://downloads.safe.com/fme/2022/fme-server-2022.0.1.1-b22350-win-x64.exe"]
  }

  provisioner "powershell" {
    inline = [
      "# Install Google Chrome Browser",
      "$Path = $env:TEMP",
      "$Installer = \"chrome_installer.exe\"",
      "Invoke-WebRequest \"https://dl.google.com/chrome/install/latest/chrome_installer.exe\" -OutFile $Path$Installer",
      "Start-Process -FilePath $Path$Installer -Args \"/silent /install\" -Verb RunAs -Wait; Remove-Item $Path$Installer",
      "# Disable Internet Explorer Enhanced Security",
      "$AdminKey = \"HKLM:\\SOFTWARE\\Microsoft\\Active Setup\\Installed Components\\{A509B1A7-37EF-4b3f-8CFC-4F3A74704073}\"",
      "$UserKey = \"HKLM:\\SOFTWARE\\Microsoft\\Active Setup\\Installed Components\\{A509B1A8-37EF-4b3f-8CFC-4F3A74704073}\"",
      "Set-ItemProperty -Path $AdminKey -Name \"IsInstalled\" -Value 0 -Force",
      "Set-ItemProperty -Path $UserKey -Name \"IsInstalled\" -Value 0 -Force"
    ]
  }

  provisioner "powershell" {
    inline = [
      "& \"C:\\Program Files\\Amazon\\EC2Launch\\EC2Launch.exe\" sysprep --shutdown"
    ]
  }
}

