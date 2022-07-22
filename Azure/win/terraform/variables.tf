variable "owner" {
  type        = string
  default     = "gf"
  description = "Default value for onwer tag"
}

variable "rg_name" {
  type        = string
  default     = "terraform-rg"
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

variable "agw_name" {
  type        = string
  default     = "fme-server-agw"
  description = "Application gateway name"
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

variable "db_admin_user" {
  type        = string
  description = "Specifies the backend database admin username. This variable should be retrieved from an [environment variable](https://www.terraform.io/cli/config/environment-variables#tf_var_name) or a secure secret store like [Azure Key Vault](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault). DOT NOT HARDCODE."
  sensitive   = true
}

variable "db_admin_pw" {
  type        = string
  description = "Specifies the backend database admin pw. This variable should be retrieved from an [environment variable](https://www.terraform.io/cli/config/environment-variables#tf_var_name) or a secure secret store like [Azure Key Vault](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault). DOT NOT HARDCODE."
  sensitive   = true
}

variable "db_user" {
  type        = string
  description = "The login for the fmeserver database (Only used for Azure SQL Server). This variable should be retrieved from an [environment variable](https://www.terraform.io/cli/config/environment-variables#tf_var_name) or a secure secret store like [Azure Key Vault](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault). DOT NOT HARDCODE."
  sensitive   = true
}

variable "db_pw" {
  type        = string
  description = "The password for the fmeserver database (Only used for Azure SQL Server. Please review the [SQL Server Password Policy](https://docs.microsoft.com/en-us/sql/relational-databases/security/password-policy?view=azuresqldb-current)). This variable should be retrieved from an [environment variable](https://www.terraform.io/cli/config/environment-variables#tf_var_name) or a secure secret store like [Azure Key Vault](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault). DOT NOT HARDCODE."
  sensitive   = true
}