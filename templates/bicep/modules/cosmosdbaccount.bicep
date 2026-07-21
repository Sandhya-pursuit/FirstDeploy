param cosmosDbAccountName string
param location string
param functionAppPrincipalId string
param functionAppListenerPrincipalId string

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

resource cosmosRoleMain 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(cosmosDbAccount.id, functionAppPrincipalId, 'cosmos-role-main')
  scope: cosmosDbAccount
  properties: {
    roleDefinitionId: subscriptionResourceId(
      'Microsoft.Authorization/roleDefinitions',
      '5bd9cd88-fe45-4216-938b-f97437e15450'
    )
    principalId: functionAppPrincipalId
  }
}

resource cosmosRoleListener 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(cosmosDbAccount.id, functionAppListenerPrincipalId, 'cosmos-role-listener')
  scope: cosmosDbAccount
  properties: {
    roleDefinitionId: subscriptionResourceId(
      'Microsoft.Authorization/roleDefinitions',
      '5bd9cd88-fe45-4216-938b-f97437e15450'
    )
    principalId: functionAppListenerPrincipalId
  }
}

output cosmosdbaccountid string = cosmosDbAccount.id
output cosmosEndpoint string = cosmosDbAccount.properties.documentEndpoint
