# FME Server database module
This module creates a PostgreSQL backend database and its virtual network rule for a distributed FME Server deployment in Azure.

## Variables
|Variable|Description|
|---|---|
|`admin_db_user` | The Administrator login for the PostgreSQL Server. Required when create_mode is Default. 
|`admin_db_pw` | The Password associated with the administrator_login for the PostgreSQL Server.
|`be_snet_group_name` | Name of the backend subnet group of the FME Server deployment (see network module).

## Output
|Output|Description|
|---|---|
|`fqdn` | The FQDN of the PostgreSQL Server.