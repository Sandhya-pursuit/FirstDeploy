using Azure.Messaging.EventHubs;
using Microsoft.Azure.Cosmos;
using Microsoft.Azure.Functions.Worker;
using Microsoft.Extensions.Logging;
using sounak_eventhub_listner.Models;
using System.Text;
using System.Text.Json;

namespace sounak_eventhub_listner;

public class sounak_eventhub_listner
{
    private readonly ILogger<sounak_eventhub_listner> _logger;
    private readonly CosmosClient _cosmosClient;

    public sounak_eventhub_listner( ILogger<sounak_eventhub_listner> logger, CosmosClient cosmosClient)
    {
        _logger = logger;
        _cosmosClient = cosmosClient;
    }

    [Function(nameof(sounak_eventhub_listner))]
    public async Task Run([ EventHubTrigger( "%eventHubName%", Connection = "eventHubConnectionString", ConsumerGroup = "consumergoup-autodilab")] EventData[] events, CancellationToken cancellationToken)
    {
        _logger.LogInformation("Event Hub Trigger Fired. Received {count} events.", events.Length);

        var container = _cosmosClient.GetContainer("db-qTest", "ct-testcase");

        var options = new JsonSerializerOptions
        {
            PropertyNameCaseInsensitive = true
        };

        foreach (var eventData in events)
        {
            try
            {
                string messageBody = Encoding.UTF8.GetString(eventData.EventBody.ToArray());

                _logger.LogInformation("Received Event: {body}", messageBody);

                Testcase? data = JsonSerializer.Deserialize<Testcase>(messageBody, options);

                if (data == null)
                {
                    _logger.LogWarning("Deserialized object is null.");
                    continue;
                }

                // Create a Cosmos document without changing your model
                var document = new
                {
                    id = Guid.NewGuid().ToString(),   // Cosmos requires an id
                    order = data.order,
                    qtest_id = data.qtest_id.ToString(),
                    qtest_pid = data.qtest_pid,
                    name = data.name,
                    description = data.description,
                    precondition = data.precondition,
                    links = data.links,
                    createddate = data.createddate,
                    lastmodifieddate = data.lastmodifieddate,
                    properties = data.properties,
                    weburl = data.weburl,
                    parentid = data.parentid,
                    testcaseversionid = data.testcaseversionid,
                    version = data.version,
                    aigenerated = data.aigenerated,
                    aigeneratedsource = data.aigeneratedsource,
                    creatorid = data.creatorid,
                    agentids = data.agentids,
                    teststeps = data.teststeps
                };
                
                // Generated document converted into the json string and logged the id and qtest_id for debugging purposes
                _logger.LogInformation( "Cosmos Insert - id: {id}, qtest_id: {qtest_id}", document.id, document.qtest_id);

                await container.CreateItemAsync( document, new PartitionKey(data.qtest_id.ToString()), cancellationToken: cancellationToken);

                _logger.LogInformation( "Document inserted successfully.");
            }
            catch (JsonException ex)
            {
                _logger.LogError(ex, "JSON parsing failed.");
            }
            catch (CosmosException ex)
            {
                _logger.LogError(
                    ex,
                    "Cosmos DB Error. StatusCode={StatusCode}, Message={Message}",
                    ex.StatusCode,
                    ex.Message);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Unexpected error occurred.");
            }
        }
       }
}