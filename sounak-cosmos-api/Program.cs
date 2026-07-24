using Azure.Identity;
using Microsoft.Azure.Cosmos;
using sounak_cosmos_api.Data;
using sounak_cosmos_api.Services;

var builder = WebApplication.CreateBuilder(args);

/*
 * Register CosmosClient using Managed Identity.
 * CosmosClient is thread-safe and should be registered as a Singleton.
 */
builder.Services.AddSingleton<CosmosClient>(_ =>
    new CosmosClient(
        builder.Configuration["cosmosEndpoint"]!,
        new DefaultAzureCredential()));

/*
 * Registering the Cosmos DB context.
 * It receives the CosmosClient through Dependency Injection.
 */
builder.Services.AddSingleton<cosmosDBcontext>();

// Register the testCaseService
builder.Services.AddScoped<testCaseService>();

// Add services to the container.
builder.Services.AddControllers();

// To get all the APIs
builder.Services.AddEndpointsApiExplorer();

// Add Swagger
builder.Services.AddSwaggerGen();

// Configure CORS
builder.Services.AddCors(options =>
{
    options.AddPolicy("DevCors", corsBuilder =>
    {
        corsBuilder
            .WithOrigins(
                "http://localhost:4200",
                "http://localhost:3000",
                "http://localhost:8000")
            .AllowAnyMethod()
            .AllowAnyHeader()
            .AllowCredentials();
    });

    options.AddPolicy("ProdCors", corsBuilder =>
    {
        corsBuilder
            .WithOrigins("https://myProductionSite.com")
            .AllowAnyMethod()
            .AllowAnyHeader()
            .AllowCredentials();
    });
});

var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseCors("DevCors");

    app.UseSwagger();
    app.UseSwaggerUI();
}
else
{
    app.UseCors("ProdCors");

    app.UseHttpsRedirection();
}

app.MapControllers();

app.Run();