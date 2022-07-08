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

variable "be_snet_group_name" {
  type        = string
  description = "Backend subnet group name"
}

variable "security_group_id" {
  type = string
  description = "ID of the FME Server security group"
  
}