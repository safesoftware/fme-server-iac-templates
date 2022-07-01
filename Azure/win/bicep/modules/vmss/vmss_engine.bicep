@description('Location for the resources.')
param location string

@description('Size of VMs in the Engine VM Scale Set.')
param vmSizeEngine string

@description('Name of the VM Scaleset for the engine or core machine machines')
@maxLength(61)
param vmssName string

@description('Number of Engine VM instances.')
param instanceCountEngine int

@description('Admin username on all VMs.')
param adminUsername string

@description('Admin password on all VMs.')
@secure()
param adminPassword string

@description('Onwer tag to be added to the resources.')
param tags object

@description('Name of the storage account.')
param storageAccountName string

@description('Fully qualified domain name of the PostgreSQL Server.')
param postgresFqdn string

@description('engineregistration host.')
param engineRegistrationHost string

@description('Backend subnet ID.')
param subnetId string

resource storageAccount 'Microsoft.Storage/storageAccounts@2021-09-01' existing = {
  name: storageAccountName
}

resource vmssNameEngine_resource 'Microsoft.Compute/virtualMachineScaleSets@2021-03-01' = if (vmssName == 'fmeserver-engine') {
  name: vmssName
  location: location
  sku: {
    name: vmSizeEngine
    capacity: instanceCountEngine
  }
  plan: {
    publisher: 'safesoftwareinc'
    name: 'fme-engine-2022-0-0-2-windows-byol'
    product: 'fme-engine'
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
          publisher: 'safesoftwareinc'
          offer: 'fme-engine'
          sku: 'fme-engine-2022-0-0-2-windows-byol'
          version: '1.0.0'
        }
      }
      osProfile: {
        computerNamePrefix: 'engine'
        adminUsername: adminUsername
        adminPassword: adminPassword
      }
      networkProfile: {
        networkInterfaceConfigurations: [
          {
            name: 'nic-engine'
            properties: {
              primary: true
              ipConfigurations: [
                {
                  name: 'ipconfig'
                  properties: {
                    subnet: {
                      id: subnetId
                    }
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
                commandToExecute: 'powershell -ExecutionPolicy Unrestricted -File C:\\config_fmeserver_confd_engine.ps1 -databasehostname ${postgresFqdn} -engineregistrationhost ${engineRegistrationHost} -storageAccountName ${storageAccountName} -storageAccountKey ${listKeys(storageAccount.id, '2019-04-01').keys[0].value} >C:\\confd-log.txt 2>&1'
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
