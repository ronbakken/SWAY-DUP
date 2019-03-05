using System;
using System.Fabric;
using System.IO;
using System.Threading;
using System.Threading.Tasks;
using Genesis.Ensure;
using Utility;

namespace Microsoft.Azure.Cosmos
{
    public static class Extensions
    {
        private const string configurationPackageObjectName = "Config";
        private const string databaseSectionName = "Database";
        private const string connectionStringParameterName = "ConnectionString";
        private const string databaseThroughputParameterName = "DatabaseThroughput";
        private const string throughputParameterName = "Throughput";

        public static CosmosClient GetCosmosClient(this ICodePackageActivationContext @this)
        {
            Ensure.ArgumentNotNull(@this, nameof(@this));

            var configurationPackage = @this.GetConfigurationPackageObject(configurationPackageObjectName);

            if (configurationPackage == null)
            {
                throw new InvalidOperationException($"No configuration package object named '{configurationPackageObjectName}' could be found.");
            }

            if (!configurationPackage.Settings.Sections.Contains(databaseSectionName))
            {
                throw new InvalidOperationException($"Section '{databaseSectionName}' was not found in the '{configurationPackageObjectName}' configuration package.");
            }

            var databaseSection = configurationPackage.Settings.Sections[databaseSectionName];

            if (!databaseSection.Parameters.Contains(connectionStringParameterName))
            {
                throw new InvalidOperationException($"Parameter '{connectionStringParameterName}' was not found in the '{databaseSectionName}' section.");
            }

            var connectionString = databaseSection.Parameters[connectionStringParameterName].Value;
            var cosmosConfiguration = new InfCosmosConfiguration(connectionString);
            var cosmosClient = new CosmosClient(cosmosConfiguration);

            return cosmosClient;
        }

        public static Task<CosmosDatabaseResponse> CreateDatabaseFromConfigurationIfNotExistsAsync(this CosmosDatabases @this)
        {
            Ensure.ArgumentNotNull(@this, nameof(@this));

            // Default to minimum.
            var throughput = 400;

            var activationContext = FabricRuntime.GetActivationContext();
            var configurationPackage = activationContext.GetConfigurationPackageObject(configurationPackageObjectName);

            if (configurationPackage != null)
            {
                if (configurationPackage.Settings.Sections.Contains(databaseSectionName))
                {
                    var databaseSection = configurationPackage.Settings.Sections[databaseSectionName];

                    if (databaseSection.Parameters.Contains(databaseThroughputParameterName))
                    {
                        var offerParameter = databaseSection.Parameters[databaseThroughputParameterName];

                        if (!int.TryParse(offerParameter.Value, out throughput))
                        {
                            throw new InvalidOperationException($"Offer parameter value '{offerParameter.Value}' is not a valid integer.");
                        }
                    }
                }
            }

            return @this.CreateDatabaseIfNotExistsAsync("inf", throughput: throughput);
        }

        public static Task<CosmosContainerResponse> CreateContainerFromConfigurationIfNotExistsAsync(this CosmosContainers @this, string id, string partitionKeyPath)
        {
            Ensure.ArgumentNotNull(@this, nameof(@this));
            Ensure.ArgumentNotNull(id, nameof(id));
            Ensure.ArgumentNotNull(partitionKeyPath, nameof(partitionKeyPath));

            // Default to inherit from database.
            int? throughput = null;

            var activationContext = FabricRuntime.GetActivationContext();
            var configurationPackage = activationContext.GetConfigurationPackageObject(configurationPackageObjectName);

            if (configurationPackage != null)
            {
                if (configurationPackage.Settings.Sections.Contains(databaseSectionName))
                {
                    var databaseSection = configurationPackage.Settings.Sections[databaseSectionName];

                    if (databaseSection.Parameters.Contains(throughputParameterName))
                    {
                        var throughputParameter = databaseSection.Parameters[throughputParameterName];

                        if (!int.TryParse(throughputParameter.Value, out var parsedThroughput))
                        {
                            throw new InvalidOperationException($"Throughput parameter value '{throughputParameter.Value}' is not a valid integer.");
                        }

                        throughput = parsedThroughput;
                    }
                }
            }

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
                        .CreateStoredProceducreAsync(id, sprocCode)
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
