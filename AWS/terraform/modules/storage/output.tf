output "fsx_dns_name" {
  value       = aws_fsx_windows_file_system.fme_server.dns_name
  description = "Security group id for FME Server deployment"
}

output "ssm_document_name" {
  value       = aws_ssm_document.fme_server_ad.name
  description = "Name of the SSM document used to join instances to the Active Directory"
}