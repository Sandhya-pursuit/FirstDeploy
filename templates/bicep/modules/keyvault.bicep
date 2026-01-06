@description('Key Vault Name')
param vaultName string

@description('Location')
param location string = resourceGroup().location

@description('Array of initial access policies')
param accessPolicies array = []

resource keyVault 'Microsoft.KeyVault/vaults@2023-07-01' = {
  name: vaultName
  location: location
  properties: {
    sku: { 
          name: 'standard'
          family: 'A'
         }
    tenantId: subscription().tenantId
    accessPolicies: [for p in accessPolicies: {
      objectId: p.objectId
      permissions: p.permissions
      tenantId: subscription().tenantId
    }]
    enabledForDeployment: true
    enabledForDiskEncryption: false
    enabledForTemplateDeployment: false
    enableSoftDelete: false
    enableRbacAuthorization: false
    publicNetworkAccess: 'Enabled'
  }
}

output keyVaultId string = keyVault.id
