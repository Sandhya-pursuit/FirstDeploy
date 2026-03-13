param funcappname string
param serverfarmid string
param instrumentkey string
param storageaccountconnString string
param eventHubConnectionString string
param eventHubName string
param storageAccountKey string

resource funcconfig 'Microsoft.Web/sites/config@2023-01-01' = {
  name: '${funcappname}/web'

  properties: {
    serverFarmId: serverfarmid

    appSettings: [
      {
        name: 'AzureWebJobsStorage'
        value: storageaccountconnString
      }
      {
        name: 'WEBSITE_CONTENTAZUREFILECONNECTIONSTRING'
        value: storageaccountconnString
      }
      {
        name: 'WEBSITE_CONTENTSHARE'
        value: toLower(funcappname)
      }
      {
        name: 'FUNCTIONS_EXTENSION_VERSION'
        value: '~4'
      }
      {
        name: 'FUNCTIONS_WORKER_RUNTIME'
        value: 'dotnet'
      }
      {
        name: 'APPINSIGHTS_INSTRUMENTATIONKEY'
        value: instrumentkey
      }
      {
        name: 'secret_eventhub_connstring'
        value: '@Microsoft.KeyVault(SecretUri=${eventHubConnectionString})'
      }
      {
        name: 'secret_eventhub_name'
        value: '@Microsoft.KeyVault(SecretUri=${eventHubName})'
      }
      {
        name: 'STORAGE_ACCOUNT_ACCESS_KEY'
        value: storageAccountKey
    }
    ]

    cors: {
      allowedOrigins: [
        'https://portal.azure.com'
      ]
    }
  }
}
