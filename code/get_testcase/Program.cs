using Azure.Identity;
using Azure.Messaging.EventHubs.Producer;
using Microsoft.Azure.Functions.Worker;
using Microsoft.Azure.Functions.Worker.Builder;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Polly;
using Polly.Extensions.Http;

var builder = FunctionsApplication.CreateBuilder(args);

builder.ConfigureFunctionsWebApplication();

//Load eventhub configuration from the environemnt variables
var eventHubNamespace = Environment.GetEnvironmentVariable("secret_eventhub_namespace");
var eventHubName = Environment.GetEnvironmentVariable("secret_eventhub_name");

// Define the Retry Policy (The Bodyguard's Rules)
// "If we get a network error or a 5xx/408 status code..."
var retryPolicy = HttpPolicyExtensions
    .HandleTransientHttpError()
    .WaitAndRetryAsync(3, retryAttempt => TimeSpan.FromSeconds(Math.Pow(2, retryAttempt)));
// ^ Exponential Backoff: Wait 2s, then 4s, then 8s.

// 2. Define the Circuit Breaker Policy 👇 NEW
var circuitBreakerPolicy = HttpPolicyExtensions
    .HandleTransientHttpError()
    .CircuitBreakerAsync(5, TimeSpan.FromSeconds(30));
// ^ "Stop! If 5 failures happen, pause for 30 seconds."

builder.Services
    .AddMemoryCache()
    .AddApplicationInsightsTelemetryWorkerService()
    .ConfigureFunctionsApplicationInsights()
    /* 
    Inject the EventHubProducerClient as a Singleton so your functions can use it!
    NOTE: This uses connection string to authenticate with the eventhub.
    */
    //.AddSingleton(new EventHubProducerClient(eventHubConnectionString, eventHubName))

    // This will use managed identity as an authentication process wiht the event hub
    .AddSingleton(sp =>
    {
        var credential = new DefaultAzureCredential();

        return new EventHubProducerClient(
            eventHubNamespace,
            eventHubName,
            credential);
    })

    .AddHttpClient("qTestGetTestcaseClient", client =>
    {
        //set the timeout duration
        client.Timeout = TimeSpan.FromSeconds(30);
    })
    .AddPolicyHandler(retryPolicy)
    .AddPolicyHandler(circuitBreakerPolicy);

builder.Build().Run();
