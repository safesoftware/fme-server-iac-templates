# FME Server network module
This module creates the requires network resources for a distributed FME Server deployment in Azure.

## Variables
|Variable|Description|
|---|---|
|`owner` | Specifies the value for the owner tag.
|`rg_name` | The name of the resource group in which to create the PostgreSQL Server.
|`location` | Specifies the supported Azure location where the resource exists.
|`vnet_name` | Specifies the virtual network name.
|`be_snet_name` | Specifies backend virtual network subnet name.
|`agw_snet_name` | Specifies application gateway virtual network subnet name.
|`pip_name` | Specifies public ip name.

## Output
|Output|Description|
|---|---|
|`vnet_name` | Virtual network name.
|`be_snet_id` | Backend virtual network subnet id.
|`agw_snet_id` | Application gateway virtual network subnet id.
|`pip_id` -|Public ip id.
|`fqdn` | Fully qualified domain name of the A DNS record associated with the public IP.