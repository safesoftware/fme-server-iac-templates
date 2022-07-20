variable "vnet_name" {
  type        = string
  description = "Virtual network name"
}

variable "private_snet_name" {
  type        = string
  description = "Backend virtual network subnet name"
}

variable "public_snet_name" {
  type        = string
  description = "Application gateway virtual network subnet name"
}

variable "pip_name" {
  type        = string
  description = "Public ip name"
}

variable "igw_name" {
  type = string
  description = "Internet gateway name"
}

variable "nat_name" {
  type = string
  description = "NAT gateway name"
}

variable "domain_name_label" {
  type        = string
  description = "Label for the Domain Name. Will be used to make up the FQDN"
}