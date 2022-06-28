@description('Location for the resources.')
param location string

@description('Onwer tag to be added to the resources.')
param tags object

@description('Name of the virtual network')
param virtualNetworkName string

@description('Name of the backend subnet.')
param subnetName string

@description('Name of the application gateway subnet.')
param subnetAGName string

@description('Address prefix of the virtual network')
param addressPrefixes array

@description('Subnet prefix of the virtual network')
param subnetPrefix string

@description('Subnet prefix of the Application Gateway subnet')
param subnetAGPrefix string

@description('Determines whether or not a new virtual network should be provisioned.')
param virtualNetworkNewOrExisting string

@description('Determines whether or not a new public ip should be provisioned.')
param publicIpNewOrExisting string

@description('Name of the public ip address')
param publicIpName string

@description('DNS of the public ip address for the VM')
param publicIpDns string

@description('Allocation method for the public ip address')
@allowed([
  'Dynamic'
  'Static'
])
param publicIpAllocationMethod string

@description('Name of the resource group for the public ip address')
@allowed([
  'Basic'
  'Standard'
])
param publicIpSku string



resource virtualNetwork 'Microsoft.Network/virtualNetworks@2021-03-01' = if (virtualNetworkNewOrExisting == 'new') {
  name: virtualNetworkName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: addressPrefixes
    }
    subnets: [
      {
        name: subnetName
        properties: {
          addressPrefix: subnetPrefix
          serviceEndpoints: [
            {
              service: 'Microsoft.Storage'
            }
            {
              service: 'Microsoft.Sql'
            }
          ]
          privateEndpointNetworkPolicies: 'Enabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
        }
      }
      {
        name: subnetAGName
        properties: {
          addressPrefix: subnetAGPrefix
          privateEndpointNetworkPolicies: 'Enabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
        }
      }
    ]
  }
  tags: tags
}

resource publicIp 'Microsoft.Network/publicIPAddresses@2021-03-01' = if (publicIpNewOrExisting == 'new') {
  name: publicIpName
  location: location
  sku: {
    name: publicIpSku
  }
  properties: {
    publicIPAllocationMethod: publicIpAllocationMethod
    dnsSettings: {
      domainNameLabel: toLower(publicIpDns)
    }
    idleTimeoutInMinutes: 30
  }
  tags: tags
}

@description('Virtual network ID.')
output virtualNetworkId string = virtualNetwork.id

@description('Public IP ID.')
output publicIpId string = publicIp.id

