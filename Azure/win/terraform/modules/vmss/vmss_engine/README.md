# FME Server Engine VMSS module
This module creates the virtual machince scale set for the FME Engine of a distributed FME Server deployment in Azure.
## Variables
|Variable|Description|
|---|---|
|`owner`|Default value for onwer tag.|
|`rg_name`|Resource group name.|
|`location`|Location of resources.|
|`be_snet_id`|Backend virtual network subnet id.|
|`db_fqdn`|Fully qualified domain name of the postgresql database server.|
|`storage_name`|FME Server backend storage account name.|
|`storage_key`|FME Server backend storage account key.|
|`lb_private_ip_address`|Private IP address of the load balancer.|
|`vm_admin_user` | Specifies the windows virual machine admin username. This variable should be retrieved from an [environment variable](https://www.terraform.io/cli/config/environment-variables#tf_var_name) or a secure secret store like [Azure Key Vault](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault). DOT NOT HARDCODE.|
|`vm_admin_pw` | Specifies the windows virual machine admin pw. This variable should be retrieved from an [environment variable](https://www.terraform.io/cli/config/environment-variables#tf_var_name) or a secure secret store like [Azure Key Vault](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault). DOT NOT HARDCODE.|