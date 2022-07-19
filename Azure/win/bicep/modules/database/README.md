# FME Server database module
This module creates a PostgreSQL backend database and its virtual network rule for a distributed FME Server deployment in Azure.

## Parameters
|Parameter|Description|
|---|---|
|`location` | Location for the resources.
|`tags` | Onwer tag to be added to the resources.
|`subnetId` | ID of the backend subnet of the FME Server deployment (see network module).
|`postgresqlAdministratorLogin` | The Administrator login for the PostgreSQL Server. Required when create_mode is Default. 
|`postgresqlAdministratorLoginPassword` | The Password associated with the administrator_login for the PostgreSQL Server.
|`postgresServerName` | Name of the Postgresql server.

## Output
|Output|Description|
|---|---|
|`fqdn` | The FQDN of the PostgreSQL Server.