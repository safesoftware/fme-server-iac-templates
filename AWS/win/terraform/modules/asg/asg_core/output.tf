output "vpc_id" {
  value = aws_vpc.fme_server.id
  description = "VPC id for FME Sever deployment"
}

output "public_sn_az1_id" {
  value = aws_subnet.public_subnet_az1.id
  description = "Public subnet id in the first availability zone"
}

output "public_sn_az2_id" {
  value = aws_subnet.public_subnet_az2.id
  description = "Public subnet id in the second availability zone"
}

output "private_sn_az2_id" {
  value = aws_subnet.private_subnet_az2.id
  description = "Private subnet id in the second availability zone"
}

output "private_sn_az1_id" {
  value = aws_subnet.private_subnet_az1.id
  description = "Private subnet id in the first availability zone"
}
output "rds_sn_group_name" {
  value = aws_db_subnet_group.rds_subnet_roup.name
  description = "Name of subnet group for RDS"
}
