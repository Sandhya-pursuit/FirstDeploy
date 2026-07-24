using Microsoft.Azure.Cosmos;

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
        public cosmosDBcontext( CosmosClient cosmosClient, IConfiguration configuration)
        {
            // Get the cosmos DB configuration settings from appsettings.json / launchSettings.json / environment variables
            var databaseName = configuration["cosmosDatabaseName"];
            var containerName = configuration["cosmosContainerName"];

            // Create a new client for the cosmos DB account
            Client = cosmosClient;

            // Fetch the DB reference
            Database = Client.GetDatabase(databaseName);

            // Fetch the container reference
            Container = Database.GetContainer(containerName);
        }
    }
}
