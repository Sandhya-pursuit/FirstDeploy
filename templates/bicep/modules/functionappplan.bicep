@description('Location')
param location string = resourceGroup().location

@description('Functionapp App Plan name')
param funcAppServicePlanName string

@description('Functionapp App Plan properties')
param functAppServicePlan object

resource appServicePlan 'Microsoft.Web/serverfarms@2020-12-01' = {
  name: funcAppServicePlanName
  location: location
  sku: {
    name: functAppServicePlan.PlanSkuName
    tier: functAppServicePlan.PlanSkuTier
    capacity: functAppServicePlan.PlanCapacity
  }
  properties: {
    reserved: false
  }
}

output appServicePlanId string = appServicePlan.id
