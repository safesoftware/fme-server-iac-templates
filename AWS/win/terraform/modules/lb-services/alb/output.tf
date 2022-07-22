output "alb_dns_name" {
  value = aws_lb.fme_server_alb.name
  description = "Public dns name of the application load balancer"
}

output "core_target_group_arn" {
  value = aws_lb_listener.fme_server_core.arn
  description = "The ARN of the FME Server core target group"
}

output "core_target_group_arn" {
  value = aws_lb_listener.fme_server_ws.arn
  description = "The ARN of the FME Server websocket target group"
}

