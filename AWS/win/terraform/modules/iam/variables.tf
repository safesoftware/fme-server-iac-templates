variable "rds_secrets_arn" {
  type        = string
  description = "Secret id for FME Server backend database"
}

variable "fsx_secrets_arn" {
  type        = string
  description = "Secret id for FME Server storage"
}