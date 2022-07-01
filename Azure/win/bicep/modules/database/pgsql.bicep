@description('Location for the resources.')
param location string

@description('Onwer tag to be added to the resources.')
param tags object

@description('Backend Subnet ID.')
param subnetId string

@description('Name of the Postgresql server')
param postgresServerName string

@description ('Backend database admin username')
param postgresqlAdministratorLogin string

@description ('Backend database admin password')
param postgresqlAdministratorLoginPassword string

resource postgresServer 'Microsoft.DBforPostgreSQL/servers@2017-12-01' = {
  location: location
  name: postgresServerName
  sku: {
    name: 'GP_Gen5_2'
    tier: 'GeneralPurpose'
    capacity: 2
    size: '51200'
    family: 'Gen5'
  }
  properties: {
    version: '10'
    createMode: 'Default'
    administratorLogin: postgresqlAdministratorLogin
    administratorLoginPassword: postgresqlAdministratorLoginPassword
  }
  resource postgresServerVNetRule 'virtualNetworkRules' = {
    name: 'postgres-vnet-rule'
    properties: {
      virtualNetworkSubnetId: subnetId
      ignoreMissingVnetServiceEndpoint: true
    }
  }

  resource postgresDatabase 'databases' = {
    name: 'postgres'
    properties: {
      charset: 'utf8'
      collation: 'English_United States.1252'
    }
  }
  tags: tags
}

@description('Fully qualified domain name of the PostgreSQL Server.')
output postgresFqdn string = postgresServer.properties.fullyQualifiedDomainName
