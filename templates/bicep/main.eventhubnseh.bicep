param eventHubNamespaceName string
param EHNskuTier string
param EHNskuCapacity int
param eventHubName string
param consumerGroupName string
param location string

param functionAppName string
param functionAppListenerName string


resource FunctionApp 'Microsoft.Web/sites@2023-01-01' existing = {
  name: functionAppName
}

resource functionAppListener 'Microsoft.Web/sites@2023-01-01' existing = {
  name: functionAppListenerName
}

module eventHubModule 'modules/eventhub-namespace.bicep' = {
  name: 'eventHubModule'
  params: {
    eventHubNamespaceName: eventHubNamespaceName
    eventhubname: eventHubName
    EHNskuTier: EHNskuTier
    EHNskuCapacity: EHNskuCapacity
    location: location
    consumerGroupName: consumerGroupName
    dataSenderfunctionAppPrincipalId: FunctionApp.identity.principalId
    dataReceiverfunctionAppPrincipalId: functionAppListener.identity.principalId
  }
}

output eventHubConnectionString string = eventHubModule.outputs.eventHubConnectionString
output eventHubName string = eventHubModule.outputs.eventHubName
