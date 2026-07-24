param cosmosDbAccountName string
param location string
param datasenderfunctionappname string
param datareceiverwebapiname string

resource dataSenderfunctionapp 'Microsoft.Web/sites@2023-01-01' existing = {
  name: datasenderfunctionappname
}

resource datareceiverwebapi 'Microsoft.Web/sites@2023-01-01' existing = {
  name: datareceiverwebapiname
}

module cosmosDbAccount 'modules/cosmosdbaccount.bicep' = {
  name: 'cosmosDbAccountModule'
  params: {
    cosmosDbAccountName: cosmosDbAccountName
    location: location
    dataSenderfunctionAppPrincipalId: dataSenderfunctionapp.identity.principalId
    dataReceiverwebapiPrincipalId: datareceiverwebapi.identity.principalId 
  }
}

output cosmosDbEndpoint string = cosmosDbAccount.outputs.cosmosEndpoint
