# FME Server database module
This module creates the backend database and its virtual network rule for a distributed FME Server deployment in Azure.

## Variables
|Variable|Description|
|---|---|
|`owner` | Specifies the value for the owner tag.
|`rg_name` | The name of the resource group in which to create the PostgreSQL Server.
|`location` | Specifies the supported Azure location where the resource exists.
|`admin_db_user` | The Administrator login for the PostgreSQL Server. Required when create_mode is Default. 
|`admin_db_pw` | The Password associated with the administrator_login for the PostgreSQL Server.
|`be_snet_id` | ID of the backend subnet of the FME Server deployment (see network module).

## Output
|Output|Description|
|---|---|
|`fqdn` | The FQDN of the PostgreSQL Server.