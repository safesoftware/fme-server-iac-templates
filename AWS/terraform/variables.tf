variable "owner" {
  type        = string
  description = "Default value for owner tag"
}

variable "public_access" {
  type        = string
  description = "CDIR range from which the FME Flow Web UI and Websocket will be accessible"
}

variable "region" {
  type = string
  description = "AWS region in which FME Sever will be deployed" 
}
variable "vpc_name" {
  type        = string
  default     = "tf-vpc"
  description = "Virtual private cloud name"
}

variable "sn_name" {
  type        = string
  default     = "tf-subnet"
  description = "Subnet name prefix"
}

variable "vpc_cidr" {
  type        = string
  default     = "10.0.0.0/16"
  description = "CIDR range for VPC"
}

variable "public_sn1_cidr" {
  type        = string
  default     = "10.0.0.0/20"
  description = "CIDR range for public subnet in the first availability zone"
}

variable "public_sn2_cidr" {
  type        = string
  default     = "10.0.16.0/20"
  description = "CIDR range for public subnet in the second availability zone"
}

variable "private_sn1_cidr" {
  type        = string
  default     = "10.0.128.0/20"
  description = "CIDR range for private subnet in the first availability zone"
}

variable "private_sn2_cidr" {
  type        = string
  default     = "10.0.144.0/20"
  description = "CIDR range for private subnet in the second availability zone"
}

variable "igw_name" {
  type        = string
  default     = "tf-internet-gw"
  description = "Internet gateway name"
}

variable "eip_name" {
  type        = string
  default     = "tf-eip-name"
  description = "Elastic IP name"
}

variable "nat_name" {
  type        = string
  default     = "tf-nat-gw"
  description = "NAT gateway name"
}

variable "fme_core_image_id" {
  type        = string
  description = "Id of the FME Sever core image. The AMI needs to be available in the region used for the deployment"
}

variable "fme_engine_image_id" {
  type        = string
  description = "Id of the FME Sever engine image. The AMI needs to be available in the region used for the deployment"
}

variable "ad_name" {
  type        = string
  default     = "tf-fmeflow.safe"
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
  description = "Backend database admin username. Cannot be `FMEFLOW` or `POSTGRES` (case insensitive). This variable should be retrieved from an [environment variable](https://www.terraform.io/cli/config/environment-variables#tf_var_name) or a secure secret store like [AWS Secrets Manager](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret). DO NOT HARDCODE."
  sensitive   = true
  validation {
    condition     = !(lower(var.db_admin_user) == "fmeflow" || lower(var.db_admin_user) == "postgres")
    error_message = "The db_admin_user variable cannot be 'FMEFLOW' or 'POSTGRES' (case-insensitive)."
  }
}

variable "db_admin_pw" {
  type        = string
  description = "Backend database admin pw. This variable should be retrieved from an [environment variable](https://www.terraform.io/cli/config/environment-variables#tf_var_name) or a secure secret store like [AWS Secrets Manager](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret). DO NOT HARDCODE."
  sensitive   = true
}