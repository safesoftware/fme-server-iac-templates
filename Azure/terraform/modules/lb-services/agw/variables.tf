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

variable "vnet_name" {
  type        = string
  default     = "fme-flow-vnet"
  description = "Virtual network name"
}

variable "agw_name" {
  type        = string
  default     = "fme-flow-agw"
  description = "description"
}

variable "agw_snet_id" {
  type        = string
  description = "Application gateway virtual network subnet id"
}

variable "pip_id" {
  type        = string
  description = "Public IP id"
}