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

module "network" {
  source = "./modules/network"
}

module "storage" {
  source             = "./modules/storage"
  subnetID           = module.network.subnetID
  rdsSubnetGroupID   = module.network.rdsSubnetGroupID
  FMESecurityGroupID = module.network.securityGroupID
}

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

resource "aws_launch_configuration" "engineConfigDynamic" {
  name_prefix                 = "FME dynamic engine config"
  image_id                    = "ami-0d5376f0c70ed0237"
  instance_type               = "t3.medium"
  key_name                    = var.key_name
  security_groups             = [module.network.securityGroupID]
  associate_public_ip_address = true
  root_block_device {
    volume_size = 20
  }
  user_data = data.template_file.engineScriptDynamic.rendered
}

resource "aws_autoscaling_group" "engineScalingDynamic" {
  name_prefix          = "FME dynamic engine scaling group"
  max_size             = 2
  desired_capacity     = 0
  min_size             = 0
  vpc_zone_identifier  = [module.network.subnetID]
  launch_configuration = aws_launch_configuration.engineConfigDynamic.id
  tag {
    key                 = "Name"
    value               = "Dynamic engine scaling instance"
    propagate_at_launch = true
  }
}

resource "aws_lb_target_group" "FMEWebUITargetGroup" {
  name_prefix = "FME-UI"
  vpc_id      = module.network.vpcID
  protocol    = "HTTP"
  port        = 8080
  health_check {
    interval = 300
    timeout  = 120
    path     = "/fmeserver"
    matcher  = "200,202,302"
  }
  tags = {
    "Name" = "FME Web UI Target Group"
  }
}

resource "aws_lb_target_group" "FMEWebSocketTargetGroup" {
  name_prefix = "FMESKT"
  vpc_id      = module.network.vpcID
  protocol    = "TCP"
  port        = 7078
  health_check {
    protocol = "TCP"
    interval = 30
  }
  tags = {
    "Name" = "FME Web Socket Target Group"
  }
}

resource "aws_lb" "FMEWebUILoadBalancer" {
  name_prefix     = "FME-UI"
  security_groups = [module.network.securityGroupID]
  subnets         = [module.network.subnetID, module.network.backupSubnetID]
  internal        = false
  tags = {
    "Name" = "FME Web UI Load Balancer"
  }
}

resource "aws_lb_listener" "FMEWebUIListener" {
  load_balancer_arn = aws_lb.FMEWebUILoadBalancer.arn
  port              = 8080
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.FMEWebUITargetGroup.arn
  }
  tags = {
    "Name" = "FME Web UI Listener"
  }
}

resource "aws_lb_listener" "FMEWebSocketListener" {
  load_balancer_arn = aws_lb.FMEBackendLoadBalancer.arn
  protocol          = "TCP"
  port              = 7078
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.FMEWebSocketTargetGroup.arn
  }
  tags = {
    "Name" = "FME WebSocket Listener"
  }
}

resource "aws_lb" "FMEBackendLoadBalancer" {
  name_prefix        = "FMEBLB"
  subnets            = [module.network.subnetID]
  load_balancer_type = "network"
  internal           = true
  tags = {
    "Name" = "FME Backend Load Balancer"
  }
}