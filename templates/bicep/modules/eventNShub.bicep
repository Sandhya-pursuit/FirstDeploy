param location string
param eventHubNamespaceName string
param eventhubname string
param sharedAccessPolicyName string
param EHNskuTier string 
param EHNskuCapacity int 

resource eventHubNamespace 'Microsoft.EventHub/namespaces@2023-01-01-preview' = {
  name: eventHubNamespaceName
  location: location
  sku: {
    name: EHNskuTier
    capacity: EHNskuCapacity
  }
}

resource eventHub 'Microsoft.EventHub/namespaces/eventhubs@2023-01-01-preview' = {
  parent: eventHubNamespace
  name: eventhubname
  properties: {
    messageRetentionInDays: 1
    partitionCount: 1
  }
}

resource sharedAccessPolicy 'Microsoft.EventHub/namespaces/eventhubs/authorizationRules@2023-01-01-preview' = {
  parent: eventHub
  name: sharedAccessPolicyName
  properties: {
    rights: [
      'Listen'
      'Send'
      'Manage'
    ]
  }
}

var ehconnectionstring = sharedAccessPolicy.listKeys().primaryConnectionString

output eventHubConnectionString string = ehconnectionstring
output eventHubName string = eventhubname
