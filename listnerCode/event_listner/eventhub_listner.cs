using Azure.Messaging.EventHubs;
using event_listner.Models;
using Microsoft.Azure.Cosmos;
using Microsoft.Azure.Functions.Worker;
using Microsoft.Extensions.Logging;
using System;
using System.Text;
using System.Text.Json;
using System.Text.Json.Serialization;

namespace event_listner;
public class eventhub_listner
{
    private readonly ILogger<eventhub_listner> _logger;
    private readonly CosmosClient _cosmosClient;

    public eventhub_listner(ILogger<eventhub_listner> logger)
    {
        _logger = logger;

        //Cosmos DB Connection string
        string cosmosConnectionString = Environment.GetEnvironmentVariable("secret_cosmosdb_connstring");
        //Create new client of cosmos DB
        _cosmosClient = new CosmosClient(cosmosConnectionString);
    }

    [Function(nameof(eventhub_listner))]
    public async Task Run([EventHubTrigger("secret_eventhub_name", Connection = "secret_eventhub_connstring")] EventData[] events)
    {
        //Getting the container detais of that cosmos DB
        var cosmosContainer = _cosmosClient.GetContainer("db-dummy-qtest", "ct-testcases");

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
                testCase? data = JsonSerializer.Deserialize<testCase>(messageBody);

                //Check if the data is ull or it has actual data
                if( data == null)
                {
                    _logger.LogWarning("Deserialized object is null. Skipping event.");
                    continue;
                }

                Console.WriteLine($"Data Id : {data.Id}, Testcase Id : {data.testcaseId}, Testcase Pid : {data.testcasePid}, Testcase Description : {data.testcaseDescription}");
                //Store the data into cosmos DB
                await cosmosContainer.CreateItemAsync(data, new PartitionKey(data.testcasePid));
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