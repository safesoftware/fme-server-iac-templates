resource "aws_lb" "fme_flow_nlb" {
  name               = var.nlb_name
  internal           = true
  load_balancer_type = "network"
  subnets            = [var.private_sn_az1_id, var.private_sn_az2_id]
}

resource "aws_lb_target_group" "fme_flow_engine-registration" {
  name     = "engine-registration"
  port     = 7070
  protocol = "TCP"
  vpc_id   = var.vpc_id

  health_check {
    path = "/fmerest/v3/healthcheck"
    port = "8080"
  }
}

resource "aws_lb_listener" "fme_flow_engine-registration" {
  load_balancer_arn = aws_lb.fme_flow_nlb.arn
  port              = "7070"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.fme_flow_engine-registration.arn
  }
}