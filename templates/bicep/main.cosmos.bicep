param cosmosDbAccountName string
param location string
param functionAppListenerName string
param webAPIName string

resource functionAppListener 'Microsoft.Web/sites@2023-01-01' existing = {
  name: functionAppListenerName
}

resource webAPI 'Microsoft.Web/sites@2023-01-01' existing = {
  name: webAPIName
}

module cosmosDbAccount 'modules/cosmosdbaccount.bicep' = {
  name: 'cosmosDbAccountModule'
  params: {
    cosmosDbAccountName: cosmosDbAccountName
    location: location
    webapiPrincipalId: webAPI.identity.principalId
    functionAppListenerPrincipalId: functionAppListener.identity.principalId
  }
}

output cosmosDbEndpoint string = cosmosDbAccount.outputs.cosmosEndpoint
