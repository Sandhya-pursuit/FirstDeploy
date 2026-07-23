using Azure.Monitor.OpenTelemetry.Exporter;
using Microsoft.Azure.Cosmos;
using Microsoft.Azure.Functions.Worker.Builder;
using Microsoft.Azure.Functions.Worker.OpenTelemetry;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;

var builder = FunctionsApplication.CreateBuilder(args);

builder.ConfigureFunctionsWebApplication();

if (!string.IsNullOrEmpty(Environment.GetEnvironmentVariable("APPLICATIONINSIGHTS_CONNECTION_STRING")))
{
    builder.Services.AddOpenTelemetry()
        .UseFunctionsWorkerDefaults()
        .UseAzureMonitorExporter();
}

//Validate the connections trings for EventHub and CosmosDB
Console.WriteLine( Environment.GetEnvironmentVariable("eventHubName"));

Console.WriteLine( Environment.GetEnvironmentVariable("CosmosEndpoint"));

Console.WriteLine( Environment.GetEnvironmentVariable("eventHubConnectionString"));

builder.Services.AddSingleton(_ =>
{
    var connectionString = Environment.GetEnvironmentVariable("CosmosEndpoint");
    return new CosmosClient(connectionString);
});

builder.Build().Run();