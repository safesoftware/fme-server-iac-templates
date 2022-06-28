
output "FMEWebUI" {
  value = format("http://%s:8080/fmeserver", aws_lb.FMEWebUILoadBalancer.dns_name)
}
