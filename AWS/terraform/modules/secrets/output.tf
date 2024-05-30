output "rds_secrets_arn" {
  value       = aws_secretsmanager_secret.fme_flow_rds.arn
  description = "Secret id for FME Flow backend database"
}

output "fsx_secrets_arn" {
  value       = aws_secretsmanager_secret.fme_flow_fsx.arn
  description = "Secret id for FME Flow storage"
}