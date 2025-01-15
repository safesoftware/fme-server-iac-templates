variable "owner" {
  type        = string
  description = "Default value for onwer tag"
}

variable "rg_name" {
  type        = string
  default     = "QA"
  description = "Resource group name"
}

variable "location" {
  type        = string
  default     = "Canada Central"
  description = "Location of resources"
}

variable "instance_count_core" {
  type = number
  default = 2
  description = "Number of Core VM instances"
}

variable "instance_count_engine" {
  type = number
  default = 2
  description = "Number of engine VM instances"
}

variable "vnet_name" {
  type        = string
  default     = "fme-flow-vnet"
  description = "Virtual network name"
}

variable "be_snet_name" {
  type        = string
  default     = "fme-flow-be-snet"
  description = "Backend virtual network subnet name"
}

variable "agw_snet_name" {
  type        = string
  default     = "fme-flow-agw-snet"
  description = "Application gateway virtual network subnet name"
}

variable "pgsql_snet_name" {
  type        = string
  default     = "fme-flow-pgsql-snet"
  description = "Application gateway virtual network subnet name"
}

variable "nat_gateway_name" {
  type        = string
  default     = "fmeflow-nat"
  description = "Name of the nat gateway"
}

variable "pip_name" {
  type        = string
  default     = "fme-flow-pip"
  description = "Public ip name"
}

variable "publicip_nat_name" {
  type        = string
  default     = "fmeflow-nat-pip"
  description = "name of the public ip address for the nat gateway"
}

variable "domain_name_label" {
  type        = string
  default     = "fmeflow"
  description = "Label for the Domain Name. Will be used to make up the FQDN"
}

variable "lb_name" {
  type        = string
  default     = "fme-flow-lb"
  description = "Load balancer name"
}

variable "agw_name" {
  type        = string
  default     = "fme-flow-agw"
  description = "Application gateway name"
}

variable "vm_admin_user" {
  type        = string
  description = "Specifies the windows virual machine admin username. This variable should be retrieved from an [environment variable](https://www.terraform.io/cli/config/environment-variables#tf_var_name) or a secure secret store like [Azure Key Vault](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault). DO NOT HARDCODE."
  sensitive   = true
}

variable "vm_admin_pw" {
  type        = string
  description = "Specifies the windows virual machine admin pw. Password must have 3 of the following: 1 lower case character, 1 upper case character, 1 number, and 1 special character. The value must be between 12 and 123 characters long. This variable should be retrieved from an [environment variable](https://www.terraform.io/cli/config/environment-variables#tf_var_name) or a secure secret store like [Azure Key Vault](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault). DO NOT HARDCODE."
  sensitive   = true
}

variable "db_admin_user" {
  type        = string
  description = "Specifies the backend database admin username. This variable should be retrieved from an [environment variable](https://www.terraform.io/cli/config/environment-variables#tf_var_name) or a secure secret store like [Azure Key Vault](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault). DO NOT HARDCODE."
  sensitive   = true
}

variable "db_admin_pw" {
  type        = string
  description = "Specifies the backend database admin pw. Your password must contain characters from three of the following categories: English uppercase letters, English lowercase letters, numbers (0 through 9), and non-alphanumeric characters (!, $, #, %, etc.). This variable should be retrieved from an [environment variable](https://www.terraform.io/cli/config/environment-variables#tf_var_name) or a secure secret store like [Azure Key Vault](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault). DO NOT HARDCODE."
  sensitive   = true
}

variable "db_user" {
  type        = string
  description = "The login for the fmeflow database (Only used for Azure SQL Server. Should be left blank when PostgreSQL is used). This variable should be retrieved from an [environment variable](https://www.terraform.io/cli/config/environment-variables#tf_var_name) or a secure secret store like [Azure Key Vault](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault). DO NOT HARDCODE."
  sensitive   = true
}

variable "db_pw" {
  type        = string
  description = "The password for the fmeflow database (Only used for Azure SQL Server. Should be left blank when PostgreSQL is used). Please review the [SQL Server Password Policy](https://docs.microsoft.com/en-us/sql/relational-databases/security/password-policy?view=azuresqldb-current)). This variable should be retrieved from an [environment variable](https://www.terraform.io/cli/config/environment-variables#tf_var_name) or a secure secret store like [Azure Key Vault](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault). DO NOT HARDCODE."
  sensitive   = true
}

variable "build_agent_public_ip" {
  type = string
  description = "Public IP of the build agent or machine that is running terraform deployment to be whitelisted in the storage account. This is a workaround for the following known issue: https://github.com/hashicorp/terraform-provider-azurerm/issues/2977"
}

variable "dns_zone_name" {
  type        = string
  default     = "fmeflow-pgsql-dns-zone"
  description = "Name of the private DNS Zone used by the pgsql database"
}

variable "availability_zone" {
  type        = string
  default     = "1" 
  description = "Availability zone for the pgsql database"
}