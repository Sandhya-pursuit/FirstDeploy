using sounak_cosmos_api.Data;
using sounak_cosmos_api.Services;

var builder = WebApplication.CreateBuilder(args);

/* Registering the cosmos DB connection into the program.cs
 * Why Singleton?
 * It is thread-safe.
 * It manages connection pooling internally.
 * Creating a new instance for every request effects the performance that's why using singleton it created one single connection and reusing it for all the requests.
 */
builder.Services.AddSingleton<cosmosDBcontext>();
// Register the testCaseService 
builder.Services.AddScoped<testCaseService>();
// Add services to the container.
builder.Services.AddControllers();
// To get all the apis
builder.Services.AddEndpointsApiExplorer();
// Put them into the swagger
builder.Services.AddSwaggerGen();



// With CORS
builder.Services.AddCors((options) =>
{
    /*
    .AddPolicy (<Name of this policy> (corsBuilder) =>
    {
        adding required methoods
        .WithOrigins(<urls>) - will allows the urls
            http://localhost:4200 - Default port of Angular
            http://localhost:3000 - Default port of Reach
            http://localhost:8000 - Default port of Vue
        .AllowAnyMethod() - will allows my defined methoods
        .AllowAnyHeader() - will handel any weired header if someone is passing in any case
        .AllowCredentials(); - will be requried to add user authentication.
    )
    */
options.AddPolicy("DevCors", (corsBuilder) =>
    {
        corsBuilder.WithOrigins("http://localhost:4200", "http://localhost:3000", "http://localhost:8000")
            .AllowAnyMethod()
            .AllowAnyHeader()
            .AllowCredentials();
    });
    options.AddPolicy("ProdCors", (corsBuilder) =>
    {
        corsBuilder.WithOrigins("https://myProductionSite.com")
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
