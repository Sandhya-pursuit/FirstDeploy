using './main.bicep'

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


