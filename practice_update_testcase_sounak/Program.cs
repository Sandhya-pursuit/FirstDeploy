using Microsoft.Azure.Functions.Worker;
using Microsoft.Azure.Functions.Worker.Builder;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Polly;
using Polly.Extensions.Http;

var builder = FunctionsApplication.CreateBuilder(args);

builder.ConfigureFunctionsWebApplication();

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
    .AddHttpClient("qTestClient", client =>
    {
        //set the timeout duration
        client.Timeout = TimeSpan.FromSeconds(30);
    })
    .AddPolicyHandler(retryPolicy)
    .AddPolicyHandler(circuitBreakerPolicy);

builder.Build().Run();
