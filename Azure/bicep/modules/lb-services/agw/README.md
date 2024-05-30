# FME Flow application gateway module
This module creates the application gateway for a distributed FME Flow deployment in Azure. This application gateway acts as a frontend load balancer to make sure any requests are routed to an available core in case a core becomes unavailable.
### Parameters
|Parameter|Description|
|---|---|
|`location` | Location for the resources.
|`tags` | Owner tag to be added to the resources.
|`subnetAGId` | ID of the application gateway subnet of the FME Flow deployment (see network module).|
|`vnet_name`|Virtual network name.|
|`applicationGatewayName`|Application gateway name.|
|`publicIpIdString`|Public IP id.|
### Output
|Output|Description|
|---|---|
|`applicationGatewayBackEndName` | Name of the application gateway backend.|

