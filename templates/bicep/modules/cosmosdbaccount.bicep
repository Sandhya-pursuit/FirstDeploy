param cosmosDbAccountName string
param location string
param dataSenderfunctionAppPrincipalId string
param dataReceiverwebapiPrincipalId string

resource cosmosDbAccount 'Microsoft.DocumentDB/databaseAccounts@2023-04-15' = {
  name: cosmosDbAccountName
  location: location
  kind: 'GlobalDocumentDB'
  properties: {
    enableFreeTier: false
    createMode: 'Default'
    databaseAccountOfferType: 'Standard'
    consistencyPolicy: {
      defaultConsistencyLevel: 'Session'
    }
    locations: [
      {
        locationName: location
        failoverPriority: 0
      }
    ]
    enableAutomaticFailover: false
  }
}

resource functionAppRoleAssignment 'Microsoft.DocumentDB/databaseAccounts/sqlRoleAssignments@2023-04-15' = {
  name: guid(cosmosDbAccount.id, dataSenderfunctionAppPrincipalId, 'data-contributor')
  parent: cosmosDbAccount
  properties: {
    principalId: dataSenderfunctionAppPrincipalId
    roleDefinitionId: '${cosmosDbAccount.id}/sqlRoleDefinitions/00000000-0000-0000-0000-000000000002'
    scope: cosmosDbAccount.id
  }
}

resource webApiRoleAssignment 'Microsoft.DocumentDB/databaseAccounts/sqlRoleAssignments@2023-04-15' = {
  name: guid(cosmosDbAccount.id, dataReceiverwebapiPrincipalId, 'data-reader')
  parent: cosmosDbAccount
  properties: {
    principalId: dataReceiverwebapiPrincipalId
    roleDefinitionId: '${cosmosDbAccount.id}/sqlRoleDefinitions/00000000-0000-0000-0000-000000000001'
    scope: cosmosDbAccount.id
  }
}

output cosmosdbaccountid string = cosmosDbAccount.id
output cosmosEndpoint string = cosmosDbAccount.properties.documentEndpoint
