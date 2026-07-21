using '../main.bicep'

param storageName = 'stacprojctautodilab'

param logAnalyticsName = 'logan-ps-dev-autodilab'

param appInsightsName = 'appins-ps-dev-autodilab'

param keyVaultName = 'kv-ps-dev-autodilab'

param SandyaObjectId = '77c5b611-eedd-4ba6-ad1f-3fe14fdffea3'
param SounakObjectId = '9aa3c688-89a7-49eb-970e-fd0f00ad4015'
param TapasObjectId = '5df4258a-3ea6-4029-97af-8059a829dc17'
param SahebObjectId = 'de462505-c413-4130-b461-e94d9fc82066'

param vnetName = 'vnet-ps-dev-autodilab'
param subnetName = 'snet-ps-dev-autodilab'

param qTestBaseURL = 'https://jmfamily.qtestnet.com/api/v3'

param funcAppServicePlanName = 'appplan-ps-dev-funcapp'
param functAppServicePlan = {
  PlanSkuName: 'Y1'
  PlanSkuTier: 'Dynamic'
  PlanCapacity: 1
}

param SahebFuncAppName = 'funcapp-ps-dev-saheb-practice'
param SounakUpdateTestcaseFuncAppName = 'funcapp-ps-dev-sounak-updatetestcase'
param SounakEventListnerFuncAppName = 'funcapp-ps-dev-sounak-eventlistner'

param appserviceplanname = 'appplan-ps-dev-appservice'
param appserviceplan = {
  name: 'B1'
  tier: 'Basic'
  family: 'B'
}

param SounakAppServiceName = 'webapp-ps-dev-sounak-cosmosdb-webapi'
param dotnetVersion = 'DOTNETCORE|10.0'
param logOutUrl = 'https://login.microsoftonline.com/b16b5078-3c36-482e-b98e-b986822e8f7f/oauth2/v2.0/logout'

param cosmosEndpoint =  ''
param eventHubConnectionString = ''
param eventHubName =  ''
