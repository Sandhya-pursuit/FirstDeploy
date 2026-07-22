using Azure.Messaging.EventHubs;
using Microsoft.Azure.Cosmos;
using Microsoft.Azure.Functions.Worker;
using Microsoft.Extensions.Logging;
using sounak_eventhub_listner.Models;
using System;
using System.Text;
using System.Text.Json;
using static Azure.Core.HttpHeader;

namespace sounak_eventhub_listner;
public class sounak_eventhub_listner
{
    private readonly ILogger<sounak_eventhub_listner> _logger;
    private readonly CosmosClient _cosmosClient;

    public sounak_eventhub_listner(ILogger<sounak_eventhub_listner> logger, CosmosClient cosmosClient)
    {
        _logger = logger;
        _cosmosClient = cosmosClient;

        // Cosmos DB Connection string
        var cosmosConnectionString = Environment.GetEnvironmentVariable("CosmosEndpoint");
        //Create new client of cosmos DB
        _cosmosClient = new CosmosClient(cosmosConnectionString);
    }

    [Function(nameof(sounak_eventhub_listner))]
    public async Task Run([EventHubTrigger("eventHubName", Connection = "eventHubConnectionString")] EventData[] events)
    {
        //Getting the container detais of that cosmos DB
        var cosmosContainer = _cosmosClient.GetContainer("db-qTest", "ct-testcase");

        //To avoide case sensetive issues
        var options = new JsonSerializerOptions
        {
            PropertyNameCaseInsensitive = true
        };

        foreach (EventData @event in events)
        {
            //Get the raw JSON string
            string messageBody = Encoding.UTF8.GetString(@event.Body.ToArray());
            _logger.LogInformation("Raw JSON string: {body}", messageBody);

            try
            {
                //Convert (Deserialize) the string into your C# object
                Testcase? data = JsonSerializer.Deserialize<Testcase>(messageBody);

                //Check if the data is ull or it has actual data
                if (data == null)
                {
                    _logger.LogWarning("Deserialized object is null. Skipping event.");
                    continue;
                }

                Console.WriteLine($"Data Id : {data.qtest_id}, Testcase Id : {data.qtest_id}, Testcase Pid : {data.qtest_pid}, Testcase Description : {data.description}");

                //Store the data into cosmos DB
                await cosmosContainer.CreateItemAsync(data, new PartitionKey(data.qtest_id));
            }

            //To catch JSON related issues
            catch (JsonException ex)
            {
                //If someone sends bad JSON that doesn't match your class, it will log an error instead of crashing
                _logger.LogError("Failed to parse JSON. Error: {errorMessage}", ex.Message);
            }

            //To catch cosmosDB related issues
            catch (CosmosException ex)
            {
                _logger.LogError("Cosmos DB error: {errorMessage}", ex.Message);
            }
        }
    }
}