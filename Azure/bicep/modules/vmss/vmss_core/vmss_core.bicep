@description('Location for the resources.')
param location string

@description('Size of VMs in the Core VM Scale Set.')
param vmSizeCore string

@description('Name of the VM Scaleset for the engine or core machine machines')
@maxLength(61)
param vmssName string

@description('Number of Core VM instances.')
param instanceCountCore int

@description('Name of the resource group for the existing virtual network')
param applicationGatewayName string

@description('Name of the resource group for the existing virtual network')
param engineRegistrationLoadBalancerName string

@description('Admin username on all VMs.')
param adminUsername string

@description('Admin password on all VMs.')
@secure()
param adminPassword string

@description('Onwer tag to be added to the resources.')
param tags object

@description('Name of the storage account.')
param storageAccountName string

@description('PostgreSQL admin username.')
param postgresqlAdministratorLogin string

@description('PostgreSQL admin password.')
@secure()
param postgresqlAdministratorLoginPassword string

@description('Fully qulified domain name of public IP.')
param publicIpFqdn string

@description('Fully qualified domain name of the PostgreSQL Server.')
param postgresFqdn string

@description('engineregistration load balancer backend name.')
param engineRegistrationloadBalancerBackEndName string

@description('Application gateway backend name.')
param applicationGatewayBackEndName string

@description('Backend subnet ID.')
param subnetId string

resource storageAccount 'Microsoft.Storage/storageAccounts@2021-09-01' existing = {
  name: storageAccountName
}

// To use a custom image instead of the Azure Marketplace image the an existing image resource needs to be referenced by its name and resource group:
// resource fmeCoreImage 'Microsoft.Compute/images@2022-03-01' existing = {
//   name: '<image_name>'
//   scope: resourceGroup('<rg_name.')
// }

resource vmssNameCore_resource 'Microsoft.Compute/virtualMachineScaleSets@2021-03-01' = {
  name: vmssName
  location: location
  sku: {
    name: vmSizeCore
    capacity: instanceCountCore
  }
  plan: {
    publisher: 'safesoftwareinc'
    name: 'fme-core-2024-2-windows-byol'
    product: 'fme-core'
  }
  properties: {
    overprovision: false
    upgradePolicy: {
      mode: 'Manual'
    }
    virtualMachineProfile: {
      storageProfile: {
        osDisk: {
          createOption: 'FromImage'
          caching: 'ReadWrite'
        }
        imageReference: {
          // To use a custom image the 'plan' block and the publisher, offer, sku & version properties need to be commented. If an an existing image resource has been added it can be reference by its id:
          // id: fmeCoreImage.id
          publisher: 'safesoftwareinc'
          offer: 'fme-core'
          sku: 'fme-core-2024-2-windows-byol'
          version: '1.0.3'
        }
      }
      osProfile: {
        computerNamePrefix: vmssName
        adminUsername: adminUsername
        adminPassword: adminPassword
      }
      networkProfile: {
        networkInterfaceConfigurations: [
          {
            name: 'nic-core'
            properties: {
              primary: true
              ipConfigurations: [
                {
                  name: 'ipconfig'
                  properties: {
                    subnet: {
                      id: subnetId
                    }
                    loadBalancerBackendAddressPools: [
                      {
                        id: resourceId('Microsoft.Network/loadBalancers/backendAddressPools', engineRegistrationLoadBalancerName, engineRegistrationloadBalancerBackEndName)
                      }
                    ]
                    applicationGatewayBackendAddressPools: [
                      {
                        id: resourceId('Microsoft.Network/applicationGateways/backendAddressPools', applicationGatewayName, applicationGatewayBackEndName)
                      }
                    ]
                  }
                }
              ]
            }
          }
        ]
      }
      extensionProfile: {
        extensions: [
          {
            name: 'customScript'
            properties: {
              publisher: 'Microsoft.Compute'
              protectedSettings: {
                commandToExecute: 'powershell -ExecutionPolicy Unrestricted -File C:\\config_fmeflow_confd.ps1 -databasehostname ${postgresFqdn} -databasePassword ${postgresqlAdministratorLoginPassword} -databaseUsername ${postgresqlAdministratorLogin} -externalhostname ${publicIpFqdn} -storageAccountName ${storageAccountName} -storageAccountKey ${listKeys(storageAccount.id, '2019-04-01').keys[0].value} >C:\\confd-log.txt 2>&1'
              }
              typeHandlerVersion: '1.8'
              autoUpgradeMinorVersion: true
              type: 'CustomScriptExtension'
            }
          }
        ]
      }
    }
  }
  tags: tags
}
