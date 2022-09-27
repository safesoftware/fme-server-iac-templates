variable "fsx_dns_name" {
  type        = string
  description = "Security group id for FME Server deployment"
}

variable "db_dns_name" {
  type        = string
  description = "Fully qualified domain name of the postgresql database server"
}

variable "ad_admin_pw" {
  type        = string
  description = "Password of the admin user of the Active Directory service. This variable should be retrieved from an [environment variable](https://www.terraform.io/cli/config/environment-variables#tf_var_name) or a secure secret store like [AWS Secrets Manager](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret). DO NOT HARDCODE."
  sensitive   = true
}

variable "db_admin_user" {
  type        = string
  description = "Backend database admin username. This variable should be retrieved from an [environment variable](https://www.terraform.io/cli/config/environment-variables#tf_var_name) or a secure secret store like [AWS Secrets Manager](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret). DO NOT HARDCODE."
  sensitive   = true
}

variable "db_admin_pw" {
  type        = string
  description = "Backend database admin pw. This variable should be retrieved from an [environment variable](https://www.terraform.io/cli/config/environment-variables#tf_var_name) or a secure secret store like [AWS Secrets Manager](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret). DO NOT HARDCODE."
  sensitive   = true
}