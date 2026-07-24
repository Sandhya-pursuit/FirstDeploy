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

// Retry Policy
var retryPolicy = HttpPolicyExtensions
    .HandleTransientHttpError()
    .WaitAndRetryAsync(
        3,
        retryAttempt => TimeSpan.FromSeconds(Math.Pow(2, retryAttempt)));

// Circuit Breaker Policy
var circuitBreakerPolicy = HttpPolicyExtensions
    .HandleTransientHttpError()
    .CircuitBreakerAsync(5, TimeSpan.FromSeconds(30));

builder.Services
    .AddMemoryCache()
    .AddHttpClient("qTestClient", client =>
    {
        client.Timeout = TimeSpan.FromSeconds(30);
    })
    .AddPolicyHandler(retryPolicy)
    .AddPolicyHandler(circuitBreakerPolicy);

// Register Event Hub Producer using Managed Identity
builder.Services.AddSingleton<EventHubProducerClient>(_ =>
    new EventHubProducerClient(
        builder.Configuration["eventHubNamespace"]!,
        builder.Configuration["eventHubName"]!,
        new DefaultAzureCredential()));

builder.Build().Run();