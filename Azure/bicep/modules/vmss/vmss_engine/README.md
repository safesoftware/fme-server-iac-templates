# FME Server Engine VMSS module
This module creates the virtual machine scale set for the FME Engine of a distributed FME Server deployment in Azure.
## Parameters
|Parameter|Description|
|---|---|
|`location`|Location for the resources.|
|`vmSizeEngine`|Size of VMs in the Engine VM Scale Set.|
|`vmssName`|Name of the VM Scale Set for the engine or core machine machines|
|`instanceCountEngine`|Number of Engine VM instances.|
|`adminUsername`|Admin username on all VMs.|
|`adminPassword`|Admin password on all VMs.|
|`tags`|Owner tag to be added to the resources.|
|`storageAccountName`|Name of the storage account.|
|`postgresFqdn`|Fully qualified domain name of the PostgreSQL Server.|
|`engineRegistrationHost`|Engineregistration host.|
|`subnetId`|Backend subnet ID.|



