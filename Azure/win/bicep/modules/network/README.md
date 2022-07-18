# FME Server network module
This module creates the requires network resources for a distributed FME Server deployment in Azure.

## Variables
|Variable|Description|
|---|---|
|`location` | Location for the resources.
|`tags` | Onwer tag to be added to the resources.
|`virtualNetworkName` | Specifies the virtual network name.
|`subnetName` | Specifies backend virtual network subnet name.
|`subnetAGName` | Specifies application gateway virtual network subnet name.
|`publicIpName` | Specifies public ip name.
|`publicIpDns`|Label for the Domain Name. Will be used to make up the FQDN.|

## Output
|Output|Description|
|---|---|
|`virtualNetworkId` | Virtual network id.
|`subnetId` | Backend virtual network subnet id.
|`subnetAGId` | Application gateway virtual network subnet id.
|`publicIpId` -|Public ip id.
|`publicIpFqdn` | Fully qualified domain name of the A DNS record associated with the public IP.