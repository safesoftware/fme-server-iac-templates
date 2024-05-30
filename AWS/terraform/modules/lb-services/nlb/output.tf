output "nlb_dns_name" {
  value       = aws_lb.fme_flow_nlb.dns_name
  description = "Public dns name of the network load balancer"
}

output "engine_registration_target_group_arn" {
  value       = aws_lb_target_group.fme_flow_engine-registration.arn
  description = "The ARN of the FME Flow engine registration target group"
}

