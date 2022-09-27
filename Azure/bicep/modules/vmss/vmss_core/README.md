# FME Server Core VMSS module
This module creates the virtual machine scale set for the FME Core of a distributed FME Server deployment in Azure.
## Parameters
|Parameter|Description|
|---|---|
`location`|Location for the resources.|
`vmSizeCore`|Size of VMs in the Core VM Scale Set.|
`vmssName`|Name of the VM Scale Set for the engine or core machine machines|
`instanceCountCore`|Number of Core VM instances.|
`applicationGatewayName`|Name of the resource group for the existing virtual network|
`engineRegistrationLoadBalancerName`|Name of the resource group for the existing virtual network|
`adminUsername`|Admin username on all VMs.|
`adminPassword`|Admin password on all VMs.|
`tags`|Owner tag to be added to the resources.|
`storageAccountName`|Name of the storage account.|
`postgresqlAdministratorLogin`|PostgreSQL admin username.|
`postgresqlAdministratorLoginPassword`|PostgreSQL admin password.|
`publicIpFqdn`|Fully qualified domain name of public IP.|
`postgresFqdn`|Fully qualified domain name of the PostgreSQL Server.|
`engineRegistrationloadBalancerBackEndName`|engineregistration load balancer backend name.|
`applicationGatewayBackEndName`|Application gateway backend name.|
`subnetId`|Backend subnet ID.|




