variable "owner" {
  type        = string
  default     = "gf"
  description = "Default value for onwer tag"
}

variable "rg_name" {
  type        = string
  default     = "fme-server-rg"
  description = "Resource group name"
}

variable "location" {
  type        = string
  default     = "Canada Central"
  description = "Location of resources"
}

variable "vnet_name" {
  type        = string
  default     = "fme-server-vnet"
  description = "Virtual network name"
}

variable "be_snet_name" {
  type        = string
  default     = "fme-server-be-snet"
  description = "Backend virtual network subnet name"
}

variable "agw_snet_name" {
  type        = string
  default     = "fme-server-agw-snet"
  description = "Application gateway virtual network subnet name"
}

variable "pip_name" {
  type        = string
  default     = "fme-server-pip"
  description = "Public ip name"
}

variable "domain_name_label" {
  type        = string
  default     = "fmeserver"
  description = "Label for the Domain Name. Will be used to make up the FQDN"
}

variable "lb_name" {
  type        = string
  default     = "fme-server-lb"
  description = "Load balancer name"
}

variable "engine_registration_lb_frontend_name" {
  type        = string
  default     = "engineRegistrationFrontend"
  description = "Engine registration load balancer frontend IP configuration name"
}

variable "engine_registration_lb_backend_name" {
  type        = string
  default     = "engineRegistrationBackend"
  description = "Engine registration load balancer frontend IP configuration name"
}

variable "agw_name" {
  type        = string
  default     = "fme-server-agw"
  description = "description"
}

# variable "st_name" {
#   type        = string
#   default     = "fmeserver010622"
#   description = "Name for Azure storage account used for FME Server"
# }

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

# variable "db_name" {
#   type        = string
#   default     = "fmeserver-postgresql010622"
#   description = "Name for database server used for FME Server"
# }

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

