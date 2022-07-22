data "aws_region" "current" {}
locals {
    config = {
      "$engineregistrationhost" = "${var.nlb_dns_name}"
      "$databasehostname"       = "${var.db_dns_name}"
      "$storageAccountName"     = "${var.fsx_dns_name}"
      "$storageAccountKey"      = "${var.ad_admin_pw}"
      "$awsRegion"              = "${aws_region.current.name}" 
      "$domainConfig"           = "${var.ssm_document_name}"  
    }
}

resource "aws_launch_template" "fme_server_engine" {
  name                   = "fme-engine"
  image_id               = var.fme_engine_image_id
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
      Name = "fme-engine"
    }
  }

  user_data = filebase64(templatefile("./user_data/user_data_engine.tftpl", { config = local.config }))
}

resource "aws_autoscaling_group" "fme_sever_engine" {
  desired_capacity    = 2
  max_size            = 2
  min_size            = 1
  vpc_zone_identifier = [var.private_sn_az1_id, var.private_sn_az2_id]
  launch_template {
    id      = aws_launch_template.fme_server_engine.id
    version = "$Latest"
  }
  
  tags = {
    "Name"    = "fme-engine"
  }
}

