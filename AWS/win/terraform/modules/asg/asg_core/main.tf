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
      Name = "fme_core"
    }
  }

  user_data = filebase64("${path.module}/example.sh")
}