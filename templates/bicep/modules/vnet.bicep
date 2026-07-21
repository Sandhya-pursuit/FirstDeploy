@description('Location')
param location string = resourceGroup().location

@description('VNet Name')
param vnetName string

@description('Subnet Name')
param subnetName string

resource vnet 'Microsoft.Network/virtualNetworks@2019-11-01' = {
  name: vnetName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: ['10.0.0.0/16']
    }
    subnets: [
      {
        name: subnetName
        properties: {
          addressPrefix: '10.0.0.0/24'

          // Service Endpoints
          serviceEndpoints: [
            {
              service: 'Microsoft.KeyVault'
            }
            {
              service: 'Microsoft.AzureCosmosDB'
            }
            {
              service: 'Microsoft.EventHub'
            }
            {
              service: 'Microsoft.Storage'
            }
            {
              service: 'Microsoft.Web'
            }
          ]

          // Subnet Delegation
          delegations: [
            {
              name: 'webappDelegation'
              properties: {
                serviceName: 'Microsoft.Web/serverFarms'
              }
            }
          ]
        }
      }
    ]
  }
}

output vnetId string = vnet.id
output subnetId string = vnet.properties.subnets[0].id
