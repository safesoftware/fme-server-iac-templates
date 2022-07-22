variable "ad_name" {
  type = string
  description = "Name of the Active Directory service"
}

variable "ad_admin_pw" {
  type = string
  description = "Password of the admin user of the Active Directory service. This variable should be retrieved from an [environment variable](https://www.terraform.io/cli/config/environment-variables#tf_var_name) or a secure secret store like [AWS Secrets Manager](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret). DOT NOT HARDCODE."
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

