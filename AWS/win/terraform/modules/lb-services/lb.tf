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