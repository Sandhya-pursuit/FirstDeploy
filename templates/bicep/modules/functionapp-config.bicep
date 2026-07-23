param funcappname string
param serverfarmid string
param appSettings array

resource funcconfig 'Microsoft.Web/sites/config@2023-01-01' = {
  name: '${funcappname}/web'
  properties: {
    serverFarmId: serverfarmid
    netFrameworkVersion: 'v10.0'
    use32BitWorkerProcess: false
    appSettings: appSettings

    cors: {
      allowedOrigins: [
        'https://portal.azure.com'
      ]
    }
  }
}
