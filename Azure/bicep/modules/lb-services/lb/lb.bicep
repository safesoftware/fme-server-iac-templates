@description('Location for the resources.')
param location string

@description('Backend Subnet ID.')
param subnetId string

@description('Onwer tag to be added to the resources.')
param tags object

@description('Name of the resource group for the existing virtual network')
param engineRegistrationLoadBalancerName string

var engineRegistrationloadBalancerFrontEndName = 'engineRegistrationFrontend'
var engineRegistrationloadBalancerBackEndName = 'engineRegistrationBackend'

resource engineRegistrationLoadBalancer 'Microsoft.Network/loadBalancers@2023-09-01' = {
  name: engineRegistrationLoadBalancerName
  location: location
  sku: {
    name: 'Standard'
  }
  properties: {
    frontendIPConfigurations: [
      {
        name: engineRegistrationloadBalancerFrontEndName
        properties: {
          subnet: {
            id: subnetId
          }
          privateIPAllocationMethod: 'Dynamic'
        }
      }
    ]
    backendAddressPools: [
      {
        name: engineRegistrationloadBalancerBackEndName
      }
    ]
    loadBalancingRules: [
      {
        name: 'roundRobinEngineRegistrationRule'
        properties: {
          frontendIPConfiguration: {
            id: resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', engineRegistrationLoadBalancerName, engineRegistrationloadBalancerFrontEndName)
          }
          backendAddressPool: {
            id: resourceId('Microsoft.Network/loadBalancers/backendAddressPools', engineRegistrationLoadBalancerName, engineRegistrationloadBalancerBackEndName)
          }
          protocol: 'Tcp'
          frontendPort: 7070
          backendPort: 7070
          enableFloatingIP: false
          idleTimeoutInMinutes: 30
        }
      }
    ]
  }
  tags: tags
}

@description('Private IP address of engineregistrationhost.')
output engineRegistrationHost string = engineRegistrationLoadBalancer.properties.frontendIPConfigurations[0].properties.privateIPAddress

@description('Engineregistrationhost backend name.')
output engineRegistrationloadBalancerBackEndName string = engineRegistrationLoadBalancer.properties.backendAddressPools[0].name
