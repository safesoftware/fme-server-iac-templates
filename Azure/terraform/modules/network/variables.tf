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

variable "pgsql_snet_name" {
  type        = string
  description = "Postgresql virtual network subnet name"
}

variable "nat_gateway_name" {
  type        = string
  description = "name of the nat gateway"
}

variable "pip_name" {
  type        = string
  description = "Public ip name"
}

variable "publicip_nat_name" {
  type        = string
  description = "name of the public ip address for the nat gateway"
}

variable "domain_name_label" {
  type        = string
  description = "Label for the Domain Name. Will be used to make up the FQDN"
}

variable "dns_zone_name" {
  type        = string
  description = "Name of the private DNS Zone used by the pgsql database"
}