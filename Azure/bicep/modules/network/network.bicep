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

@description('Name of the public ip address')
param publicIpName string

@description('DNS of the public ip address for the VM')
param publicIpDns string

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2021-03-01' = {
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

resource publicIp 'Microsoft.Network/publicIPAddresses@2021-03-01' = {
  name: publicIpName
  location: location
  sku: {
    name: 'Standard'
  }
  properties: {
    publicIPAllocationMethod: 'Static'
    dnsSettings: {
      domainNameLabel: toLower(publicIpDns)
    }
    idleTimeoutInMinutes: 30
  }
  tags: tags
}

@description('Virtual network ID.')
output virtualNetworkId string = virtualNetwork.id
@description('Backend subnet ID.')
output subnetId string = '${ virtualNetwork.id }/subnets/${ subnetName }'
@description('Applciation gateway subnet ID.')
output subnetAGId string = '${ virtualNetwork.id }/subnets/${ subnetAGName }'
@description('Public IP ID.')
output publicIpId string = publicIp.id
@description('Fully qulified domain name of public IP.')
output publicIpFqdn string = publicIp.properties.dnsSettings.fqdn
