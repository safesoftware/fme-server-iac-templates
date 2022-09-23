# FME Server load balancer module
This module creates load balancer for a distributed FME Server deployment in Azure. The load balancer makes sure the available engines will connect to an available core in case a core that has engines registered is becoming unavailable. 
## Parameters
|Parameter|Description|
|---|---|
|`location` | Location for the resources.
|`tags` | Owner tag to be added to the resources.
|`subnetId` | ID of the backend subnet of the FME Server deployment (see network module).
|`engineRegistrationLoadBalancerName` | Specifies the name of the load balancer.|
## Output
|Output|Description|
|---|---|
|`engineRegistrationHost` |Private IP address of the load balancer.|
|`engineRegistrationloadBalancerBackEndName`|Backend address pool id of the load balancer.|