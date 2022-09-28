locals {
  rds = {
    db_admin_user    = "${var.db_admin_user}"
    db_admin_pw      = "${var.db_admin_pw}"
    databasehostname = "${var.db_dns_name}"
  }
  fsx = {
    ad_admin_pw        = "${var.ad_admin_pw}"
    storageAccountName = "${var.fsx_dns_name}"
  }
}

resource "aws_secretsmanager_secret" "fme_server_rds" {
  name                    = "fmeserverRDSSecret"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "fme_server_rds" {
  secret_id     = aws_secretsmanager_secret.fme_server_rds.id
  secret_string = jsonencode(local.rds)
}

resource "aws_secretsmanager_secret" "fme_server_fsx" {
  name                    = "fmeserverFSXSecret"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "fme_server_fsx" {
  secret_id     = aws_secretsmanager_secret.fme_server_fsx.id
  secret_string = jsonencode(local.fsx)
}




