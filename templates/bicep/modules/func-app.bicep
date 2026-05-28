param funcappname string
param location string
param serverfarmid string

resource functionApp 'Microsoft.Web/sites@2023-01-01' = {
  name: funcappname
  location: location
  kind: 'functionapp'
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    serverFarmId: serverfarmid
    keyVaultReferenceIdentity: 'SystemAssigned'
  }
}

output functionIdentity string = functionApp.identity.principalId
output functionAppName string = functionApp.name
