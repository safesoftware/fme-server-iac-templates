# FME Server storage module
This module creates the required storage account and fileshare for a distributed FME Server deployment in Azure.
## Parameters
|Parameter|Description|
|---|---|
|`location` | Location for the resources.
|`tags` | Owner tag to be added to the resources.
|`subnetId` | ID of the backend subnet of the FME Server deployment (see network module).
|`fileShareName` | Name of the fileshare.
|`storageAccountName` | Name of the storage account.
## Output
|Output|Description|
|---|---|
|`storageAccountName` | Name of the Azure storage account for the FME Sever file share.|
|`storageAccountId` | Storage account ID.|