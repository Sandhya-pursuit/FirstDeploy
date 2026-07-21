@description('Location of the resource group.')
param location string = resourceGroup().location

@description('Name of the storage account.')
param storageName string

@description('Name of the Log Analytics workspace.')
param logAnalyticsName string

@description('Name of the Application Insights resource.')
param appInsightsName string

@description('Name of the Key Vault.')
param keyVaultName string

@description('Object ID of the Sandya user.')
param SandyaObjectId string

@description('Object ID of the Sounak user.')
param SounakObjectId string

@description('Object ID of the Tapas user.')
param TapasObjectId string

@description('Object ID of the Saheb user.')
param SahebObjectId string

@description('Name of the Virtual Network.')
param vnetName string

@description('Name of the Subnet.')
param subnetName string

@description('Name of the Function App Service Plan.')
param funcAppServicePlanName string

@description('Properties of the Function App Service Plan.')
param functAppServicePlan object

@description('Name of Sounak Update Test Case Function App.')
param SounakUpdateTestcaseFuncAppName string

@description('Name of Sounak Event Listener Function App.')
param SounakEventListnerFuncAppName string

@description('Name of Saheb Function App.')
param SahebFuncAppName string

@description('qTest Base URL.')
param qTestBaseURL string

@description('Additional app settings for the Sounak Update Test Case Function App.')
param functionAppAdditionalSettings array = []

@description('Additional app settings for the Sounak Event Listener Function App.')
param functionAppListenerAdditionalSettings array = []

@description('Event Hub connection string.')
param eventHubConnectionString string

@description('Event Hub name.')
param eventHubName string

@description('Cosmos DB endpoint.')
param cosmosEndpoint string

@description('Name of the App Service Plan.')
param appserviceplanname string

@description('Properties of the App Service Plan.')
param appserviceplan object

@description('Name of the Sounak App Service.')
param SounakAppServiceName string

@description('Dotnet version for the Sounak App Service.')
param dotnetVersion string

@description('Microsoft logout URL for the Web App.')
param logOutUrl string








// Storage Account Module
module storage_Module 'modules/storageaccount.bicep' = {
  name: 'storage_Module'
  params: {
    storageAccountName: storageName
    location: location
  }
}

// Log Analytics Module
module logAnalytics_Module 'modules/loganalytics.bicep' = {
  name: 'logAnalytics_Module'
  params: {
    workspaceName: logAnalyticsName
    location: location
  }
}

// App Insights Module
module appInsights_Module 'modules/application-insights.bicep' = {
  name: 'appInsights_Module'
  params: {
    appInsightsName: appInsightsName
    location: location
    logAnalyticsWorkspaceId: logAnalytics_Module.outputs.logAnalyticsId
  }
}

// VNet Module
module vnet_Module 'modules/vnet.bicep' = {
  name: 'vnet_Module'
  params: {
    vnetName: vnetName
    location: location
    subnetName: subnetName
  }
}

// Key vault Module
module keyVaultModule 'modules/keyvault.bicep' = {
  name: 'keyVaultModule'
  params: {
    vaultName: keyVaultName
    location: location
    functionAppPrincipalId: functionapp_updatetestcase.outputs.functionIdentity
    functionAppListenerPrincipalId: functionapp_eventlistner.outputs.functionIdentity
    functionAppSahebPrincipalId: functionapp_saheb.outputs.functionIdentity
    SandyaObjectId: SandyaObjectId
    SounakObjectId: SounakObjectId
    TapasObjectId: TapasObjectId
    SahebObjectId: SahebObjectId 
  }
}

// Functionapp Service Plan Module
module functionappPlan_Module 'modules/functionappplan.bicep' = {
  name: 'functionappPlan_Module'
  params: {
    funcAppServicePlanName: funcAppServicePlanName
    functAppServicePlan: functAppServicePlan
    location: location
  }
}

// Sounak Functionapp Update Test Case Module
module functionapp_updatetestcase 'modules/functionapp.bicep' = {
  name: 'functionapp_updatetestcase_module'
  params: {
    funcappname: SounakUpdateTestcaseFuncAppName
    location: location
    serverfarmid: functionappPlan_Module.outputs.appServicePlanId
  }
}

// Sounak Functionapp Update test Case Config Module
module functionapp_updatetestcase_config 'modules/functionapp-config.bicep' = {
  name: 'functionapp_updatetestcase_config_module'
  params: {
    funcappname: SounakUpdateTestcaseFuncAppName
    serverfarmid: functionappPlan_Module.outputs.appServicePlanId
    instrumentkey: appInsights_Module.outputs.appInsightsInstrumentationKey
    storageaccountconnString: storage_Module.outputs.storageAccountConnectionString
    storageAccountKey: storage_Module.outputs.storageAccountKey
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

// Sounak Functionapp Event Listner Module
module functionapp_eventlistner 'modules/functionapp.bicep' = {
  name: 'functionapp_eventlistner_module'
  params: {
    funcappname: SounakEventListnerFuncAppName
    location: location
    serverfarmid: functionappPlan_Module.outputs.appServicePlanId
  }
}

// Sounak Functionapp Event Listner Config Module
module functionAppConfigEventListener 'modules/functionapp-config.bicep' = {
  name: 'functionAppConfigEventListenerModule'
  params: {
    funcappname: SounakEventListnerFuncAppName
    serverfarmid: functionappPlan_Module.outputs.appServicePlanId
    instrumentkey: appInsights_Module.outputs.appInsightsInstrumentationKey
    storageaccountconnString: storage_Module.outputs.storageAccountConnectionString
    storageAccountKey: storage_Module.outputs.storageAccountKey
    keyVaultName: keyVaultName
    eventHubConnectionString: eventHubConnectionString
    eventHubName: eventHubName
    cosmosEndpoint: cosmosEndpoint
    additionalAppSettings: functionAppListenerAdditionalSettings
  }
}

// Saheb Functionapp Practice Module
module functionapp_saheb 'modules/functionapp.bicep' = {
  name: 'functionappSahebModule'
  params: {
    funcappname: SahebFuncAppName
    location: location
    serverfarmid: functionappPlan_Module.outputs.appServicePlanId
  }
}

// Saheb Functionapp Config Module
module functionAppConfigSaheb 'modules/functionapp-config.bicep' = {
  name: 'functionAppConfigModuleSaheb'
  params: {
    funcappname: SahebFuncAppName
    serverfarmid: functionappPlan_Module.outputs.appServicePlanId
    instrumentkey: appInsights_Module.outputs.appInsightsInstrumentationKey
    storageaccountconnString: storage_Module.outputs.storageAccountConnectionString
    storageAccountKey: storage_Module.outputs.storageAccountKey
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

// App Service Plan Module
module appServicePlan_Module 'modules/appserviceplan.bicep' = {
  name: 'appServicePlan_Module'
  params: {
    appserviceplanname: appserviceplanname
    appserviceplan: appserviceplan
    location: location
  }
}


// App Service Cosmos DB API Module
module webApp_uatnextv2 'modules/appservice.bicep' = {
  params: {
    location: location
    webAppName: SounakAppServiceName
    dotnetVersion: dotnetVersion
    asp_serverFarmID: appServicePlan_Module.outputs.serverfarmID
    vnetSubnetID: vnet_Module.outputs.subnetId
    appSettings: [
      {
        name: 'APPINSIGHTS_INSTRUMENTATIONKEY'
        value: appInsights_Module.outputs.appInsightsInstrumentationKey
      }
      {
        name: 'APPINSIGHTS_PROFILERFEATURE_VERSION'
        value: '1.0.0'
      }
      {
        name: 'APPINSIGHTS_SNAPSHOTFEATURE_VERSION'
        value: '1.0.0'
      }
      {
        name: 'APPLICATIONINSIGHTS_CONNECTION_STRING'
        value: appInsights_Module.outputs.appInsightsConnectionString
      }
      {
        name: 'ApplicationInsightsAgent_EXTENSION_VERSION'
        value: '~2'
      }
      {
        name: 'ASPNETCORE_ENVIRONMENT'
        value: 'dev'
      }
      {
        name: 'DiagnosticServices_EXTENSION_VERSION'
        value: '~3'
      }
      {
        name: 'InstrumentationEngine_EXTENSION_VERSION'
        value: 'disabled'
      }
      {
        name: 'LogOutUrl'
        value: logOutUrl
      }
      {
        name: 'SnapshotDebugger_EXTENSION_VERSION'
        value: 'disabled'
      }
      {
        name: 'WEBSITE_NODE_DEFAULT_VERSION'
        value: '6.9.1'
      }
      {
        name: 'WEBSITE_RUN_FROM_PACKAGE'
        value: 1
      }
      {
        name: 'XDT_MicrosoftApplicationInsights_BaseExtensions'
        value: 'disabled'
      }
      {
        name: 'XDT_MicrosoftApplicationInsights_Java'
        value: 1
      }
      {
        name: 'XDT_MicrosoftApplicationInsights_Mode'
        value: 'recommended'
      }
      {
        name: 'XDT_MicrosoftApplicationInsights_NodeJS'
        value: 1
      }
      {
        name: 'XDT_MicrosoftApplicationInsights_PreemptSdk'
        value: 'disabled'
      }
    ]
  }
}
