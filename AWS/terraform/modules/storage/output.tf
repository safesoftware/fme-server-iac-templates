output "fsx_dns_name" {
  value       = aws_fsx_windows_file_system.fme_flow.dns_name
  description = "Security group id for FME Flow deployment"
}

output "ssm_document_name" {
  value       = aws_ssm_document.fme_flow_ad.name
  description = "Name of the SSM document used to join instances to the Active Directory"
}