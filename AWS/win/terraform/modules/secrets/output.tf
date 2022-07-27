output "rds_secrets_arn" {
    value       = aws_secretsmanager_secret.fme_server_rds.arn
    description = "Secret id for FME Server backend database"
}

output "fsx_secrets_arn" {
    value       = aws_secretsmanager_secret.fme_server_fsx.arn
    description = "Secret id for FME Server storage"
}