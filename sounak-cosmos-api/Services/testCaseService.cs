using Microsoft.Azure.Cosmos;
using sounak_cosmos_api.Data;
using sounak_cosmos_api.Models;

namespace sounak_cosmos_api.Services
{
    public class testCaseService
    {
        private readonly Container _container;

        public testCaseService(cosmosDBcontext context)
        {
            _container = context.Container;
        }

        // Return all the test cases from the database
        public async Task<List<TestCase>> GetAllAsync()
        {
            var query = _container.GetItemQueryIterator<TestCase>(
                "SELECT * FROM c");

            List<TestCase> testCases = new();

            while (query.HasMoreResults)
            {
                var response = await query.ReadNextAsync();
                testCases.AddRange(response);
            }

            return testCases;
        }

        // Return a single test case by its pid
        public async Task<TestCase?> GetByIdAsync(string testcase_pid)
        {
            var queryDefinition = new QueryDefinition(
                "SELECT * FROM c WHERE c.testcase_pid = @testcase_pid")
                .WithParameter("@testcase_pid", testcase_pid);

            var query = _container.GetItemQueryIterator<TestCase>(queryDefinition);

            while (query.HasMoreResults)
            {
                FeedResponse<TestCase> response = await query.ReadNextAsync();

                return response.FirstOrDefault();
            }

            return null;
        }

        // Return a single test case by it's name
        public async Task<List<TestCase>> GetByNameAsync(string name)
        {
            var queryDefinition = new QueryDefinition(
                "SELECT * FROM c WHERE CONTAINS(c.name, @name)")
                .WithParameter("@name", name);

            var query = _container.GetItemQueryIterator<TestCase>(queryDefinition);

            List<TestCase> testCases = new();

            while (query.HasMoreResults)
            {
                FeedResponse<TestCase> response = await query.ReadNextAsync();
                testCases.AddRange(response);
            }

            return testCases;
        }
    }
}
