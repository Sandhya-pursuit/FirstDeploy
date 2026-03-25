param vaultName string
param location string
param functionAppPrincipalId string
param functionAppListenerPrincipalId string
param myUserObjectId string
param userSObjectId string
param userTObjectId string



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
        objectId: myUserObjectId
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
        objectId: userSObjectId
        tenantId: subscription().tenantId
        permissions: {
          secrets: [
            'Get'
            'List'
          ]
        }
      }
      {
        objectId: userTObjectId
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
    ]
    enableSoftDelete: true
    softDeleteRetentionInDays: 7
    enableRbacAuthorization: false
    publicNetworkAccess: 'Enabled'
  }
}

// resource qTestBaseURLSecret 'Microsoft.KeyVault/vaults/secrets@2023-07-01' = {
//   parent: keyvault
//   name: 'qtest-baseurl'
//   properties: {
//     value: qTestBaseURL
//   }
// }

// resource qTestTokenSecret 'Microsoft.KeyVault/vaults/secrets@2023-07-01' = {
//   parent: keyvault
//   name: 'qtest-token'
//   properties: {
//     value: qTestToken
//   }
// }

// output qTestBaseURLSecretUri string = qTestBaseURLSecret.properties.secretUriWithVersion
// output qTestTokenSecretUri string = qTestTokenSecret.properties.secretUriWithVersion
