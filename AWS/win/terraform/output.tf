output "alb_dns_name" {
  value = module.alb.ald_dns_name
  description = "Public dns name of the application load balancer"
}