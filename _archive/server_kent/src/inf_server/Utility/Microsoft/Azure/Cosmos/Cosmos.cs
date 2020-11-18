using System;
using Microsoft.Azure.Cosmos;

namespace Utility.Microsoft.Azure.Cosmos
{
    public static class Cosmos
    {
        private const string connectionStringEnvironmentVariableName = "COSMOS_CONNECTION_STRING";
        private const string throughputEnvironmentVariableName = "COSMOS_THROUGHPUT";

        public static CosmosClient GetCosmosClient()
        {
            var connectionString = Environment.GetEnvironmentVariable(connectionStringEnvironmentVariableName);

            if (string.IsNullOrEmpty(connectionString))
            {
                throw new InvalidOperationException($"The Cosmos connection string specified via environment variable {connectionStringEnvironmentVariableName} is missing.");
            }

            var cosmosClient = new CosmosClientBuilder(connectionString)
                .UseCustomJsonSerializer(ProtobufJsonSerializer.Instance)
                .AddCustomHandlers(LoggingHandler.Instance)
                .Build();

            return cosmosClient;
        }
    }
}
