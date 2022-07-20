resource "aws_lb" "fme_server_nlb" {
  name               = var.nlb_name
  internal           = true
  load_balancer_type = "network"
  security_groups    = [var.sg_id]
  subnets            = [var.private_sn_az1_id, var.private_subnet_az2]

  enable_deletion_protection = true
}

resource "aws_lb_target_group" "fme_server_engine-registration" {
  name     = "engine-registration"
  port     = 7070
  protocol = "TCP"
  vpc_id   = var.vpc_id

  health_check {
    path = "/fmerest/v3/healthcheck"
    port = "8080"
  }
}

resource "aws_lb_listener" "fme_server_engine-registration" {
  load_balancer_arn = aws_lb.fme_server_nlb.arn
  port              = "7078"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.fme_server_engine-registration.arn
  }
}