variable "ad_name" {
  type = string
  description = "Name of the Active Directory service"
}

variable "ad_admin_pw" {
  type = string
  description = "Password of the admin user of the Active Directory service"
  sensitive = true
}

variable "vpc_id" {
  type = string
  description = "VPC id for FME Sever deployment"
}

variable "private_sn_az2_id" {
  type = string
  description = "Private subnet id in the second availability zone"
}

variable "private_sn_az1_id" {
  type = string
  description = "Private subnet id in the first availability zone"
}