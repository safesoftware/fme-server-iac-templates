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
  description = "Virtual network name"
}

variable "be_snet_name" {
  type        = string
  description = "Backend virtual network subnet name"
}

variable "agw_snet_name" {
  type        = string
  description = "Application gateway virtual network subnet name"
}

variable "pip_name" {
  type        = string
  description = "Public ip name"
}

variable "domain_name_label" {
  type        = string
  description = "Label for the Domain Name. Will be used to make up the FQDN"
}
