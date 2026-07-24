param eventHubNamespaceName string
param EHNskuTier string
param EHNskuCapacity int
param eventHubName string
param consumerGroupName string
param location string

param datasenderfunctionappname string
param datareceiverfunctionappname string


resource datasenderfunctionapp 'Microsoft.Web/sites@2023-01-01' existing = {
  name: datasenderfunctionappname

}

resource datareceiverfunctionapp 'Microsoft.Web/sites@2023-01-01' existing = {
  name: datareceiverfunctionappname
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
    dataSenderfunctionAppPrincipalId: datasenderfunctionapp.identity.principalId
    dataReceiverfunctionAppPrincipalId: datareceiverfunctionapp.identity.principalId
  }
}

output eventHubConnectionString string = eventHubModule.outputs.eventHubConnectionString
output eventHubName string = eventHubModule.outputs.eventHubName
