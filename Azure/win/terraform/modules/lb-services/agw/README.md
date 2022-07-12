# FME Server application gateway module
This module creates the application gateway for a distributed FME Server deployment in Azure. This application gateway acts as a frontent load balancer to make sure any requests are routed to an available core in case a core becomes unavailable.
## Variables
|Variable|Description|
|---|---|
|`owner` - Specifies the value for the owner tag.|
|`rg_name` | The name of the resource group in which to create the FME Server deployment.|
|`location` | Specifies the supported Azure location where the resource exists.|
|`agw_snet_id` | ID of the application gateway subnet of the FME Server deployment (see network module).|
|`vnet_name`|Virtual network name.|
|`agw_name`|Application gateway name.|
|`pip_id`|Public IP id.|
## Output
|Output|Description|
|---|---|
|`name` | Name of the Azure storage account for the FME Sever file share.|
|`primary_access_key` | The primary access key for the storage account.|