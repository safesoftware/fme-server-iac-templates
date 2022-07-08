resource "aws_db_instance" "fme_server" {
  allocated_storage      = 20
  availability_zone      = "ca-central-1a"
  instance_class         = "db.t3.small"
  engine                 = "postgres"
  username               = var.db_admin_user
  password               = var.db_admin_pw
  db_subnet_group_name   = var.be_snet_group_name
  license_model          = "postgresql-license"
  port                   = 5432
  multi_az               = false
  vpc_security_group_ids = [var.FMESecurityGroupID]
  skip_final_snapshot    = true
  tags = {
    "Name"    = "FME Server backend database"
  }
}