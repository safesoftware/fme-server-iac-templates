resource "aws_lb" "fme_server_alb" {
  name               = var.alb_name
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.sg_id]
  subnets            = [var.public_sn_az1_id, var.public_sn_az2_id]
}

resource "aws_lb_target_group" "fme_server_core" {
  name     = "fmeserver-core"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path    = "/"
    matcher = "200"
  }
}

resource "aws_lb_target_group" "fme_server_ws" {
  name     = "fmeserver-ws"
  port     = 7078
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path    = "/"
    matcher = "200-400"
  }
}

resource "aws_lb_listener" "fme_server_core" {
  load_balancer_arn = aws_lb.fme_server_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.fme_server_core.arn
  }
}

resource "aws_lb_listener" "fme_server_ws" {
  load_balancer_arn = aws_lb.fme_server_alb.arn
  port              = "7078"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.fme_server_ws.arn
  }
}