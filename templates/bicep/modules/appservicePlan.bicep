param location string 
param appserviceplanname string
// param asp_sku object

param asp_sku object = {
  name: 'B1'
  tier: 'Basic'
  family: 'B'
}


resource appServicePlan 'Microsoft.Web/serverfarms@2025-03-01' = {
  name: appserviceplanname
  location: location
  kind: 'app'
  sku: asp_sku
  properties: {
    reserved: true
  }
}

output serverfarmID string = appServicePlan.id
