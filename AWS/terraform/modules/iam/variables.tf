variable "rds_secrets_arn" {
  type        = string
  description = "Secret id for FME Flow backend database"
}

variable "fsx_secrets_arn" {
  type        = string
  description = "Secret id for FME Flow storage"
}