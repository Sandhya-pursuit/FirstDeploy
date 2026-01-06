@description('VNet Name')
param vnetName string

@description('Location')
param location string = resourceGroup().location

@description('Subnet Name')
param subnetName string = 'subnet1'

@description('Subnet Address Prefix')
param subnetPrefix string = '10.0.0.0/24'

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
          addressPrefix: subnetPrefix
        }
      }
    ]
  }
}

output vnetId string = vnet.id
output subnetId string = vnet.properties.subnets[0].id
