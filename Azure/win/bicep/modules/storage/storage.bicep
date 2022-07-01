@description('Location for the resources.')
param location string

@description('Backend Subnet ID.')
param subnetId string

@description('Onwer tag to be added to the resources.')
param tags object

@description('Name of the fileshare.')
@minLength(3)
@maxLength(63)
param fileShareName string

@description('Name of the storage account.')
param storageAccountName string

resource storageAccount 'Microsoft.Storage/storageAccounts@2021-02-01' = {
  name: storageAccountName
  location: location
  kind: 'FileStorage'
  sku: {
    name: 'Premium_LRS'
  }
  properties: {
    networkAcls: {
      bypass: 'AzureServices'
      defaultAction: 'Deny'
      virtualNetworkRules: [
        {
          id: subnetId
        }
      ]
    }
  }
  resource service 'fileServices' = {
    name: 'default'

    resource share 'shares' = {
      name: fileShareName
    }
  }
  tags: tags
}

@description('Storage account ID.')
output storageAccountId string = storageAccount.id
@description('Storage account name.')
output storageAccountName string = storageAccount.name
