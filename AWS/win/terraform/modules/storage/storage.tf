variable "rdsSubnetGroupID" {}

variable "subnetID" {}

variable "FMESecurityGroupID" {}



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



output "FMEEFSID" {
  value = aws_efs_file_system.FMEServerSystemShareEFS.id
}

output "mountTarget" {
  value = aws_efs_mount_target.mountTarget
}