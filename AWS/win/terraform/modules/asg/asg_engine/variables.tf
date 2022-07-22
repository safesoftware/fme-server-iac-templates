variable "vpc_name" {
  type        = string
  description = "Virtual private cloud name"
}

variable "fme_engine_image_id" {
  type = string
  description = "Id of the FME Sever core image"
}

variable "sg_id" {
  type = string
  description = "Security group id for FME Server deployment"
}

variable "iam_instance_profile" {
  type = string
  description = "IAM profile to be attached to the instances"
}

variable db_dns_name {
  type = string
  description = "Fully qualified domain name of the postgresql database server"
}

variable "ad_admin_pw" {
  type = string
  description = "Password of the admin user of the Active Directory service. This variable should be retrieved from an [environment variable](https://www.terraform.io/cli/config/environment-variables#tf_var_name) or a secure secret store like [AWS Secrets Manager](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret). DO NOT HARDCODE."
  sensitive = true
}

variable "fsx_dns_name" {
  type = string
  description = "Security group id for FME Server deployment"
}

variable "ssm_document_name" {
  type = string
  description = "Name of the SSM document used to join instances to the Active Directory"
}
   
variable "nlb_dns_name" {
  type = string
  description = "Public dns name of the network load balancer"
}

variable "private_sn_az2_id" {
  type = string
  description = "Private subnet id in the second availability zone"
}

variable "private_sn_az1_id" {
  type = string
  description = "Private subnet id in the first availability zone"
}
