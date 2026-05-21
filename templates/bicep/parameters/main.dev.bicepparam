using '../main.bicep'

param storageName = 'stacprojctautodilab'
param appServicePlanName = 'appplan-ps-autodilab'

param logAnalyticsName = 'logan-ps-autodilab'
param appInsightsName = 'appins-ps-autodilab'
param keyVaultName = 'kv-ps-autodilab'
param vnetName = 'vnet-ps-autodilab'
param PlanSkuName = 'Y1'
param PlanSkuTier = 'Dynamic'
param PlanCapacity = 1
param myUserObjectId = '77c5b611-eedd-4ba6-ad1f-3fe14fdffea3'
param userSObjectId = '9aa3c688-89a7-49eb-970e-fd0f00ad4015'
param userTObjectId = '5df4258a-3ea6-4029-97af-8059a829dc17'

param funcAppNameEventlistner = 'Funcapp-ps-eventlistner-autodilab'
param qTestBaseURL = 'https://jmfamily.qtestnet.com/api/v3'
param funcAppName = 'funcapp-ps-autodilab'
param cosmosEndpoint =  ''
param eventHubFullyQualifiedNamespace = ''
param eventHubName =  ''
