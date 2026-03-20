param cosmosDbAccountName string
param location string 

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


var cosmosconnectionstring = cosmosDbAccount.listConnectionStrings().connectionStrings[0].connectionString

output cosmosdbaccountid string = cosmosDbAccount.id
output cosmosdbconnstring string = cosmosconnectionstring
