param vaultName string
param location string
param eventHubConnectionString string
param eventHubName string
param functionAppPrincipalId string

resource keyvault 'Microsoft.KeyVault/vaults@2023-07-01' = {
  name: vaultName
  location: location
  properties: {
    tenantId: subscription().tenantId
    sku: {
      family: 'A'
      name: 'standard'
    }
    accessPolicies: [
      {
        objectId: functionAppPrincipalId
        tenantId: subscription().tenantId
        permissions: {
          secrets: [
            'Get'
            'List'
          ]
        }
      }
    ]
    enableSoftDelete: true
    softDeleteRetentionInDays: 7
    enableRbacAuthorization: false
    publicNetworkAccess: 'Enabled'
  }
}

resource eventhubConnSecret 'Microsoft.KeyVault/vaults/secrets@2023-07-01' = {
  parent: keyvault
  name: 'secret-eventhub-connstring'
  properties: {
    value: eventHubConnectionString
  }
}

resource eventhubNameSecret 'Microsoft.KeyVault/vaults/secrets@2023-07-01' = {
  parent: keyvault
  name: 'secret-eventhub-name'
  properties: {
    value: eventHubName
  }
}

output eventHubConnectionString string = eventhubConnSecret.properties.secretUriWithVersion
output eventHubName string = eventhubNameSecret.properties.secretUriWithVersion
