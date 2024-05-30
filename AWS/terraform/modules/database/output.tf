output "db_dns_name" {
  value       = aws_db_instance.fme_flow.address
  description = "Fully qualified domain name of the postgresql database server"
}
