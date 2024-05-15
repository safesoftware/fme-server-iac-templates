resource "aws_directory_service_directory" "fme_flow" {
  name     = var.ad_name
  password = var.ad_admin_pw
  edition  = "Standard"
  type     = "MicrosoftAD"

  vpc_settings {
    vpc_id     = var.vpc_id
    subnet_ids = [var.private_sn_az1_id, var.private_sn_az2_id]
  }
}

resource "aws_fsx_windows_file_system" "fme_flow" {
  active_directory_id = aws_directory_service_directory.fme_flow.id
  storage_capacity    = 32
  subnet_ids          = [var.private_sn_az1_id, var.private_sn_az2_id]
  security_group_ids  = [var.sg_id]
  preferred_subnet_id = var.private_sn_az1_id
  throughput_capacity = 32
  deployment_type     = "MULTI_AZ_1"
}

locals {
  dnsIpAddresses = format("[\"%s\"]", join("\", \"", aws_directory_service_directory.fme_flow.dns_ip_addresses))
}

resource "aws_ssm_document" "fme_flow_ad" {
  name            = "fmeflowDomainConfig"
  document_format = "JSON"
  document_type   = "Command"

  content = <<DOC
  {
   "schemaVersion":"1.2",
   "description":"Automatic domain-join configuration created by the EC2 console.",
   "runtimeConfig":{
      "aws:domainJoin":{
         "properties":
            {
              "directoryId": "${aws_directory_service_directory.fme_flow.id}",
              "directoryName": "${aws_directory_service_directory.fme_flow.name}",
              "dnsIpAddresses": ${local.dnsIpAddresses}
            }
      }
   }
}
DOC
}

