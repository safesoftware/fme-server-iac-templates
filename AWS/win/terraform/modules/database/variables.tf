variable "db_admin_user" {
  type        = string
  description = "Backend database admin username"
  sensitive   = true
}

variable "db_admin_pw" {
  type        = string
  description = "Backend database admin pw"
  sensitive   = true
}

variable "rds_sn_group_name" {
  type        = string
  description = "Name of subnet group for RDS"
}

variable "sg_id" {
  type = string
  description = "Security group id for FME Server deployment"
  
}