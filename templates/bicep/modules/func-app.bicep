@description('Function App name')
param funcAppName string

@description('Location')
param location string = resourceGroup().location

@description('App Service Plan Id')
param serverFarmId string

@description('Storage Account Connection String')
param storageAccountConnectionString string

@description('App Insights Instrumentation Key')
param appInsightsKey string

@description('App Insights Connection String')
param appInsightsConnectionString string

resource functionApp 'Microsoft.Web/sites@2020-12-01' = {
  name: funcAppName
  location: location
  kind: 'functionapp'
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    serverFarmId: serverFarmId
    httpsOnly: true
    keyVaultReferenceIdentity: 'SystemAssigned'
    siteConfig: {
      appSettings: [
        { 
          name: 'AzureWebJobsStorage'
          value: storageAccountConnectionString
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
          value: appInsightsKey 
        }
        {
           name: 'APPLICATIONINSIGHTS_CONNECTION_STRING'
           value: appInsightsConnectionString 
        }
        { 
          name: 'WEBSITE_RUN_FROM_PACKAGE'
           value: '1'
        }
      ]
    }
  }
}

output functionAppId string = functionApp.id
output functionAppPrincipalId string = functionApp.identity.principalId
