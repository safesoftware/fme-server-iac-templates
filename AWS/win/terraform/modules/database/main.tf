resource "aws_db_instance" "fme_server" {
  allocated_storage      = 20
  instance_class         = "db.t3.small"
  engine                 = "postgres"
  username               = var.db_admin_user
  password               = var.db_admin_pw
  db_subnet_group_name   = var.rds_sn_group_name
  license_model          = "postgresql-license"
  port                   = 5432
  multi_az               = true
  vpc_security_group_ids = [var.sg_id]
  skip_final_snapshot    = true
  tags = {
    "Name"    = "FME Server backend database"
  }
}