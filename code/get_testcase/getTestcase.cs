using Azure.Messaging.EventHubs;
using Azure.Messaging.EventHubs.Producer;
using get_testcase.Models;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Azure.Functions.Worker;
using Microsoft.Extensions.Logging;
using System.Net;
using System.Net.Http.Headers;
using System.Net.Http.Json;
using System.Reflection;
using System.Text.Json;
using System.Text.Json.Nodes;

namespace get_testcase;

public class getTestcase
{
    private readonly ILogger<getTestcase> _logger;
    private readonly IHttpClientFactory _httpClientFactory;
    private readonly EventHubProducerClient _eventHubProducerClient;

    public getTestcase(ILogger<getTestcase> logger, IHttpClientFactory httpClientFactory, EventHubProducerClient eventHubProducerClient)
    {
        _logger = logger;
        _httpClientFactory = httpClientFactory;
        _eventHubProducerClient = eventHubProducerClient;
    }

    [Function("getTestcase")]
    public async Task<IActionResult> Run(
        [HttpTrigger(AuthorizationLevel.Anonymous, "get", Route = "project/{projectId}/test-cases/{testcasePid}")] HttpRequest req, 
        int projectId,
        string testcasePid,
        CancellationToken cancellationToken)
    {
        _logger.LogInformation($"Starting update for Test Case PID: {testcasePid} in Project: {projectId}");

        // configuration Validation
        var qtestBaseUrl = Environment.GetEnvironmentVariable("qTestBaseURL");
        var qtestToken = Environment.GetEnvironmentVariable("qTestToken");

        if (string.IsNullOrEmpty(qtestBaseUrl) || string.IsNullOrEmpty(qtestToken))
        {
            _logger.LogError($"Missing qTest configuration. URL = {qtestBaseUrl} and Token = {qtestToken}).");
            return new ObjectResult("Server configuration error: Missing qTest credentials") { StatusCode = 401 };
        }

        try
        {
            // setup Client
            var client = _httpClientFactory.CreateClient("qTestGetTestcaseClient");
            client.BaseAddress = new Uri(qtestBaseUrl.TrimEnd('/'));
            client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", qtestToken);
            client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));

            // search for Test Case details
            List<TestCase> testCase = await searchTestCaseDetailsAsync(client, projectId, testcasePid, cancellationToken);

            _logger.LogInformation(testCase[0].parent_id.ToString());

            var parentId = testCase[0].parent_id.ToString();

            // get module name
            string? moduleName = await searchModuleNameAsync(client,projectId, parentId, cancellationToken);
            _logger.LogInformation(moduleName);

            // assign parent_name
            testCase[0].parent_name = moduleName;
            _logger.LogInformation($"parent_name : {testCase[0].parent_name}");

            // convert it into JSONStringfy
            var jsonStringifyResult = JsonSerializer.Serialize(testCase);

            //lets create event
            var getTestCaseResponseEvent = new EventData(jsonStringifyResult);

            //lets create now event batch
            var eventBatch = await _eventHubProducerClient.CreateBatchAsync();

            //add event in this event batch
            eventBatch.TryAdd(getTestCaseResponseEvent);

            //lets send event batch to eventhub
            await _eventHubProducerClient.SendAsync(eventBatch);
            _logger.LogInformation("Update testc ase response is successfully sent to eventhub.");

            return new OkObjectResult(testCase);
        }
        catch (HttpRequestException httpEx)
        {
            _logger.LogError($"HTTP Request error: {httpEx.Message}");
            return new StatusCodeResult((int)(httpEx.StatusCode ?? HttpStatusCode.InternalServerError));
        }
        catch (Exception ex)
        {
            _logger.LogError($"Unexpected error: {ex}");
            return new StatusCodeResult(500);
        }
    }




    // --- Helper Methods ---

    //search testcase
    private async Task<List<TestCase>> searchTestCaseDetailsAsync(HttpClient client, int projectId, string pid, CancellationToken cancellationToken)
    {
        // qtest search api url
        string searchUrl = $"/api/v3/projects/{projectId}/search";

        // request body
        var searchBody = new
        {
            object_type = "test-cases",
            fields = new[] { "*" },
            query = $"'Id' = '{pid}'"
        };

        // capture api response
        var response = await client.PostAsJsonAsync(searchUrl, searchBody, cancellationToken);
        response.EnsureSuccessStatusCode();

        // read them as json object
        var json = await response.Content.ReadFromJsonAsync<JsonNode>();

        // capture only items from that json object
        var items = json?["items"];

        if (items != null)
        {
            // convert JSON into Models
            var testCases = items
                .Deserialize<List<TestCase>>();

            return testCases ?? new List<TestCase>();
        }

        _logger.LogWarning("No testcase found.");
        return new List<TestCase>();
    }


    // search module
    private async Task<string?> searchModuleNameAsync(HttpClient client, int projectId, string moduleId, CancellationToken cancellationToken)
    {
        // qtest get model details api url
        string searchUrl = $"/api/v3/projects/{projectId}/modules/{moduleId}";

        // capture api response
        var response = await client.GetAsync(searchUrl, cancellationToken);
        response.EnsureSuccessStatusCode();

        // read them as json object
        var json = await response.Content.ReadFromJsonAsync<JsonNode>();

        //_logger.LogInformation(json.ToString());

        if (json == null)
        {
            _logger.LogWarning( "Module response JSON was null.");

            return null;
        }

        // capture only pid + name from that json object
        string moduleName = $"{json["pid"]} {json["name"]}";

        return moduleName;
    }
}