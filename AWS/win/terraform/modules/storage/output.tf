output "fsx_dns_name" {
  value = aws_fsx_windows_file_system.fme_server.dns_name
  description = "Security group id for FME Server deployment"
}

output "ad_name" {
  value = aws_directory_service_directory.fme_server.name
  description = "The fully qualified name for the Active Directory"
}

output "ad_id" {
  value = aws_directory_service_directory.fme_server.id
  description = "The id of the Active Directory"
}

output "ad_dns_ip_addresses" {
  value = aws_directory_service_directory.fme_server.dns_ip_addresses
  description = "The DNS ip addresses of the Active Directory"
}