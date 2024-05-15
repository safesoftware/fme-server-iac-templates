output "alb_dns_name" {
  value       = aws_lb.fme_flow_alb.dns_name
  description = "Public dns name of the application load balancer"
}

output "core_target_group_arn" {
  value       = aws_lb_target_group.fme_flow_core.arn
  description = "The ARN of the FME Flow core target group"
}

output "websocket_target_group_arn" {
  value       = aws_lb_target_group.fme_flow_ws.arn
  description = "The ARN of the FME Flow websocket target group"
}

