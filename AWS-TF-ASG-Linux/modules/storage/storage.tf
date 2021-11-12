variable "rdsSubnetGroupID" {}

variable "subnetID" {}

variable "FMESecurityGroupID" {}

resource "aws_db_instance" "FMEDatabase" {
  allocated_storage      = 20
  availability_zone      = "ca-central-1a"
  instance_class         = "db.t3.micro"
  engine                 = "postgres"
  username               = "postgres"
  password               = "postgres"
  db_subnet_group_name   = var.rdsSubnetGroupID
  license_model          = "postgresql-license"
  port                   = 5432
  multi_az               = false
  vpc_security_group_ids = [var.FMESecurityGroupID]
  skip_final_snapshot    = true
  tags = {
    "Name"    = "FMEDatabase"
  }
}

resource "aws_efs_file_system" "FMEServerSystemShareEFS" {
  availability_zone_name = "ca-central-1a"
  tags = {
    "Name"    = "FMEServerSystemShareEFS"
  }
}

resource "aws_efs_mount_target" "mountTarget" {
  file_system_id  = aws_efs_file_system.FMEServerSystemShareEFS.id
  subnet_id       = var.subnetID
  security_groups = [var.FMESecurityGroupID]
}

output "FMEDatabase" {
  value = aws_db_instance.FMEDatabase
}

output "FMEEFSID" {
  value = aws_efs_file_system.FMEServerSystemShareEFS.id
}

output "mountTarget" {
  value = aws_efs_mount_target.mountTarget
}