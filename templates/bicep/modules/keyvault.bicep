param vaultName string
param location string
param functionAppPrincipalId string
param functionAppListenerPrincipalId string
param functionAppSahebPrincipalId string
param SandyaObjectId string
param SounakObjectId string
param TapasObjectId string
param SahebObjectId string






resource keyvault 'Microsoft.KeyVault/vaults@2023-07-01' = {
  name: vaultName
  location: location
  properties: {
    tenantId: subscription().tenantId
    sku: {
      family: 'A'
      name: 'standard'
    }
    accessPolicies: [
      {
        objectId: SandyaObjectId
        tenantId: subscription().tenantId
        permissions: {
          secrets: [
            'Get'
            'List'
            'Set'
            'Delete'
          ]
        }
      }
      {
        objectId: SounakObjectId
        tenantId: subscription().tenantId
        permissions: {
          secrets: [
            'Get'
            'List'
          ]
        }
      }
      {
        objectId: TapasObjectId
        tenantId: subscription().tenantId
        permissions: {
          secrets: [
            'Get'
            'List'
          ]
        }
      }
      {
        objectId: SahebObjectId
        tenantId: subscription().tenantId
        permissions: {
          secrets: [
            'Get'
            'List'
          ]
        }
      }
      {
        objectId: functionAppPrincipalId
        tenantId: subscription().tenantId
        permissions: {
          secrets: [
            'Get'
            'List'
          ]
        }
      }
      {
        objectId: functionAppListenerPrincipalId
        tenantId: subscription().tenantId
        permissions: {
          secrets: [
            'Get'
            'List'
          ]
        }
      }
      {
        objectId: functionAppSahebPrincipalId
        tenantId: subscription().tenantId
        permissions: {
          secrets: [
            'Get'
            'List'
          ]
        }
      }
    ]
    enableSoftDelete: true
    softDeleteRetentionInDays: 7
    enableRbacAuthorization: false
    publicNetworkAccess: 'Enabled'
  }
}







