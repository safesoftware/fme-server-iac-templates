variable "owner" {
  type        = string
  default     = "gf"
  description = "Default value for onwer tag"
}

variable "rg_name" {
  type        = string
  default     = "fme-server-dist-rg"
  description = "Resource group name"
}

variable "location" {
  type        = string
  default     = "Canada Central"
  description = "Location of resources"
}

variable "vnet_name" {
  type        = string
  default     = "fme-server-dist-vnet"
  description = "Virtual network name"
}

variable "be_snet_name" {
  type        = string
  default     = "fme-server-dist-be-snet"
  description = "Backend virtual network subnet name"
}

variable "agw_snet_name" {
  type        = string
  default     = "fme-server-dist-agw-snet"
  description = "Application gateway virtual network subnet name"
}

variable "pip_name" {
  type        = string
  default     = "fme-server-dist-pip"
  description = "Vnet name"
}

variable "lb_name" {
  type        = string
  default     = "fme-server-dist-lb"
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
  default     = "fme-server-dist-agw"
  description = "description"
}

variable "st_name" {
  type        = string
  default     = "fmeserver010622"
  description = "Name for Azure storage account used for FME Server"
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

