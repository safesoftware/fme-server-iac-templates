variable "vpc_name" {
  type        = string
  description = "Virtual private cloud name"
}

variable "fme_engine_image_id" {
  type        = string
  description = "Id of the FME Sever core image"
}

variable "engine_type" {
  type = string
  description = "The type of FME Flow Engine. Possible values are STANDARD and DYNAMIC"
}

variable "engine_name" {
  type        = string
  description = "Virtual private cloud name"
}

variable "node_managed" {
  type = string
  description = "Whether the engine nodes can be manged via the Web UI. For cpu-usage (dynamic) engines it is recommended to us 'false'. Possible values are 'true' and 'false'"
}

variable "sg_id" {
  type        = string
  description = "Security group id for FME Flow deployment"
}

variable "iam_instance_profile" {
  type        = string
  description = "IAM profile to be attached to the instances"
}

variable "rds_secrets_arn" {
  type        = string
  description = "Secret id for FME Flow backend database"
}

variable "fsx_secrets_arn" {
  type        = string
  description = "Secret id for FME Flow storage"
}

variable "ssm_document_name" {
  type        = string
  description = "Name of the SSM document used to join instances to the Active Directory"
}

variable "nlb_dns_name" {
  type        = string
  description = "Public dns name of the network load balancer"
}

variable "private_sn_az2_id" {
  type        = string
  description = "Private subnet id in the second availability zone"
}

variable "private_sn_az1_id" {
  type        = string
  description = "Private subnet id in the first availability zone"
}

variable "owner" {
  type        = string
  description = "Resource owner for tagging purposes"
}