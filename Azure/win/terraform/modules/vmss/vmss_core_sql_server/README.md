# FME Server Core VMSS module using Azure SQL Server
This module creates the virtual machince scale set for the FME Core of a distributed FME Server deployment using a Azure SQL Server backend database.
## Variables
|Variable|Description|
|---|---|
|`owner` | Specifies the value for the owner tag.|
|`rg_name` | The name of the resource group in which to create the FME Server deployment.|
|`location` | Specifies the supported Azure location where the resource exists.|
|`be_snet_id` | ID of the backend subnet of the FME Server deployment (see network module).|
|`owner`|Default value for onwer tag.|
|`rg_name`|Resource group name.|
|`location`|Location of resources.|
|`be_snet_id`|Backend virtual network subnet id.|
|`lb_be_address_pool_id`|Load balancer backend address pool id.|
|`agw_backend_address_pool_ids`|Application gateway backend address pool id.|
|`db_fqdn`|Fully qualified domain name of the postgresql database server.|
|`fqdn`|Fully qualified domain name of the A DNS record associated with the public IP.|
|`storage_name`|FME Server backend storage account name.|
|`storage_key`|FME Server backend storage account key.|
|`vm_admin_user` | Specifies the windows virual machine admin username. This variable should be retrieved from an [environment variable](https://www.terraform.io/cli/config/environment-variables#tf_var_name) or a secure secret store like [Azure Key Vault](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault). DOT NOT HARDCODE.|
|`vm_admin_pw` | Specifies the windows virual machine admin pw. This variable should be retrieved from an [environment variable](https://www.terraform.io/cli/config/environment-variables#tf_var_name) or a secure secret store like [Azure Key Vault](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault). DOT NOT HARDCODE.|
|`db_admin_user` | Specifies the backend database admin username. This variable should be retrieved from an [environment variable](https://www.terraform.io/cli/config/environment-variables#tf_var_name) or a secure secret store like [Azure Key Vault](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault). DOT NOT HARDCODE.|
|`db_admin_pw` | Specifies the backend database admin pw. This variable should be retrieved from an [environment variable](https://www.terraform.io/cli/config/environment-variables#tf_var_name) or a secure secret store like [Azure Key Vault](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault). DOT NOT HARDCODE.|
|`db_user` | The login for the fmeserver database (Only used for Azure SQL Server). This variable should be retrieved from an [environment variable](https://www.terraform.io/cli/config/environment-variables#tf_var_name) or a secure secret store like [Azure Key Vault](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault). DOT NOT HARDCODE.|
|`db_pw` | The password for the fmeserver database (Only used for Azure SQL Server. Please review the [SQL Server Password Policy](https://docs.microsoft.com/en-us/sql/relational-databases/security/password-policy?view=azuresqldb-current)). This variable should be retrieved from an [environment variable](https://www.terraform.io/cli/config/environment-variables#tf_var_name) or a secure secret store like [Azure Key Vault](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault). DOT NOT HARDCODE.|