using Grpc.Core;
using Microsoft.Azure.Cosmos;

namespace IntegrationTests.Tests
{
    // Adds server related information/abilities to execution context.
    public static class ServerExecutionContextExtensions
    {
        private const string serverAddressKey = "ServerAddress";
        private const string channelKey = "Channel";
        private const string databaseConnectionStringKey = "DatabaseConnectionString";
        private const string databaseClientKey = "DatabaseClient";

        public static ExecutionContext WithServerAddress(this ExecutionContext @this, string serverAddress) =>
            @this.WithDataValue(serverAddressKey, serverAddress);

        public static string GetServerAddress(this ExecutionContext @this) =>
            (string)@this.Data[serverAddressKey];

        public static ExecutionContext WithServerChannel(this ExecutionContext @this, Channel channel) =>
            @this.WithDataValue(channelKey, channel);

        public static Channel GetServerChannel(this ExecutionContext @this) =>
            (Channel)@this.Data[channelKey];

        public static ExecutionContext WithDatabaseConnectionString(this ExecutionContext @this, string databaseConnectionString) =>
            @this.WithDataValue(databaseConnectionStringKey, databaseConnectionString);

        public static string GetDatabaseConnectionString(this ExecutionContext @this) =>
            (string)@this.Data[databaseConnectionStringKey];

        public static ExecutionContext WithDatabaseClient(this ExecutionContext @this, CosmosClient databaseClient) =>
            @this.WithDataValue(databaseClientKey, databaseClient);

        public static CosmosClient GetDatabaseClient(this ExecutionContext @this) =>
            (CosmosClient)@this.Data[databaseClientKey];
    }
}
