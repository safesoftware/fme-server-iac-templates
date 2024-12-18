packer {
  required_plugins {
    amazon = {
      version = ">= 1.3.2"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

variable "region" {
  type    = string
}

variable "installer_url" {
  type = string
}

variable "tags" {
  type = map(string)
}

variable "source_ami" {
  type = string
}

locals { timestamp = regex_replace(timestamp(), "[- TZ:]", "") }

# source blocks are generated from your builders; a source can be referenced in
# build blocks. A build block runs provisioner and post-processors on a
# source.
source "amazon-ebs" "fme_core" {
  ami_name              = "fme-core-2024-win-${local.timestamp}"
  communicator          = "winrm"
  instance_type         = "m5.large"
  region                = "${var.region}"
  source_ami            = "${var.source_ami}"
  user_data_file        = "scripts/bootstrap_win.txt"
  winrm_username        = "Administrator"
  disable_stop_instance = true
  
  launch_block_device_mappings {
    device_name = "/dev/sda1"
    volume_size = 150
    volume_type = "gp2"
    delete_on_termination = true
  }

  aws_polling {
    delay_seconds = 60
    max_attempts  = 75
 }

  tags            = "${var.tags}"
  run_tags        = "${var.tags}"
  run_volume_tags = "${var.tags}"
  snapshot_tags   = "${var.tags}"
}

source "amazon-ebs" "fme_engine" {
  ami_name       = "fme-engine-2024-win-${local.timestamp}"
  communicator   = "winrm"
  instance_type  = "m5.large"
  region         = "${var.region}"
  source_ami     = "${var.source_ami}"
  user_data_file = "scripts/bootstrap_win.txt"
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
  name    = "fme-core-2024"
  sources = ["source.amazon-ebs.fme_core"]
  
  provisioner "file" {
    source = "../../config/powershell/config_fmeflow_confd.ps1"
    destination = "C:\\config_fmeflow_confd_aws.ps1"
  }

  provisioner "powershell" {
    script = "../../config/powershell/install-flow-core.ps1"
    environment_vars = ["INSTALLER_URL=${var.installer_url}"]
  }

  provisioner "powershell" {
    inline = [
      "& \"C:\\Program Files\\Amazon\\EC2Launch\\EC2Launch.exe\" sysprep --shutdown"
    ]
  }
}

build {
  name    = "fme-engine-2024"
  sources = ["source.amazon-ebs.fme_engine"]
  
  provisioner "file" {
    source = "../../config/powershell/config_fmeflow_confd_engine.ps1"
    destination = "C:\\config_fmeflow_confd_engine_aws.ps1"
  }

  provisioner "powershell" {
    script = "../../config/powershell/install-flow-engine.ps1"
    environment_vars = ["INSTALLER_URL=${var.installer_url}"]
  }

  provisioner "powershell" {
    inline = [
      "& \"C:\\Program Files\\Amazon\\EC2Launch\\EC2Launch.exe\" sysprep --shutdown"
    ]
  }
}