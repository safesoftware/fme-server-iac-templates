data "aws_region" "current" {}
locals {
  config = {
    "$engineregistrationhost" = "${var.nlb_dns_name}"
    "$rds_secrets_arn"        = "${var.rds_secrets_arn}"
    "$fsx_secrets_arn"        = "${var.fsx_secrets_arn}"
    "$awsRegion"              = "${data.aws_region.current.name}"
    "$domainConfig"           = "${var.ssm_document_name}"
    "$engineType"             = "${var.engine_type}"
    "$nodeManaged"            = "${var.node_managed}"
  }
}

resource "aws_launch_template" "fme_flow_engine" {
  name                   = var.engine_name
  image_id               = var.fme_engine_image_id
  instance_type          = "t3.large"
  vpc_security_group_ids = [var.sg_id]
  iam_instance_profile {
    name = var.iam_instance_profile
  }
  metadata_options {
    http_endpoint = "enabled"
  }
  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = var.engine_name
    }
  }

  user_data = base64encode(templatefile("${path.module}/user_data/user_data_engine.tftpl", { config = local.config }))
}

resource "aws_autoscaling_group" "fme_sever_engine" {
  name_prefix         = var.engine_name
  desired_capacity    = 2
  max_size            = 2
  min_size            = 1
  vpc_zone_identifier = [var.private_sn_az1_id, var.private_sn_az2_id]
  launch_template {
    id      = aws_launch_template.fme_flow_engine.id
    version = "$Latest"
  }
  tag {
  key                 = "Owner"
  value               = var.owner
  propagate_at_launch = true
  }
}