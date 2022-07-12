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

variable "db_fqdn" {
  type        = string
  description = "Fully qualified domain name of the postgresql database server"
}

variable "db_user" {
  type        = string
  description = "Backend FME Server database username"
  sensitive   = true
}

variable "db_pw" {
  type        = string
  description = "Backend FME Server database pw"
  sensitive   = true
}

variable "vm_admin_user" {
  type        = string
  description = "Windows virual machine admin username"
  sensitive   = true
}

variable "vm_admin_pw" {
  type        = string
  description = "Windows virual machine admin pw"
  sensitive   = true
}

variable "lb_private_ip_address" {
  type        = string
  description = "Private IP address of the load balancer"
}

variable "storage_name" {
  type        = string
  description = "FME Server backend storage account name"
}

variable "storage_key" {
  type        = string
  description = "FME Server backend storage account key"
  sensitive   = true
}

