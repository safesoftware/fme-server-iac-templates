resource "aws_directory_service_directory" "fme_server" {
  name     = var.ad_name
  password = var.ad_admin_user
  edition  = "Standard"
  type     = "MicrosoftAD"

  vpc_settings {
    vpc_id     = var.vpc_id
    subnet_ids = [var.private_sn_az1_id, var.private_sn_az2_id]
  }
}

resource "aws_fsx_windows_file_system" "fme_server" {
  active_directory_id = aws_directory_service_directory.fme_server.id
  storage_capacity    = 32
  subnet_ids          = [var.private_sn_az1_id, var.private_sn_az2_id]
  throughput_capacity = 32
  deployment_type = "MULTI_AZ_1"
}