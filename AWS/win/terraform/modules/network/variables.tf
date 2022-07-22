variable "vpc_name" {
  type        = string
  description = "Virtual private cloud name"
}

variable "private_sn_name" {
  type        = string
  description = "Backend virtual network subnet name"
}

variable "public_sn_name" {
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
