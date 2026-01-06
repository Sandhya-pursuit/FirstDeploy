@description('App Service Plan name')
param appServicePlanName string

@description('Location')
param location string = resourceGroup().location

resource appServicePlan 'Microsoft.Web/serverfarms@2020-12-01' = {
  name: appServicePlanName
  location: location
  sku: {
    name: 'Y1'       // Consumption plan
    tier: 'Dynamic'
    capacity: 1
  }
  properties: {
    reserved: false
  }
}

output appServicePlanId string = appServicePlan.id
