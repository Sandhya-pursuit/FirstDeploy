param funcappname string
param serverfarmid string
param instrumentkey string
param storageaccountconnString string
@secure()
param storageAccountKey string
param keyVaultName string
param eventHubConnectionString string
param eventHubName string
param cosmosEndpoint string
param additionalAppSettings array = []

resource funcconfig 'Microsoft.Web/sites/config@2023-01-01' = {
  name: '${funcappname}/web'
  properties: {
    serverFarmId: serverfarmid
    netFrameworkVersion: 'v10.0'
    use32BitWorkerProcess: false
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
        name: 'eventHubConnectionString'
        value: eventHubConnectionString
      }
      {
        name: 'eventHubName'
        value: eventHubName
      }
      {
        name: 'CosmosEndpoint'
        value: cosmosEndpoint
      }
      
      {
        name: 'qTestToken'
        value: '@Microsoft.KeyVault(VaultName=${keyVaultName};SecretName=qTestToken)'
      }
      {
        name: 'STORAGE_ACCOUNT_ACCESS_KEY'
        value: storageAccountKey
      }
    ], additionalAppSettings)

    cors: {
      allowedOrigins: [
        'https://portal.azure.com'
      ]
    }
  }
}
