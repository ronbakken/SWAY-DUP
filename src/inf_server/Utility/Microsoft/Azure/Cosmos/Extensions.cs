using System;
using System.IO;
using System.Threading;
using System.Threading.Tasks;
using Genesis.Ensure;

namespace Microsoft.Azure.Cosmos
{
    public static class Extensions
    {
        private const string throughputEnvironmentVariableName = "COSMOS_THROUGHPUT";

        // Creates a default container in the database. Should be used wherever possible.
        public static async Task<CosmosContainer> CreateDefaultContainerIfNotExistsAsync(this CosmosClient @this)
        {
            var databaseResult = await @this
                .Databases
                .CreateDatabaseFromConfigurationIfNotExistsAsync()
                .ContinueOnAnyContext();
            var database = databaseResult.Database;
            var dataContainerResult = await database
                .Containers
                .CreateContainerFromConfigurationIfNotExistsAsync("default", "/partitionKey")
                .ContinueOnAnyContext();
            return dataContainerResult.Container;
        }

        public static Task<CosmosDatabaseResponse> CreateDatabaseFromConfigurationIfNotExistsAsync(this CosmosDatabases @this)
        {
            Ensure.ArgumentNotNull(@this, nameof(@this));

            // Default to minimum.
            var throughput = 400;
            var throughputEnvironmentVariable = Environment.GetEnvironmentVariable(throughputEnvironmentVariableName);

            if (throughputEnvironmentVariable != null)
            {
                if (!int.TryParse(throughputEnvironmentVariable, out throughput))
                {
                    throw new InvalidOperationException($"Throughput specified in environment variable {throughputEnvironmentVariableName} is '{throughputEnvironmentVariable}', which is not a valid integer.");
                }
            }

            return @this.CreateDatabaseIfNotExistsAsync("inf", throughput: throughput);
        }

        public static Task<CosmosContainerResponse> CreateContainerFromConfigurationIfNotExistsAsync(this CosmosContainers @this, string id, string partitionKeyPath, int? throughput = null)
        {
            Ensure.ArgumentNotNull(@this, nameof(@this));
            Ensure.ArgumentNotNull(id, nameof(id));
            Ensure.ArgumentNotNull(partitionKeyPath, nameof(partitionKeyPath));

            return @this.CreateContainerIfNotExistsAsync(id, partitionKeyPath, throughput: throughput);
        }

        public static async Task<CosmosStoredProcedureResponse> CreateStoredProcedureFromResourceIfNotExistsAsync(this CosmosContainer @this, Type owningType, string id)
        {
            Ensure.ArgumentNotNull(@this, nameof(@this));
            Ensure.ArgumentNotNull(owningType, nameof(owningType));
            Ensure.ArgumentNotNull(id, nameof(id));

            var resourceStreamId = $"{owningType.Namespace}.CosmosServerSideCode.{id}.js";

            using (var stream = owningType.Assembly.GetManifestResourceStream(resourceStreamId))
            {
                if (stream == null)
                {
                    throw new InvalidOperationException($"No embedded resource stream with ID '{resourceStreamId}' could be found.");
                }

                using (var streamReader = new StreamReader(stream))
                {
                    var sprocCode = await streamReader
                        .ReadToEndAsync()
                        .ContinueOnAnyContext();

                    await @this
                        .StoredProcedures[id]
                        .DeleteAsync()
                        .ContinueOnAnyContext();
                    var createSprocResult = await @this
                        .StoredProcedures
                        .CreateStoredProcedureAsync(id, sprocCode)
                        .ContinueOnAnyContext();

                    return createSprocResult;
                }
            }
        }

        public static Task<CosmosItemResponse<TOutput>> ExecuteWithLoggingAsync<TInput, TOutput>(
            this CosmosStoredProcedure @this,
            object partitionKey,
            TInput input,
            CosmosStoredProcedureRequestOptions requestOptions = null,
            CancellationToken cancellationToken = default)
        {
            Ensure.ArgumentNotNull(@this, nameof(@this));
            Ensure.ArgumentNotNull(partitionKey, nameof(partitionKey));

            requestOptions = requestOptions ?? new CosmosStoredProcedureRequestOptions();
            requestOptions.EnableScriptLogging = true;

            return @this.ExecuteAsync<TInput, TOutput>(partitionKey, input, requestOptions, cancellationToken);
        }
    }
}
