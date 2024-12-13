@description('Value for owner tag.')
param ownerValue string 

@description('Location for the resources.')
param location string = resourceGroup().location

@description('Size of VMs in the Core VM Scale Set.')
param vmSizeCore string = 'Standard_D2s_v3'

@description('Size of VMs in the Engine VM Scale Set.')
param vmSizeEngine string = 'Standard_D2s_v3'

@description('Number of Core VM instances.')
param instanceCountCore int = 2

@description('Number of Standard Engine VM instances.')
param instanceCountStandardEngine int = 2

@description('Number of CpuTime Engine VM instances.')
param instanceCountCpuTimeEngine int = 2

@description('Name of the storage account')
param storageAccountName string = 'fmeflow${uniqueString(resourceGroup().id)}'

@description('Name of the Postgresql server')
param postgresServerName string = 'fmeflow-postgresql-${uniqueString(resourceGroup().id)}'

@description('Name of the virtual network')
param virtualNetworkName string = 'fmeflow-vnet'

@description('Address prefix of the virtual network')
param addressPrefixes array = ['10.0.0.0/16']

@description('Name of the subnet')
param subnetName string = 'default'

@description('Subnet prefix of the virtual network')
param subnetPrefix string = '10.0.0.0/24'

@description('Name of the subnet for the Application Gateway')
param subnetAGName string = 'AGSubnet'

@description('Subnet prefix of the Application Gateway subnet')
param subnetAGPrefix string = '10.0.1.0/24'

@description('Name of the subnet for the PGSQL database')
param subnetPGSQLName string = 'PGSQLsubnet'

@description('Subnet prefix of the PGSQL database subnet')
param subnetPGSQLPrefix string = '10.0.2.0/28'

@description('Name of the NAT gateway')
param natGatewayName string = 'fmeflow-nat'

@description('Name of the public ip address')
param publicIpName string = 'fmeflow-pip'

@description('Name of the NAT gateway public IP')
param publicIpNATName string = 'fmeflow-nat-pip'

@description('DNS of the public ip address for the VM')
param publicIpDns string = 'fmeflow-${uniqueString(resourceGroup().id)}'

@description('Name of the resource group for the existing virtual network')
param applicationGatewayName string = 'fmeflow-appgateway'

@description('Name of the resource group for the existing virtual network')
param engineRegistrationLoadBalancerName string = 'fmeflow-engineregistration'

@description('Admin username on all VMs.')
param adminUsername string

@description('Admin password on all VMs.')
@secure()
param adminPassword string

@description('Name of the private DNS Zone used by the pgsql database')
param dnsZoneName string = 'fmeflow-pgsql-dns-zone'

@description('Fully Qualified DNS Private Zone')
param dnsZoneFqdn string = '${dnsZoneName}.postgres.database.azure.com'

@description('Azure database for PostgreSQL storage Size ')
param storageSizeGB int = 32

var vmssNameCore = 'core'
var postgresqlAdministratorLogin = 'postgres'
var postgresqlAdministratorLoginPassword = 'P${uniqueString(resourceGroup().id, deployment().name, 'ad909260-dc63-4102-983f-4f82af7a6840')}x!'
var fileShareName = 'fmeflowdata'
var tags = {
  owner: ownerValue 
}
module network 'modules/network/network.bicep' = {
  name: 'fme-flow-network'
  params: {
    addressPrefixes: addressPrefixes
    location: location
    publicIpDns: publicIpDns
    publicIpName: publicIpName
    publicIpNATName: publicIpNATName
    subnetAGName: subnetAGName
    subnetAGPrefix: subnetAGPrefix
    subnetName: subnetName
    subnetPrefix: subnetPrefix
    subnetPGSQLName: subnetPGSQLName
    subnetPGSQLPrefix: subnetPGSQLPrefix
    natGatewayName: natGatewayName
    dnsZoneFqdn: dnsZoneFqdn
    tags: tags
    virtualNetworkName: virtualNetworkName
  }
}

module loadBalancer 'modules/lb-services/lb/lb.bicep' = {
  name: 'fme-flow-loadBalancer'
  params: {
    engineRegistrationLoadBalancerName: engineRegistrationLoadBalancerName
    location: location
    subnetId: network.outputs.subnetId
    tags: tags
  }
}

module applicationGateway 'modules/lb-services/agw/agw.bicep' = {
  name: 'fme-flow-agw'
  params: {
    applicationGatewayName: applicationGatewayName
    location: location
    publicIpIdString: network.outputs.publicIpId
    subnetAGId: network.outputs.subnetAGId
    tags: tags
  }
}

module pgsql 'modules/database/pgsql.bicep' = {
  name: 'fme-flow-pgsql'
  params: {
    location: location
    postgresqlAdministratorLogin: postgresqlAdministratorLogin
    postgresqlAdministratorLoginPassword: postgresqlAdministratorLoginPassword 
    postgresServerName: postgresServerName 
    subnetPGSQLId:network.outputs.subnetPGSQLId 
    dnsZoneID: network.outputs.dnsZoneID
    storageSizeGB: storageSizeGB
    tags: tags
  }
}
module storage 'modules/storage/storage.bicep' = {
  name: 'fme-flow-storage'
  params: {
    fileShareName: fileShareName
    location: location
    storageAccountName: storageAccountName 
    subnetId: network.outputs.subnetId
    tags: tags
  }
}

module vmssCore 'modules/vmss/vmss_core/vmss_core.bicep' = {
  name: 'fme-core-vmss'
  params: {
    adminPassword: adminPassword 
    adminUsername: adminUsername
    applicationGatewayBackEndName: applicationGateway.outputs.applicationGatewayBackEndName
    applicationGatewayName: applicationGatewayName
    engineRegistrationLoadBalancerName: engineRegistrationLoadBalancerName
    instanceCountCore:instanceCountCore
    engineRegistrationloadBalancerBackEndName: loadBalancer.outputs.engineRegistrationloadBalancerBackEndName
    location: location
    publicIpFqdn: network.outputs.publicIpFqdn
    postgresFqdn: pgsql.outputs.postgresFqdn
    postgresqlAdministratorLogin: postgresqlAdministratorLogin
    postgresqlAdministratorLoginPassword: postgresqlAdministratorLoginPassword
    storageAccountName: storage.outputs.storageAccountName
    subnetId: network.outputs.subnetId
    tags: tags
    vmSizeCore: vmSizeCore
    vmssName: vmssNameCore
  }
}

module vmssStandardEngine 'modules/vmss/vmss_engine/vmss_engine.bicep' = {
  name: 'fme-standard-engine-vmss'
  params: {
    adminPassword: adminPassword 
    adminUsername: adminUsername
    instanceCountEngine:instanceCountStandardEngine
    engineRegistrationHost: loadBalancer.outputs.engineRegistrationHost
    location: location
    postgresFqdn: pgsql.outputs.postgresFqdn
    storageAccountName: storage.outputs.storageAccountName
    subnetId: network.outputs.subnetId
    tags: tags
    vmSizeEngine: vmSizeEngine
    vmssName: 'standard'
    engineType: 'STANDARD'
  }
  dependsOn: [
    vmssCore
  ]
}

// The CPU-Usage (Dynamic) Engine scale set is optional and a custom image is recommended following these instructions is recommended: https://github.com/safesoftware/fme-server-iac-templates/tree/main/Azure/packer

// module vmssCpuUsageEngine 'modules/vmss/vmss_engine/vmss_engine.bicep' = {
//   name: 'fme-cpu-usage-engine-vmss'
//   params: {
//     adminPassword: adminPassword 
//     adminUsername: adminUsername
//     instanceCountEngine:instanceCountCpuTimeEngine
//     engineRegistrationHost: loadBalancer.outputs.engineRegistrationHost
//     location: location
//     postgresFqdn: pgsql.outputs.postgresFqdn
//     storageAccountName: storage.outputs.storageAccountName
//     subnetId: network.outputs.subnetId
//     tags: tags
//     vmSizeEngine: vmSizeEngine
//     vmssName: 'cpuUsage'
//     engineType: 'DYNAMIC'
//   }
//   dependsOn: [
//     vmssCore
//   ]
// }

output fqdn string = network.outputs.publicIpFqdn
