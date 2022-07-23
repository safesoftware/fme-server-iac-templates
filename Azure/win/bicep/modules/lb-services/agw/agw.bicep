@description('Location for the resources.')
param location string

@description('Onwer tag to be added to the resources.')
param tags object

@description('Name of the resource group for the existing virtual network')
param applicationGatewayName string

@description('Applciaiton gateway Subnet ID.')
param subnetAGId string

@description('Public IP ID string')
param publicIpIdString string

var applicationGatewayBackEndName = 'applicationGatewayBackEnd'

resource applicationGateway 'Microsoft.Network/applicationGateways@2021-08-01' = {
  name: applicationGatewayName
  location: location
  properties: {
    sku: {
      name: 'Standard_Medium'
      tier: 'Standard'
      capacity: 1
    }
    gatewayIPConfigurations: [
      {
        name: 'appGatewayIpConfig'
        properties: {
          subnet: {
            id: subnetAGId
          }
        }
      }
    ]
    frontendIPConfigurations: [
      {
        name: 'appGwPublicFrontendIp'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: publicIpIdString
          }
        }
      }
    ]
    frontendPorts: [
      {
        name: 'port_80'
        properties: {
          port: 80
        }
      }
      {
        name: 'port_7078'
        properties: {
          port: 7078
        }
      }
    ]
    probes: [
      {
        properties: {
          protocol: 'Http'
          path: '/'
          interval: 30
          timeout: 30
          unhealthyThreshold: 3
          pickHostNameFromBackendHttpSettings: true
          match: {
            statusCodes: [
              '200-400'
            ]
          }
        }
        name: 'websocketProbe'
      }
    ]
    backendAddressPools: [
      {
        name: applicationGatewayBackEndName
      }
    ]
    backendHttpSettingsCollection: [
      {
        name: 'httpSetting'
        properties: {
          port: 8080
          protocol: 'Http'
          cookieBasedAffinity: 'Disabled'
          pickHostNameFromBackendAddress: false
          requestTimeout: 86400
        }
      }
      {
        name: 'websocketSetting'
        properties: {
          port: 7078
          protocol: 'Http'
          cookieBasedAffinity: 'Disabled'
          pickHostNameFromBackendAddress: true
          requestTimeout: 86400
          probe: {
            id: resourceId('Microsoft.Network/applicationGateways/probes', applicationGatewayName, 'websocketProbe')
          }
        }
      }
    ]
    httpListeners: [
      {
        name: 'httpListener'
        properties: {
          frontendIPConfiguration: {
            id: resourceId('Microsoft.Network/applicationGateways/frontendIPConfigurations', applicationGatewayName, 'appGwPublicFrontendIp')
          }
          frontendPort: {
            id: resourceId('Microsoft.Network/applicationGateways/frontendPorts', applicationGatewayName, 'port_80')
          }
          protocol: 'Http'
          requireServerNameIndication: false
        }
      }
      {
        name: 'websocketListener'
        properties: {
          frontendIPConfiguration: {
            id: resourceId('Microsoft.Network/applicationGateways/frontendIPConfigurations', applicationGatewayName, 'appGwPublicFrontendIp')
          }
          frontendPort: {
            id: resourceId('Microsoft.Network/applicationGateways/frontendPorts', applicationGatewayName, 'port_7078')
          }
          protocol: 'Http'
          requireServerNameIndication: false
        }
      }
    ]
    requestRoutingRules: [
      {
        name: 'httpRoutingRule'
        properties: {
          ruleType: 'Basic'
          httpListener: {
            id: resourceId('Microsoft.Network/applicationGateways/httpListeners', applicationGatewayName, 'httpListener')
          }
          backendAddressPool: {
            id: resourceId('Microsoft.Network/applicationGateways/backendAddressPools', applicationGatewayName, applicationGatewayBackEndName)
          }
          backendHttpSettings: {
            id: resourceId('Microsoft.Network/applicationGateways/backendHttpSettingsCollection', applicationGatewayName, 'httpSetting')
          }
        }
      }
      {
        name: 'websocketRoutingRule'
        properties: {
          ruleType: 'Basic'
          httpListener: {
            id: resourceId('Microsoft.Network/applicationGateways/httpListeners', applicationGatewayName, 'websocketListener')
          }
          backendAddressPool: {
            id: resourceId('Microsoft.Network/applicationGateways/backendAddressPools', applicationGatewayName, applicationGatewayBackEndName)
          }
          backendHttpSettings: {
            id: resourceId('Microsoft.Network/applicationGateways/backendHttpSettingsCollection', applicationGatewayName, 'websocketSetting')
          }
        }
      }
    ]
    enableHttp2: false
  }
  tags: tags
}

@description('Application gateway backend name.')
output applicationGatewayBackEndName string = applicationGatewayBackEndName
