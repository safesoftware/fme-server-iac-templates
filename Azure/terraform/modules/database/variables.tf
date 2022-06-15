variable "owner" {
  type        = string
  description = "Default value for onwer tag"
}

variable "rg_name" {
  type        = string
  description = "Resource group name"
}

variable "location" {
  type        = string
  description = "Location of resources"
}

variable "db_name" {
  type        = string
  default     = "fmeserver-postgresql010622"
  description = "Name for database server used for FME Server"
}

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

variable "be_snet_id" {
  type        = string
  description = "Backend virtual network subnet id"
}