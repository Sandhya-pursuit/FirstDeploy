param location string
param appserviceplanname string
param appserviceplan object

resource appServicePlan 'Microsoft.Web/serverfarms@2025-03-01' = {
  name: appserviceplanname
  location: location
  kind: 'app'
  sku: appserviceplan
  properties: {
    reserved: true
  }
}

output serverfarmID string = appServicePlan.id
