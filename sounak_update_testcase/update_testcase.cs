using Azure.Messaging.EventHubs;
using Azure.Messaging.EventHubs.Producer;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Azure.Functions.Worker;
using Microsoft.Extensions.Logging;
using Practice_update_testcase.Mapper;
using Practice_update_testcase.Models.Internal_Models;
using System.Net;
using System.Net.Http.Headers;
using System.Net.Http.Json;
using System.Text;
using System.Text.Json;
using System.Text.Json.Nodes;

namespace Practice_update_testcase;

public class update_testcase
{
    private readonly ILogger<update_testcase> _logger;
    private readonly IHttpClientFactory _httpClientFactory;
    private readonly EventHubProducerClient _eventHubProducerClient;

    private const string UpdatedMessage = "Updated By Sounak Sen using c# function app";

    // Specific fields that qTest prevents you from updating via PUT
    private readonly string[] _readOnlyFields = {
        "links", "id", "order", "created_date", "last_modified_date",
        "web_url", "parent_id", "test_case_version_id", "version",
        "creator_id", "agent_ids"
    };

    public update_testcase(ILogger<update_testcase> logger, IHttpClientFactory httpClientFactory, EventHubProducerClient eventHubProducerClient)
    {
        _logger = logger;
        _httpClientFactory = httpClientFactory;
        _eventHubProducerClient = eventHubProducerClient;
    }

    [Function("update_testcase")]
    public async Task<IActionResult> RunAsync([HttpTrigger(AuthorizationLevel.Anonymous, "post", Route = "project/{projectId}/test-cases/{testcasePid}")] HttpRequest req,
        int projectId,
        string testcasePid,
        CancellationToken cancellationToken)
    {
        _logger.LogInformation($"Starting update for Test Case PID: {testcasePid} in Project: {projectId}");

        // Configuration Validation
        var qtestBaseUrl = Environment.GetEnvironmentVariable("qTestBaseURL");
        var qtestToken = Environment.GetEnvironmentVariable("qTestToken");

        if (string.IsNullOrEmpty(qtestBaseUrl) || string.IsNullOrEmpty(qtestToken))
        {
            _logger.LogError("Missing qTest configuration (URL or Token).");
            return new ObjectResult("Server configuration error: Missing qTest credentials") { StatusCode = 401 };
        }

        try
        {
            // Setup Client
            var client = _httpClientFactory.CreateClient("qTestClient");
            client.BaseAddress = new Uri(qtestBaseUrl.TrimEnd('/'));
            client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", qtestToken);
            client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));

            // Search for Test Case ID
            int testCaseId = await GetTestCaseIdAsync(client, projectId, testcasePid, cancellationToken);
            if (testCaseId == 0)
            {
                return new NotFoundObjectResult($"Test Case with PID '{testcasePid}' not found.");
            }

            // Get Test Case Details
            var testCaseJson = await GetTestCaseDetailsAsync(client, projectId, testCaseId, cancellationToken);
            if (testCaseJson == null)
            {
                return new NotFoundObjectResult($"Failed to retrieve details for Test Case ID {testCaseId}");
            }

            // Modify Payload (Business Logic)
            PreparePayloadForUpdate(testCaseJson); 

            // Update Test Case
            var result = await UpdateTestCaseAsync(client, projectId, testCaseId, testCaseJson, cancellationToken);

            // Deserialize response into strongly typed model
            var internal_filteredPayload = result?.Deserialize<testcase_internal>();

            // Log the internal_filteredPayload before json serializer
            _logger.LogInformation($"Before internal_filteredPayload json serializer: {internal_filteredPayload}");

            // Check if the deserialize response is null or not
            if (internal_filteredPayload == null)
            {
                _logger.LogError("Failed to deserialize payload.");
                return new BadRequestObjectResult("Payload deserialization failed.");
            }

            // Map the internal model with the response model
            var response = testcase_mapper.Map(internal_filteredPayload);

            // Log the response before json serializer
            _logger.LogInformation($"Before response json serializer: {response}");

            // Convert response model it into JSONStringfy
            var jsonStringifyResult = JsonSerializer.Serialize(response);

            // After json serializer
            _logger.LogInformation($"After json serializer of response: {jsonStringifyResult}");

            // Creating event 
            var testcaseEvent = new EventData(jsonStringifyResult);

            // Creating event batch
            using EventDataBatch eventBatch = await _eventHubProducerClient.CreateBatchAsync(cancellationToken);

            // Adding data into the batch
            if (!eventBatch.TryAdd(testcaseEvent))
            {
                _logger.LogError("Failed to add event to the Event Hub batch because it exceeds the maximum allowed size.");

                return new StatusCodeResult(StatusCodes.Status500InternalServerError);
            }

            // Data sending to the event hub started
            _logger.LogInformation("Sending event to Event Hub...");

            // Sending the events batch into the event hub
            await _eventHubProducerClient.SendAsync(eventBatch, cancellationToken);

            // Successfully data sent to the event hub
            _logger.LogInformation("Event successfully sent to Event Hub.");

            // Return the json object insteed of the string
            return new OkObjectResult(response);
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



    // --- Helper Methods to separate concerns ---

    // Get testcase id helper methood
    private async Task<int> GetTestCaseIdAsync(HttpClient client, int projectId, string pid, CancellationToken cancellationToken)
    {
        string searchUrl = $"/api/v3/projects/{projectId}/search";

        var searchBody = new
        {
            object_type = "test-cases",
            fields = new[] { "id" },
            query = $"'Id' = '{pid}'"
        };

        var response = await client.PostAsJsonAsync(searchUrl, searchBody, cancellationToken);
        response.EnsureSuccessStatusCode();

        var json = await response.Content.ReadFromJsonAsync<JsonNode>();
        var items = json?["items"]?.AsArray();

        if (items != null && items.Count > 0)
        {
            return items[0]?["id"]?.GetValue<int>() ?? 0;
        }

        _logger.LogWarning($"Search returned no items for PID {pid}");
        return 0;
    }

    // Convertion to JSON helper methood
    private async Task<JsonNode?> GetTestCaseDetailsAsync(HttpClient client, int projectId, int testCaseId, CancellationToken cancellationToken)
    {
        string url = $"/api/v3/projects/{projectId}/test-cases/{testCaseId}";
        var response = await client.GetAsync(url, cancellationToken);

        if (!response.IsSuccessStatusCode)
        {
            _logger.LogError($"Get Details Failed: {response.StatusCode}");
            return null;
        }

        return await response.Content.ReadFromJsonAsync<JsonNode>();
    }

    // JSON fi & remove unnecessory objects from the JSON response helper methood
    private void PreparePayloadForUpdate(JsonNode json)
    {
        var jsonObj = json.AsObject();

        // Remove Read-Only fields
        foreach (var field in _readOnlyFields)
        {
            jsonObj.Remove(field);
        }

        // Update Properties Array
        var properties = jsonObj["properties"]?.AsArray();

        if(properties == null)
        {
            _logger.LogWarning("Properties array is null.");
            return;
        }

        // Remove properties with empty values
        // We use ToList() to materialize the query so we can modify the original collection safely
        var emptyPropertiess = properties.Where(p => string.IsNullOrEmpty(p?["field_value"]?.ToString())).ToList();

        // Update Standard Description
        jsonObj["description"] = UpdatedMessage;


        if (properties != null)
        {
            // Update custom field description
            var descProp = properties.FirstOrDefault(p => p?["field_name"]?.ToString() == "Description");
            if (descProp != null)
            {
                descProp["field_value"] = UpdatedMessage;
            }

            foreach (var property in emptyPropertiess)
            {
                properties.Remove(property);
            }
        }
    }

    // Update testcase helper methood
    private async Task<JsonNode?> UpdateTestCaseAsync(HttpClient client, int projectId, int testCaseId, JsonNode payload, CancellationToken cancellationToken)
    {
        string url = $"/api/v3/projects/{projectId}/test-cases/{testCaseId}";

        var content = new StringContent(payload.ToJsonString(), Encoding.UTF8, "application/json");
        var response = await client.PutAsync(url, content, cancellationToken);

        response.EnsureSuccessStatusCode();

        return await response.Content.ReadFromJsonAsync<JsonNode>();
    }
}

