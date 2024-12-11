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

@description('Name of the subnet for the PGSQL database')
param subnetPGSQLName string

@description('Address prefix of the virtual network')
param addressPrefixes array

@description('Subnet prefix of the virtual network')
param subnetPrefix string

@description('Subnet prefix of the Application Gateway subnet')
param subnetAGPrefix string

@description('Subnet prefix of the PGSQL database subnet')
param subnetPGSQLPrefix string

@description('Name of the NAT gateway')
param natGatewayName string

@description('Name of the public ip address')
param publicIpName string

@description('Name of the NAT gateway public IP')
param publicIpNATName string

@description('DNS of the public ip address for the VM')
param publicIpDns string

@description('Fully Qualified DNS Private Zone')
param dnsZoneFqdn string

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

resource publicIpNAT 'Microsoft.Network/publicIPAddresses@2021-03-01' = {
  name: publicIpNATName
  location: location
  sku: {
    name: 'Standard'
  }
  properties: {
    publicIPAllocationMethod: 'Static'
    idleTimeoutInMinutes: 30
  }
  tags: tags
}

resource natgateway 'Microsoft.Network/natGateways@2021-05-01' = {
  name: natGatewayName
  location: location
  sku: {
    name: 'Standard'
  }
  properties: {
    idleTimeoutInMinutes: 10
    publicIpAddresses: [
      {
        id: publicIpNAT.id
      }
    ]
  }
}


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
          natGateway: {
            id: natgateway.id
          }
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
      {
        name: subnetPGSQLName
          properties: {
          addressPrefix: subnetPGSQLPrefix
          delegations: [
            {
              name: 'dlg-Microsoft.DBforPostgreSQL-flexibleServers'
              properties: {
              serviceName: 'Microsoft.DBforPostgreSQL/flexibleServers'
            }
          }
        ]
        privateEndpointNetworkPolicies: 'Enabled'
        privateLinkServiceNetworkPolicies: 'Enabled'
       }
      }
    ]
  }
  tags: tags
}


resource dnszone 'Microsoft.Network/privateDnsZones@2020-06-01' = {
  name: dnsZoneFqdn
  location: 'global'
}

resource vnetLink 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2020-06-01' = {
  name: virtualNetwork.name
  parent: dnszone
  location: 'global'
  properties: {
    registrationEnabled: false
    virtualNetwork: {
      id: virtualNetwork.id
    }
  }
}

@description('Virtual network ID.')
output virtualNetworkId string = virtualNetwork.id
@description('Backend subnet ID.')
output subnetId string = '${ virtualNetwork.id }/subnets/${ subnetName }'
@description('Applciation gateway subnet ID.')
output subnetAGId string = '${ virtualNetwork.id }/subnets/${ subnetAGName }'
@description('Database subnet ID.')
output subnetPGSQLId string = '${ virtualNetwork.id }/subnets/${ subnetPGSQLName }'
@description('Public IP ID.')
output publicIpId string = publicIp.id
@description('Fully qulified domain name of public IP.')
output publicIpFqdn string = publicIp.properties.dnsSettings.fqdn
@description('ID of the DNS Zone.')
output dnsZoneID string = dnszone.id
