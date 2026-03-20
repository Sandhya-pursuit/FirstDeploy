using '../main.bicep'

param storageName = 'stacprojctautodilab'
param appServicePlanName = 'appplan-ps-autodilab'
param funcAppName = 'funcapp-ps-autodilab'
param logAnalyticsName = 'logan-ps-autodilab'
param appInsightsName = 'appins-ps-autodilab'
param keyVaultName = 'kv-ps-autodilab'
param vnetName = 'vnet-ps-autodilab'
param eventHubNamespaceName = 'ehns-ps-autodilab'
param sharedAccessPolicyName = 'sas'
param EHNskuTier = 'Standard'
param EHNskuCapacity = 1
param PlanSkuName = 'Y1'
param PlanSkuTier = 'Dynamic'
param PlanCapacity = 1
param eventHubName = 'eh-ps-autodilab'


param consumerGroupName = 'ConsumerGoup-autodilab'

param funcAppNameEventlistner = 'Funcapp-ps-eventlistner-autodilab'

param functionAppAdditionalSettings = [
  {
    name: 'qTestBaseURL'
    value: 'https://jmfamily.qtestnet.com/api/v3'
  }
  {
    name: 'qTestToken'
    value: 'df5cbfc9-bfa3-4852-a238-5287cad1c9c8'
  }
]


param cosmosDbAccountName = 'cosmosdb-ps-autodilab'
param myUserObjectId = '77c5b611-eedd-4ba6-ad1f-3fe14fdffea3'
