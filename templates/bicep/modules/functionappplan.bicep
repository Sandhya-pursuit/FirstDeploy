param location string = resourceGroup().location
param funcAppServicePlanName string
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
