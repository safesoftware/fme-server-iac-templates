@description('Location for the resources.')
param location string

@description('Onwer tag to be added to the resources.')
param tags object

@description('Backend Subnet ID.')
param subnetPGSQLId string

@description('ID of the DNS Zone')
param dnsZoneID string

@description('Name of the Postgresql server')
param postgresServerName string

@description ('Backend database admin username')
param postgresqlAdministratorLogin string

@description ('Backend database admin password')
@secure()
param postgresqlAdministratorLoginPassword string

@description('Azure database for PostgreSQL storage Size ')
param storageSizeGB int

resource postgresServer 'Microsoft.DBforPostgreSQL/flexibleServers@2022-12-01' = {
  location: location
  name: postgresServerName
  sku: {
    name: 'Standard_D2s_V3'
    tier: 'GeneralPurpose'
  }
  properties: {
    version: '16'
    createMode: 'Default'
    administratorLogin: postgresqlAdministratorLogin
    administratorLoginPassword: postgresqlAdministratorLoginPassword
    storage: {
      storageSizeGB: storageSizeGB
    }
    backup: {
      backupRetentionDays: 7
      geoRedundantBackup: 'disabled'
    }
    network: {
      delegatedSubnetResourceId: subnetPGSQLId
      privateDnsZoneArmResourceId: dnsZoneID
    }
   }
  tags: tags
  }


@description('Fully qualified domain name of the PostgreSQL Server.')
output postgresFqdn string = postgresServer.properties.fullyQualifiedDomainName
