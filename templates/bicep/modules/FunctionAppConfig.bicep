param funcappname string
param serverfarmid string
param instrumentkey string
param storageaccountconnString string

param storageAccountKey string
param keyVaultName string
param additionalAppSettings array = []

resource funcconfig 'Microsoft.Web/sites/config@2023-01-01' = {
  name: '${funcappname}/web'

  properties: {
    serverFarmId: serverfarmid
    netFrameworkVersion: 'v10.0'
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
        value: 'dotnet-isolated'
      }
      {
        name: 'APPINSIGHTS_INSTRUMENTATIONKEY'
        value: instrumentkey
      }
      {
        name: 'secret_eventhub_connstring'
        value: '@Microsoft.KeyVault(VaultName=${keyVaultName};SecretName=secret-eventhub-connstring)'
      }
      {
        name: 'secret_eventhub_name'
        value: '@Microsoft.KeyVault(VaultName=${keyVaultName};SecretName=secret-eventhub-name)'
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
