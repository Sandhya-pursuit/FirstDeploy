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

@secure()
@description('Secret value for the qTest token.')
param qTestTokenSecret string

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

@description('Event Hub connection string.')
param eventHubConnectionString string

@description('Event Hub name.')
param eventHubName string

@description('Cosmos DB endpoint.')
param cosmosEndpoint string

@description('Cosmos DB key.')
param cosmosKey string

@description('Cosmos DB database name.')
param cosmosDatabaseName string

@description('Cosmos DB container name.')
param cosmosContainerName string

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
module keyvault_Module 'modules/keyvault.bicep' = {
  name: 'keyvault_Module'
  params: {
    vaultName: keyVaultName
    location: location
    functionAppPrincipalId: functionapp_sounak_updatetestcase_module.outputs.functionIdentity
    functionAppListenerPrincipalId: functionapp_sounak_eventlistner_module.outputs.functionIdentity
    functionAppSahebPrincipalId: functionapp_saheb_module.outputs.functionIdentity
    SandyaObjectId: SandyaObjectId
    SounakObjectId: SounakObjectId
    TapasObjectId: TapasObjectId
    SahebObjectId: SahebObjectId
    qTestTokenSecret: qTestTokenSecret
  }
}

// Functionapp Service Plan Module
module functionappplan_module 'modules/functionappplan.bicep' = {
  name: 'functionappplan_module'
  params: {
    funcAppServicePlanName: funcAppServicePlanName
    functAppServicePlan: functAppServicePlan
    location: location
  }
}

// Sounak Functionapp Update Test Case Module
module functionapp_sounak_updatetestcase_module 'modules/functionapp.bicep' = {
  name: 'functionapp_sounak_updatetestcase_module'
  params: {
    funcappname: SounakUpdateTestcaseFuncAppName
    location: location
    serverfarmid: functionappplan_module.outputs.appServicePlanId
  }
}

// Sounak Functionapp Update test Case Config Module
module functionapp_sounak_updatetestcase_config_module 'modules/functionapp-config.bicep' = {
  name: 'functionapp_sounak_updatetestcase_config_module'
  params: {
    funcappname: SounakUpdateTestcaseFuncAppName
    serverfarmid: functionappplan_module.outputs.appServicePlanId
    appSettings: [
      {
        name: 'AzureWebJobsStorage'
        value: storage_Module.outputs.storageAccountConnectionString
      }
      {
        name: 'WEBSITE_CONTENTAZUREFILECONNECTIONSTRING'
        value: storage_Module.outputs.storageAccountConnectionString
      }
      {
        name: 'STORAGE_ACCOUNT_ACCESS_KEY'
        value: storage_Module.outputs.storageAccountKey
      }
      {
        name: 'WEBSITE_CONTENTSHARE'
        value: toLower(SounakUpdateTestcaseFuncAppName)
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
        value: appInsights_Module.outputs.appInsightsInstrumentationKey
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
        name: 'qTestBaseURL'
        value: qTestBaseURL
      }
      {
        name: 'qTestToken'
        value: '@Microsoft.KeyVault(VaultName=${keyVaultName};SecretName=qTestTokenSecret'
      }
    ]
  }
  dependsOn: [
    keyvault_Module
  ]
}

// Sounak Functionapp Event Listner Module
module functionapp_sounak_eventlistner_module 'modules/functionapp.bicep' = {
  name: 'functionapp_sounak_eventlistner_module'
  params: {
    funcappname: SounakEventListnerFuncAppName
    location: location
    serverfarmid: functionappplan_module.outputs.appServicePlanId
  }
}

// Sounak Functionapp Event Listner Config Module
module functionapp_sounak_eventlistner_config_module 'modules/functionapp-config.bicep' = {
  name: 'functionapp_sounak_eventlistner_config_module'
  params: {
    funcappname: SounakEventListnerFuncAppName
    serverfarmid: functionappplan_module.outputs.appServicePlanId
    appSettings: [
      {
        name: 'AzureWebJobsStorage'
        value: storage_Module.outputs.storageAccountConnectionString
      }
      {
        name: 'WEBSITE_CONTENTAZUREFILECONNECTIONSTRING'
        value: storage_Module.outputs.storageAccountConnectionString
      }
      {
        name: 'STORAGE_ACCOUNT_ACCESS_KEY'
        value: storage_Module.outputs.storageAccountKey
      }
      {
        name: 'WEBSITE_CONTENTSHARE'
        value: toLower(SounakEventListnerFuncAppName)
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
        value: appInsights_Module.outputs.appInsightsInstrumentationKey
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
    ]
  }
}

// Saheb Functionapp Practice Module
module functionapp_saheb_module 'modules/functionapp.bicep' = {
  name: 'functionapp_saheb_module'
  params: {
    funcappname: SahebFuncAppName
    location: location
    serverfarmid: functionappplan_module.outputs.appServicePlanId
  }
}

// Saheb Functionapp Config Module
module functionapp_saheb_config_module 'modules/functionapp-config.bicep' = {
  name: 'functionapp_saheb_config_module'
  params: {
    funcappname: SahebFuncAppName
    serverfarmid: functionappplan_module.outputs.appServicePlanId
    appSettings: [
      {
        name: 'AzureWebJobsStorage'
        value: storage_Module.outputs.storageAccountConnectionString
      }
      {
        name: 'WEBSITE_CONTENTAZUREFILECONNECTIONSTRING'
        value: storage_Module.outputs.storageAccountConnectionString
      }
      {
        name: 'STORAGE_ACCOUNT_ACCESS_KEY'
        value: storage_Module.outputs.storageAccountKey
      }
      {
        name: 'WEBSITE_CONTENTSHARE'
        value: toLower(SahebFuncAppName)
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
        value: appInsights_Module.outputs.appInsightsInstrumentationKey
      }
      {
        name: 'qTestToken'
        value: '@Microsoft.KeyVault(VaultName=${keyVaultName};SecretName=qTestTokenSecret'
      }
    ]
  }
  dependsOn: [
    keyvault_Module
  ]
}

// App Service Plan Module
module appServiceplan_module 'modules/appserviceplan.bicep' = {
  name: 'appServiceplan_module'
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
    asp_serverFarmID: appServiceplan_module.outputs.serverfarmID
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
        name: 'cosmosEndpoint'
        value: cosmosEndpoint
      }
      {
        name: 'cosmosKey'
        value: cosmosKey
      }
      {
        name: 'cosmosDatabaseName'
        value: cosmosDatabaseName
      }
      {
        name: 'cosmosContainerName'
        value: cosmosContainerName
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
