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

resource "aws_secretsmanager_secret" "fme_flow_rds" {
  name                    = "fmeflowRDSSecret"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "fme_flow_rds" {
  secret_id     = aws_secretsmanager_secret.fme_flow_rds.id
  secret_string = jsonencode(local.rds)
}

resource "aws_secretsmanager_secret" "fme_flow_fsx" {
  name                    = "fmeflowFSXSecret"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "fme_flow_fsx" {
  secret_id     = aws_secretsmanager_secret.fme_flow_fsx.id
  secret_string = jsonencode(local.fsx)
}




