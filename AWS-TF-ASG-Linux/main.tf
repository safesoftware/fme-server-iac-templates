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
    rds        = module.storage.FMEDatabase.endpoint
  }
}

data "template_file" "engineScript" {
  template = file("./install_engine.sh.tpl")
  vars = {
    efs = module.storage.FMEEFSID
    eip = aws_eip.FMECoreEIP.public_ip
    rds = module.storage.FMEDatabase.endpoint
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
  ami                    = "ami-00b1682826a83e6c7"
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

resource "aws_launch_configuration" "engineConfig" {
  name_prefix                 = "FME engine config"
  image_id                    = "ami-09c63381267f423f7"
  instance_type               = "t3.medium"
  key_name                    = var.key_name
  security_groups             = [module.network.securityGroupID]
  associate_public_ip_address = true
  root_block_device {
    volume_size = 20
  }
  user_data = data.template_file.engineScript.rendered
}

resource "aws_autoscaling_group" "engineScaling" {
  name_prefix          = "FME engine scaling group"
  max_size             = 2
  desired_capacity     = 0
  min_size             = 0
  vpc_zone_identifier  = [module.network.subnetID]
  launch_configuration = aws_launch_configuration.engineConfig.id
  tag {
    key                 = "Name"
    value               = "Engine scaling instance"
    propagate_at_launch = true
  }
}

output "FMEWebUI" {
  value = format("http://%s:8080/fmeserver", aws_eip.FMECoreEIP.public_ip)
}