param location string = resourceGroup().location
param storageName string
param appServicePlanName string
param funcAppName string
param logAnalyticsName string
param appInsightsName string
param keyVaultName string
param vnetName string

param eventHubNamespaceName string

param sharedAccessPolicyName string
param EHNskuTier string 
param EHNskuCapacity int 

param PlanSkuName string  
param PlanSkuTier string  
param PlanCapacity int


param eventHubName string
param consumerGroupName string 
param funcAppNameEventlistner string

param functionAppAdditionalSettings array = []
param functionAppListenerAdditionalSettings array = []

param cosmosDbAccountName string






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
    PlanSkuName: PlanSkuName
    PlanSkuTier: PlanSkuTier
    PlanCapacity: PlanCapacity
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

module functionapp 'modules/func-app.bicep' = {
  name: 'functionappModule'
  params: {
    funcappname: funcAppName
    location: location
    serverfarmid: appServicePlanModule.outputs.appServicePlanId
  }
}

module eventHubModule 'modules/eventNShub.bicep' = {
  name: 'eventHubModule'
  params: {
    eventHubNamespaceName: eventHubNamespaceName
    eventhubname: eventHubName
    sharedAccessPolicyName: sharedAccessPolicyName
    EHNskuTier: EHNskuTier
    EHNskuCapacity: EHNskuCapacity
    location: location
    consumerGroupName: consumerGroupName
  }
}
module cosmosDbAccount 'modules/cosmosdbaccnt.bicep' = {
  name: 'cosmosDbAccountModule'
  params: {
    cosmosDbAccountName: cosmosDbAccountName
    location: location
  }
}
module keyVaultModule 'modules/keyvault.bicep' = {
  name: 'keyVaultModule'
  params: {
    vaultName: keyVaultName
    location: location
    eventHubConnectionString: eventHubModule.outputs.eventHubConnectionString
    eventHubName: eventHubModule.outputs.eventHubName
    functionAppPrincipalId: functionapp.outputs.functionIdentity
    functionAppListenerPrincipalId: functionappeventlistner.outputs.functionIdentity
    cosmosConnectionString: cosmosDbAccount.outputs.cosmosdbconnstring
    
  }
  
}

module functionAppConfig 'modules/FunctionAppConfig.bicep' = {
  name: 'functionAppConfigModule'
  params: {
    funcappname: funcAppName
    serverfarmid: appServicePlanModule.outputs.appServicePlanId
    instrumentkey: appInsightsModule.outputs.appInsightsInstrumentationKey
    storageaccountconnString: storageModule.outputs.storageAccountConnectionString
    eventHubConnectionString: eventHubModule.outputs.eventHubConnectionString
    eventHubName: eventHubModule.outputs.eventHubName
    storageAccountKey: storageModule.outputs.storageAccountKey

    additionalAppSettings: functionAppAdditionalSettings
   

  }
  dependsOn: [
    functionapp
    keyVaultModule
    
  ]
}



module vnetModule 'modules/vnet.bicep' = {
  name: 'vnetModule'
  params: { 
    vnetName: vnetName
    location: location
  }
  
}



module functionappeventlistner 'modules/func-app.bicep' = {
  name: 'functionappeventlistnerModule'
  params: {
    funcappname: funcAppNameEventlistner
    location: location
    serverfarmid: appServicePlanModule.outputs.appServicePlanId
  }
}

module functionAppConfigEventListener 'modules/FunctionAppConfig.bicep' = {
  name: 'functionAppConfigEventListenerModule'

  params: {
    funcappname: funcAppNameEventlistner
    serverfarmid: appServicePlanModule.outputs.appServicePlanId
    instrumentkey: appInsightsModule.outputs.appInsightsInstrumentationKey
    storageaccountconnString: storageModule.outputs.storageAccountConnectionString
    eventHubConnectionString: eventHubModule.outputs.eventHubConnectionString
    eventHubName: eventHubModule.outputs.eventHubName
    storageAccountKey: storageModule.outputs.storageAccountKey

    additionalAppSettings: concat(
  functionAppListenerAdditionalSettings,
  [
    {
      name: 'secret_cosmosdb_connstring'
      value: '@Microsoft.KeyVault(SecretUri=${keyVaultModule.outputs.cosmosConnectionString})'
    }
  ]
)
  }

  dependsOn: [
    
  
    
  ]
}



