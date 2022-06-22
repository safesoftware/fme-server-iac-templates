# FME Server storage module
This module creates load balancer for a distributed FME Server deployment in Azure. The load balancer makes sure the available engines will connect to an available core in case a core that has engines registered is becoming unavailable. 
## Variables
|Variable|Description|
|---|---|
|`owner` | Specifies the value for the owner tag.|
|`rg_name` | Specifies the name of the resource group in which to create the FME Server deployment.|
|`location` | Specifies the supported Azure location where the resource exists.|
|`lb_name` | Specifies the name of the load balancer.|
|`be_snet_id` | ID of the backend subnet of the FME Server deployment (see network module).|
## Output
|Output|Description|
|---|---|
|`name` | Name of the Azure storage account for the FME Sever file share.|
|`primary_access_key` | The primary access key for the storage account.|