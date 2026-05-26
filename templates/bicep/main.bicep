param location string = resourceGroup().location
param storageName string
param appServicePlanName string

param logAnalyticsName string
param appInsightsName string
param keyVaultName string
param vnetName string

param PlanSkuName string
param PlanSkuTier string
param PlanCapacity int
param myUserObjectId string
param userSObjectId string
param userTObjectId string
param userSOObjectId string


param funcAppName string
param funcAppNameEventlistner string

param funAppNameSaheb string // For Saheb - done by Sounak

param qTestBaseURL string

param functionAppAdditionalSettings array = []
param functionAppListenerAdditionalSettings array = []
param eventHubConnectionString string
param eventHubName string
param cosmosEndpoint string








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







module keyVaultModule 'modules/keyvault.bicep' = {
  name: 'keyVaultModule'
  params: {
    vaultName: keyVaultName
    location: location
    functionAppPrincipalId: functionapp.outputs.functionIdentity
    functionAppListenerPrincipalId: functionappeventlistner.outputs.functionIdentity
    functionAppSahebPrincipalId: functionappsaheb.outputs.functionIdentity                          // For Saheb - done by Sounak
    myUserObjectId: myUserObjectId
    userSObjectId: userSObjectId
    userTObjectId: userTObjectId
    userSOObjectId: userSOObjectId                                                                  // For Saheb - done by Sounak 
  }
}



module vnetModule 'modules/vnet.bicep' = {
  name: 'vnetModule'
  params: {
    vnetName: vnetName
    location: location
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

module functionappeventlistner 'modules/func-app.bicep' = {
  name: 'functionappeventlistnerModule'
  params: {
    funcappname: funcAppNameEventlistner
    location: location
    serverfarmid: appServicePlanModule.outputs.appServicePlanId
  }
}

// For Saheb - done by Sounak
module functionappsaheb 'modules/func-app.bicep' = {
  name: 'functionappSahebModule'
  params: {
    funcappname: funAppNameSaheb
    location: location
    serverfarmid: appServicePlanModule.outputs.appServicePlanId
  }
}

module functionAppConfig 'modules/FunctionAppConfig.bicep' = {
  name: 'functionAppConfigModule'
  params: {
    funcappname: functionapp.outputs.functionAppName
    serverfarmid: appServicePlanModule.outputs.appServicePlanId
    instrumentkey: appInsightsModule.outputs.appInsightsInstrumentationKey
    storageaccountconnString: storageModule.outputs.storageAccountConnectionString
    storageAccountKey: storageModule.outputs.storageAccountKey
    keyVaultName: keyVaultName
    eventHubConnectionString: eventHubConnectionString
    eventHubName: eventHubName
    cosmosEndpoint: cosmosEndpoint
    additionalAppSettings: concat(
      functionAppAdditionalSettings,
      [
        {
          name: 'qtestBaseUrl'
          value: qTestBaseURL
        }
      ]
    )
  }
  dependsOn: [
    keyVaultModule
  ]
}

module functionAppConfigEventListener 'modules/FunctionAppConfig.bicep' = {
  name: 'functionAppConfigEventListenerModule'
  params: {
    funcappname: functionappeventlistner.outputs.functionAppName
    serverfarmid: appServicePlanModule.outputs.appServicePlanId
    instrumentkey: appInsightsModule.outputs.appInsightsInstrumentationKey
    storageaccountconnString: storageModule.outputs.storageAccountConnectionString
    storageAccountKey: storageModule.outputs.storageAccountKey
    keyVaultName: keyVaultName
    eventHubConnectionString: eventHubConnectionString
    eventHubName: eventHubName
    cosmosEndpoint: cosmosEndpoint
    additionalAppSettings: functionAppListenerAdditionalSettings
  }
}

// For Saheb - done by Sounak
module functionAppConfigSaheb 'modules/FunctionAppConfig.bicep' = {
  name: 'functionAppConfigModuleSaheb'
  params: {
    funcappname: functionappsaheb.outputs.functionAppName
    serverfarmid: appServicePlanModule.outputs.appServicePlanId
    instrumentkey: appInsightsModule.outputs.appInsightsInstrumentationKey
    storageaccountconnString: storageModule.outputs.storageAccountConnectionString
    storageAccountKey: storageModule.outputs.storageAccountKey
    keyVaultName: keyVaultName
    eventHubConnectionString: eventHubConnectionString
    eventHubName: eventHubName
    cosmosEndpoint: cosmosEndpoint
    additionalAppSettings: concat(
      functionAppAdditionalSettings,
      [
        {
          name: 'qtestBaseUrl'
          value: qTestBaseURL
        }
      ]
    )
  }
  dependsOn: [
    keyVaultModule
  ]
}
