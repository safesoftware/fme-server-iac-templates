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

variable "vm_admin_user" {
  type        = string
  description = "Specifies the windows virual machine admin username. This variable should be retrieved from an [environment variable](https://www.terraform.io/cli/config/environment-variables#tf_var_name) or a secure secret store like [Azure Key Vault](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault). DOT NOT HARDCODE."
  sensitive   = true
}

variable "vm_admin_pw" {
  type        = string
  description = "Specifies the windows virual machine admin pw. This variable should be retrieved from an [environment variable](https://www.terraform.io/cli/config/environment-variables#tf_var_name) or a secure secret store like [Azure Key Vault](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault). DOT NOT HARDCODE."
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

