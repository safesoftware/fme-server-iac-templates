@description('Value for owner tag.')
param ownerValue string 

@description('Location for the resources.')
param location string = resourceGroup().location

@description('Size of VMs in the Core VM Scale Set.')
param vmSizeCore string = 'Standard_D2s_v3'

@description('Size of VMs in the Engine VM Scale Set.')
param vmSizeEngine string = 'Standard_D2s_v3'

@description('Number of Core VM instances.')
param instanceCountCore int = 1

@description('Number of Engine VM instances.')
param instanceCountEngine int = 1

@description('Name of the storage account')
param storageAccountName string = 'fmeserver${uniqueString(resourceGroup().id)}'

@description('Name of the Postgresql server')
param postgresServerName string = 'fmeserver-postgresql-${uniqueString(resourceGroup().id)}'

@description('Name of the virtual network')
param virtualNetworkName string = 'fmeserver-vnet'

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

@description('Name of the public ip address')
param publicIpName string = 'fmeserver-pip'

@description('DNS of the public ip address for the VM')
param publicIpDns string = 'fmeserver-${uniqueString(resourceGroup().id)}'

@description('Allocation method for the public ip address')
@allowed([
  'Dynamic'
  'Static'
])
param publicIpAllocationMethod string = 'Dynamic'

@description('Name of the resource group for the public ip address')
@allowed([
  'Basic'
  'Standard'
])
param publicIpSku string = 'Basic'

@description('Name of the resource group for the existing virtual network')
param applicationGatewayName string = 'fmeserver-appgateway'

@description('Name of the resource group for the existing virtual network')
param engineRegistrationLoadBalancerName string = 'fmeserver-engineregistration'

@description('Admin username on all VMs.')
param adminUsername string

@description('Admin password on all VMs.')
@secure()
param adminPassword string

var vmssNameCore = 'fmeserver-core'
var vmssNameEngine = 'fmeserver-engine'
var postgresqlAdministratorLogin = 'postgres'
var postgresqlAdministratorLoginPassword = 'P${uniqueString(resourceGroup().id, deployment().name, 'ad909260-dc63-4102-983f-4f82af7a6840')}x!'
var fileShareName = 'fmeserverdata'
var tags = {
  'owner': ownerValue 
}
module network 'modules/network/network.bicep' = {
  name: 'fme-server-network'
  params: {
    addressPrefixes: addressPrefixes
    location: location
    publicIpAllocationMethod: publicIpAllocationMethod
    publicIpDns: publicIpDns
    publicIpName: publicIpName
    publicIpSku: publicIpSku
    subnetAGName: subnetAGName
    subnetAGPrefix: subnetAGPrefix
    subnetName: subnetName
    subnetPrefix: subnetPrefix
    tags: tags
    virtualNetworkName: virtualNetworkName
  }
}

module loadBalancer 'modules/lb-services/lb.bicep' = {
  name: 'fme-server-loadBalancer'
  params: {
    engineRegistrationLoadBalancerName: engineRegistrationLoadBalancerName
    location: location
    subnetId: network.outputs.subnetId
    tags: tags
  }
}

module applicationGateway 'modules/lb-services/agw.bicep' = {
  name: 'fme-server-agw'
  params: {
    applicationGatewayName: applicationGatewayName
    location: location
    publicIpIdString: network.outputs.publicIpId
    subnetAGId: network.outputs.subnetAGId
    tags: tags
  }
}

module pgsql 'modules/database/pgsql.bicep' = {
  name: 'fme-server-pgsql'
  params: {
    location: location
    postgresqlAdministratorLogin: postgresqlAdministratorLogin
    postgresqlAdministratorLoginPassword: postgresqlAdministratorLoginPassword 
    postgresServerName: postgresServerName 
    subnetId:network.outputs.subnetId 
    tags: tags
  }
}
module storage 'modules/storage/storage.bicep' = {
  name: 'fme-server-storage'
  params: {
    fileShareName: fileShareName
    location: location
    storageAccountName: storageAccountName 
    subnetId: network.outputs.subnetId
    tags: tags
  }
}

module vmssCore 'modules/vmss/vmss_core.bicep' = {
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

module vmssEngine 'modules/vmss/vmss_engine.bicep' = {
  name: 'fme-engine-vmss'
  params: {
    adminPassword: adminPassword 
    adminUsername: adminUsername
    instanceCountEngine:instanceCountEngine
    engineRegistrationHost: loadBalancer.outputs.engineRegistrationHost
    location: location
    postgresFqdn: pgsql.outputs.postgresFqdn
    storageAccountName: storage.outputs.storageAccountName
    subnetId: network.outputs.subnetId
    tags: tags
    vmSizeEngine: vmSizeEngine
    vmssName: vmssNameEngine
  }
}

output fqdn string = network.outputs.publicIpFqdn
