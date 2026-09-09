param location string
param webAppName string
param asp_serverFarmID string
param dotnetVersion string
param vnetSubnetID string
param appSettings array


resource appService_webApp 'Microsoft.Web/sites@2024-04-01' = {
  name: webAppName
  location: location
  kind: 'app,linux'
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    clientAffinityEnabled: true
    clientCertEnabled: false
    enabled: true 
    httpsOnly: true
    reserved: true
    scmSiteAlsoStopped: false
    serverFarmId: asp_serverFarmID
    virtualNetworkSubnetId: vnetSubnetID
    vnetContentShareEnabled: true
    publicNetworkAccess: 'Enabled'
    hostNameSslStates: [
      {
        name: '${webAppName}.azurewebsites.net'
        sslState: 'Disabled'
        hostType: 'Standard'
      }
      {
        name: '${webAppName}.scm.azurewebsites.net'
        sslState: 'Disabled'
        hostType: 'Repository'
      }
    ]
    siteConfig: {
      linuxFxVersion: dotnetVersion
      loadBalancing: 'LeastRequests'
      alwaysOn: true 
      minTlsVersion: '1.2'
      ftpsState: 'FtpsOnly'
      vnetRouteAllEnabled: true
      healthCheckPath: '/health'
      ipSecurityRestrictionsDefaultAction: 'Deny'
      ipSecurityRestrictions: []
      scmIpSecurityRestrictionsDefaultAction: 'Deny'
      scmIpSecurityRestrictionsUseMain: true
      scmIpSecurityRestrictions: []
      cors: {
        allowedOrigins: [
          'https://portal.azure.com'
        ]
        supportCredentials: false
      }
      appSettings: appSettings
    }
    
  }

}

output webAppUrl1 string = appService_webApp.properties.defaultHostName
output appServiceIdentity string = appService_webApp.identity.principalId

output webAppUrl string = 'https://${webAppName}.azurewebsites.net'
