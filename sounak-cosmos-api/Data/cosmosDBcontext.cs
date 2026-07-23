using Microsoft.Azure.Cosmos;
using Microsoft.Azure.Cosmos.Core;
using System.Configuration;

namespace sounak_cosmos_api.Data
{
    public class cosmosDBcontext
    {
        public CosmosClient Client { get; }
        public Database Database { get; }
        public Container Container { get; }

        /*IConfiguration reads configuration from:
         * appsettings.json
         * appsettings.Development.json
         * Environment Variables
         * Azure App Configuration
         * Key Vault
         */
        public cosmosDBcontext(IConfiguration configuration)
        {
            // Get the cosmos DB configuration settings from appsettings.json
            var endpoint = configuration["cosmosEndpoint"];
            var key = configuration["cosmosKey"];
            var databaseName = configuration["cosmosDatabaseName"];
            var containerName = configuration["cosmosContainerName"];

            // Create a new client for the cosmos DB account
            Client = new CosmosClient(endpoint, key);

            // Fetch the DB reference
            Database = Client.GetDatabase(databaseName);

            // Fetch the container reference
            Container = Database.GetContainer(containerName);
        }
    }
}
