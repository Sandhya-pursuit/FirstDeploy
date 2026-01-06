param location string = resourceGroup().location
param storageName string
param appServicePlanName string
param funcAppName string
param logAnalyticsName string
param appInsightsName string
param keyVaultName string
param vnetName string


module storageModule 'modules/storageaccount.bicep' = {
  name: 'storageModule'
  params: { 
    storageAccountName: storageName 
    location: location 
  }
}

module appServicePlanModule 'modules/plan.bicep' = {
  name: 'appServicePlanModule'
  params: {
    appServicePlanName: appServicePlanName
    location: location
  }
}

module logAnalyticsModule 'modules/loganalytics.bicep' = {
  name: 'logAnalyticsModule'
  params: { 
    workspaceName: logAnalyticsName
     location: location 
    }
}

module appInsightsModule 'modules/app-ins.bicep' = {
  name: 'appInsightsModule'
  params: {
    appInsightsName: appInsightsName
    location: location
    logAnalyticsWorkspaceId: logAnalyticsModule.outputs.logAnalyticsId
  }
}

module functionAppModule 'modules/func-app.bicep' = {
  name: 'functionAppModule'
  params: {
    funcAppName: funcAppName
    location: location
    serverFarmId: appServicePlanModule.outputs.appServicePlanId
    storageAccountConnectionString: storageModule.outputs.storageAccountConnectionString
    appInsightsKey: appInsightsModule.outputs.appInsightsInstrumentationKey
    appInsightsConnectionString: appInsightsModule.outputs.appInsightsConnectionString
  }
}

module keyVaultModule 'modules/keyvault.bicep' = {
  name: 'keyVaultModule'
  params: {
    vaultName: keyVaultName
    location: location
    accessPolicies: [
      { 
        objectId: functionAppModule.outputs.functionAppPrincipalId
        permissions: { 
          secrets: ['Get', 'List']
          keys: ['Get', 'List']
        }
      }
    ]
  }
}

module vnetModule 'modules/vnet.bicep' = {
  name: 'vnetModule'
  params: { 
    vnetName: vnetName
    location: location
  }
}
