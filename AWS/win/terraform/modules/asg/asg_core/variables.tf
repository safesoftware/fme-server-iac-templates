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

variable "externalhostname" {
  type = string
  description = "Public DNS name of the application load balancer"
}

variable "databasehostname" {
  type = string
  description = "DNS name of the RDS database"
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

variable "storageAccountName" {
  type = string
  description = "Public DNS name of the FSx file share"
}

variable "storageAccountKey" {
  type = string
  description = "Password for the file share user"
}
   
variable "domainConfig" {
  type = string
  description = "Name of the domain configuration used to add new instances to the active directory domain"
} 