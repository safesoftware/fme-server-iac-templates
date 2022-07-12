# FME Server Engine VMSS module
This module creates the virtual machince scale set for the FME Engine of a distributed FME Server deployment in Azure.
## Variables
|Variable|Description|
|---|---|
|`owner` - Specifies the value for the owner tag.|
|`rg_name` | The name of the resource group in which to create the FME Server deployment.|
|`location` | Specifies the supported Azure location where the resource exists.|
|`be_snet_id` | ID of the backend subnet of the FME Server deployment (see network module).|