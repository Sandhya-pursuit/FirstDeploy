using '../main.eventhubnseh.bicep'

param eventHubNamespaceName = 'ehns-ps-autodilab'
param EHNskuTier = 'Standard'
param EHNskuCapacity = 1
param consumerGroupName = 'ConsumerGoup-autodilab'
param eventHubName = 'eh-ps-autodilab'
param location = 'eastus'

param datasenderfunctionappname = 'funcapp-ps-dev-sounak-updatetestcase'
param datareceiverfunctionappname = 'funcapp-ps-dev-sounak-eventlistner'
