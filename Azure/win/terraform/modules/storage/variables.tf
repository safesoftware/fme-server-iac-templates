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

variable "be_snet_id" {
  type        = string
  description = "Backend virtual network subnet id"
}