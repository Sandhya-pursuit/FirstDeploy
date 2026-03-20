param funcappname string
param serverfarmid string
param instrumentkey string
param storageaccountconnString string
param eventHubConnectionString string
param eventHubName string
param storageAccountKey string

param additionalAppSettings array = []

resource funcconfig 'Microsoft.Web/sites/config@2023-01-01' = {
  name: '${funcappname}/web'

  properties: {
    serverFarmId: serverfarmid

    appSettings: concat([
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
        value: concat('@Microsoft.KeyVault(SecretUri=', eventHubConnectionString,')')
      }
      {
        name: 'secret_eventhub_name'
        value: concat('@Microsoft.KeyVault(SecretUri=',eventHubName,')')
      }
      {
        name: 'STORAGE_ACCOUNT_ACCESS_KEY'
        value: storageAccountKey
      }
      
    ] , additionalAppSettings)

    cors: {
      allowedOrigins: [
        'https://portal.azure.com'
      ]
    }
  }
}
