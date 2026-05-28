param cosmosDbAccountName string
param location string
param functionAppName string
param functionAppListenerName string

resource FunctionApp 'Microsoft.Web/sites@2023-01-01' existing = {
  name: functionAppName
}

resource functionAppListener 'Microsoft.Web/sites@2023-01-01' existing = {
  name: functionAppListenerName
}
module cosmosDbAccount 'modules/cosmosdbaccnt.bicep' = {
  name: 'cosmosDbAccountModule'
  params: {
    cosmosDbAccountName: cosmosDbAccountName
    location: location
    functionAppPrincipalId: FunctionApp.identity.principalId
    functionAppListenerPrincipalId: functionAppListener.identity.principalId
  }
}

output cosmosDbEndpoint string = cosmosDbAccount.outputs.cosmosEndpoint

