output "nlb_dns_name" {
  value       = aws_lb.fme_server_nlb.dns_name
  description = "Public dns name of the network load balancer"
}

output "engine_registration_target_group_arn" {
  value       = aws_lb_target_group.fme_server_engine-registration.arn
  description = "The ARN of the FME Server engine registration target group"
}

