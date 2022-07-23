data "aws_region" "current" {}
locals {
    config = {
      "$externalhostname"   = "${var.alb_dns_name}"
      "$databasehostname"   = "${var.db_dns_name}"
      "$databaseUsername"   = "${var.db_admin_user}"
      "$databasePassword"   = "${var.db_admin_pw}"
      "$storageAccountName" = "${var.fsx_dns_name}"
      "$storageAccountKey"  = "${var.ad_admin_pw}"
      "$awsRegion"          = "${data.aws_region.current.name}" 
      "$domainConfig"       = "${var.ssm_document_name}"  
    }
}

resource "aws_launch_template" "fme_server_core" {
  name                   = "fme-core"
  image_id               = var.fme_core_image_id
  instance_type          = "t3.large"
  vpc_security_group_ids = [var.sg_id]
  iam_instance_profile {
    name = var.iam_instance_profile
  }
  metadata_options {
    http_endpoint = "enabled"
  }
  monitoring {
    enabled = true
  }
  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "fme-core"
    }
  }

  user_data = filebase64(templatefile("${path.module}/user_data/user_data_core.tftpl", { config = local.config }))
}

resource "aws_autoscaling_group" "fme_sever_core" {
  desired_capacity    = 2
  max_size            = 2
  min_size            = 1
  vpc_zone_identifier = [var.private_sn_az1_id, var.private_sn_az2_id]
  target_group_arns   = [var.core_target_group_arn, var.websocket_target_group_arn, var.engine_registration_target_group_arn]
  launch_template {
    id      = aws_launch_template.fme_server_core.id
    version = "$Latest"
  }
}

