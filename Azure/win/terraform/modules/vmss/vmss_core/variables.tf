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

variable "lb_be_address_pool_id" {
  type        = string
  description = "Load balancer backend address pool id"
}

variable "agw_backend_address_pool_ids" {
  type        = set(string)
  description = "Application gateway backend address pool id"
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

variable "db_admin_user" {
  type        = string
  description = "Backend database admin username"
  sensitive   = true
}

variable "db_admin_pw" {
  type        = string
  description = "Backend database admin pw"
  sensitive   = true
}

variable "db_fqdn" {
  type        = string
  description = "Fully qualified domain name of the postgresql database server"
}

variable "fqdn" {
  type        = string
  description = "Fully qualified domain name of the A DNS record associated with the public IP."
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


