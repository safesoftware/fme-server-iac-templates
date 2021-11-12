terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  profile = "default"
  region  = "ca-central-1"
  default_tags {
    tags = {
      "Owner"   = var.owner
      "Purpose" = var.purpose
    }
  }
}

variable "key_name" {
  type = string
}

variable "owner" {
  type = string
}

variable "purpose" {
  type = string
}

data "template_file" "mainScript" {
  template = file("./install_fme.sh.tpl")
  vars = {
    efs        = module.storage.FMEEFSID
    eip        = aws_eip.FMECoreEIP.public_ip
    rdsAddress = module.storage.FMEDatabase.address
    rdsPort    = module.storage.FMEDatabase.port
  }
}

data "template_file" "engineScript" {
  template = file("./install_engine.sh.tpl")
  vars = {
    efs        = module.storage.FMEEFSID
    eip        = aws_eip.FMECoreEIP.public_ip
    rdsAddress = module.storage.FMEDatabase.address
    rdsPort    = module.storage.FMEDatabase.port
  }
}

module "network" {
  source = "./modules/network"
}

module "storage" {
  source             = "./modules/storage"
  subnetID           = module.network.subnetID
  rdsSubnetGroupID   = module.network.rdsSubnetGroupID
  FMESecurityGroupID = module.network.securityGroupID
}

resource "aws_eip" "FMECoreEIP" {
  vpc = true
  tags = {
    "Name" = "FMECoreEIP"
  }
}

resource "aws_eip_association" "associateEIP" {
  allocation_id = aws_eip.FMECoreEIP.id
  instance_id   = aws_instance.coreServer.id
}

resource "aws_instance" "coreServer" {
  ami                    = "ami-0801628222e2e96d6"
  availability_zone      = "ca-central-1a"
  instance_type          = "t3.medium"
  key_name               = var.key_name
  vpc_security_group_ids = [module.network.securityGroupID]
  subnet_id              = module.network.subnetID
  root_block_device {
    volume_size = 20
  }
  user_data = data.template_file.mainScript.rendered
  depends_on = [
    module.storage.FMEDatabase,
    module.storage.mountTarget,
    aws_eip.FMECoreEIP
  ]
  tags = {
    Name = "Core Instance"
  }
}

resource "aws_instance" "engineServer" {
  ami                         = "ami-0801628222e2e96d6"
  availability_zone           = "ca-central-1a"
  instance_type               = "t3.medium"
  key_name                    = var.key_name
  associate_public_ip_address = true
  vpc_security_group_ids      = [module.network.securityGroupID]
  subnet_id                   = module.network.subnetID
  root_block_device {
    volume_size = 20
  }
  user_data = data.template_file.engineScript.rendered
  depends_on = [
    aws_instance.coreServer
  ]
  tags = {
    Name = "Engine Instance"
  }
}

output "FMEWebUI" {
  value = format("http://%s:8080/fmeserver", aws_eip.FMECoreEIP.public_ip)
}