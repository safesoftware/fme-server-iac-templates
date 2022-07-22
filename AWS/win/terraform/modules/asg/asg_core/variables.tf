variable "vpc_name" {
  type        = string
  description = "Virtual private cloud name"
}

variable "fme_core_image_id" {
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

variable "databaseUsername" {
  type = string
  description = "Admin username for the RDS database. This variable should be retrieved from an [environment variable](https://www.terraform.io/cli/config/environment-variables#tf_var_name) or a secure secret store like [AWS Secrets Manager](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret). DOT NOT HARDCODE."
  sensitive = true
}

variable "databasePassword" {
  type = string
  description = "Admin passoword for the RDS database. This variable should be retrieved from an [environment variable](https://www.terraform.io/cli/config/environment-variables#tf_var_name) or a secure secret store like [AWS Secrets Manager](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret). DOT NOT HARDCODE."
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

variable "storageAccountKey" {
  type = string
  description = "Password for the file share user"
}
   
variable "alb_dns_name" {
  type = string
  description = "Public dns name of the application load balancer"
}

variable "core_target_group_arn" {
  type = string
  description = "The ARN of the FME Server core target group"
}

variable "websocket_target_group_arn" {
  type = string
  description = "The ARN of the FME Server websocket target group"
}

variable "engine_registration_target_group_arn" {
  type = string
  description = "The ARN of the FME Server engine registration target group"
}

variable "private_sn_az2_id" {
  type = string
  description = "Private subnet id in the second availability zone"
}

variable "private_sn_az1_id" {
  type = string
  description = "Private subnet id in the first availability zone"
}
