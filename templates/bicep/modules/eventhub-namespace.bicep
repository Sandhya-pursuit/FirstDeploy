param location string
param eventHubNamespaceName string
param eventhubname string
param EHNskuTier string
param EHNskuCapacity int
param consumerGroupName string
param functionAppPrincipalId string
param functionAppListenerPrincipalId string

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

resource consumerGroup 'Microsoft.EventHub/namespaces/eventhubs/consumergroups@2023-01-01-preview' = {
  parent: eventHub
  name: consumerGroupName
  properties: {}
}

resource eventHubRoleMain 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(eventHubNamespace.id, functionAppPrincipalId, 'eventhub-role-main')
  scope: eventHubNamespace
  properties: {
    roleDefinitionId: subscriptionResourceId(
      'Microsoft.Authorization/roleDefinitions',
      '2b629674-e913-4c01-ae53-ef4638d8f975'
    )
    principalId: functionAppPrincipalId
  }
}

resource eventHubRoleListener 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(eventHubNamespace.id, functionAppListenerPrincipalId, 'eventhub-role-listener')
  scope: eventHubNamespace
  properties: {
    roleDefinitionId: subscriptionResourceId(
      'Microsoft.Authorization/roleDefinitions',
      '2b629674-e913-4c01-ae53-ef4638d8f975'
    )
    principalId: functionAppListenerPrincipalId
  }
}

output eventHubConnectionString string = '${eventHubNamespace.name}.servicebus.windows.net'
output eventHubName string = eventHub.name
output consumerGroupName string = consumerGroup.name
