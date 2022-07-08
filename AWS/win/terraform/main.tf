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
    }
  }
}

module "network" {}

module "storage" {}

module "database" {}

module "loadBalancer" {}

resource "aws_launch_configuration" "coreConfig" {
  name_prefix                 = "FME core config"
  image_id                    = "ami-0f587c2101c606e85"
  instance_type               = "t3.medium"
  key_name                    = var.key_name
  security_groups             = [module.network.securityGroupID]
  associate_public_ip_address = true
  root_block_device {
    volume_size = 25
  }
  user_data = data.template_file.mainScript.rendered
  depends_on = [
    module.storage.FMEDatabase,
    module.storage.FMEEFSMountTarget,
  ]
}

resource "aws_autoscaling_group" "coreScaling" {
  name_prefix          = "FME core scaling group"
  max_size             = 3
  desired_capacity     = 1
  min_size             = 1
  vpc_zone_identifier  = [module.network.subnetID]
  target_group_arns    = [aws_lb_target_group.FMEWebUITargetGroup.arn, aws_lb_target_group.FMEWebSocketTargetGroup.arn]
  launch_configuration = aws_launch_configuration.coreConfig.id
  tag {
    key                 = "Name"
    value               = "Core scaling instance"
    propagate_at_launch = true
  }
}

resource "aws_launch_configuration" "engineConfigStandard" {
  name_prefix                 = "FME standard engine config"
  image_id                    = "ami-0d5376f0c70ed0237"
  instance_type               = "t3.medium"
  key_name                    = var.key_name
  security_groups             = [module.network.securityGroupID]
  associate_public_ip_address = true
  root_block_device {
    volume_size = 20
  }
  user_data = data.template_file.engineScriptStandard.rendered
}

resource "aws_autoscaling_group" "engineScalingStandard" {
  name_prefix          = "FME standard engine scaling group"
  max_size             = 2
  desired_capacity     = 0
  min_size             = 0
  vpc_zone_identifier  = [module.network.subnetID]
  launch_configuration = aws_launch_configuration.engineConfigStandard.id
  tag {
    key                 = "Name"
    value               = "Standard engine scaling instance"
    propagate_at_launch = true
  }
}
