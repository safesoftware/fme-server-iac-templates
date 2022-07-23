variable "owner" {
  type        = string
  default     = "gf"
  description = "Default value for onwer tag"
}

variable "vpc_name" {
  type        = string
  default     = "tf-vpc"
  description = "Virtual private cloud name"
}

variable "private_sn_name" {
  type        = string
  default     = "tf-private-subnet"
  description = "Backend virtual network subnet name"
}

variable "public_sn_name" {
  type        = string
  default     = "tf-public-subnet"
  description = "Application gateway virtual network subnet name"
}

variable "igw_name" {
  type        = string
  default     = "tf-internet-gw"
  description = "Internet gateway name"
}

variable "nat_name" {
  type        = string
  default     = "tf-nat-gw"
  description = "NAT gateway name"
}

variable "fme_core_image_id" {
  type        = string
  default     = "ami-033c4d4d7d4b334ab"
  description = "Id of the FME Sever core image"
}

variable "fme_engine_image_id" {
  type        = string
  default     = "ami-01bcc4b2970e7bead"
  description = "Id of the FME Sever core image"
}

variable "ad_name" {
  type        = string
  default     = "tf-fmeserver.safe"
  description = "Name of the Active Directory service"
}

variable "alb_name" {
  type        = string
  default     = "tf-application-lb"
  description = "Name of the application load balancer"
}

variable "nlb_name" {
  type        = string
  default     = "tf-network-lb"
  description = "Name of the network load balancer"
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