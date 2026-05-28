@description('App Service Plan name')
param appServicePlanName string

@description('Location')
param location string = resourceGroup().location
param PlanSkuName string  // Consumption plan SKU
param PlanSkuTier string  // Consumption plan tier
param PlanCapacity int    // Consumption plan capacity

resource appServicePlan 'Microsoft.Web/serverfarms@2020-12-01' = {
  name: appServicePlanName
  location: location
  sku: {
    name: PlanSkuName       // Consumption plan
    tier: PlanSkuTier
    capacity: PlanCapacity
  }
  properties: {
    reserved: false
  }
}

output appServicePlanId string = appServicePlan.id
