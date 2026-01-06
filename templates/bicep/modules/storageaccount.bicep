@description('Storage Account name')
param storageAccountName string

@description('Location')
param location string = resourceGroup().location

resource storageAccount 'Microsoft.Storage/storageAccounts@2022-09-01' = {
  name: storageAccountName
  location: location
  kind: 'StorageV2'
  sku: {
    name: 'Standard_LRS'
  }
  properties: {
    allowBlobPublicAccess: false
    minimumTlsVersion: 'TLS1_2'
    supportsHttpsTrafficOnly: true
  }
}

var storageAccountKey = storageAccount.listKeys().keys[0].value
var storageAccountConnectionString = 'DefaultEndpointsProtocol=https;AccountName=${storageAccount.name};EndpointSuffix=${environment().suffixes.storage};AccountKey=${storageAccountKey}'

output storageAccountId string = storageAccount.id
output storageAccountConnectionString string = storageAccountConnectionString
