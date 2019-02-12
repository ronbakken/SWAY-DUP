using System.Collections.Generic;
using System.Fabric;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using Mapping.Interfaces;
using Microsoft.Azure.Cosmos;
using Microsoft.Azure.ServiceBus;
using Microsoft.ServiceFabric.Services.Communication.Runtime;
using Microsoft.ServiceFabric.Services.Remoting.Runtime;
using Microsoft.ServiceFabric.Services.Runtime;
using Offers.Interfaces;
using Serilog;
using Utility;
using Utility.Mapping;
using Utility.Serialization;

namespace Mapping
{
    internal sealed class Mapping : StatelessService, IMappingService
    {
        private const string databaseId = "mapping";
        private const string collectionId = "mapItems";
        private const int maxMapLevel = 21;
        private readonly ILogger logger;
        private CosmosContainer mapItemsContainer;

        public Mapping(StatelessServiceContext context)
            : base(context)
        {
            var configurationPackage = this.Context.CodePackageActivationContext.GetConfigurationPackageObject("Config");
            var logStorageConnectionString = configurationPackage.Settings.Sections["Logging"].Parameters["StorageConnectionString"].Value;
            this.logger = Logging.GetLogger(this, logStorageConnectionString);
            var serviceBusConnectionString = configurationPackage.Settings.Sections["ServiceBus"].Parameters["ConnectionString"].Value;
            var subscriptionClient = new SubscriptionClient(
                serviceBusConnectionString,
                "OfferUpdated",
                "mapping_service",
                receiveMode: ReceiveMode.ReceiveAndDelete);

            var messageHandlerOptions = new MessageHandlerOptions(this.OnServiceBusException)
            {
                AutoComplete = true,
                MaxConcurrentCalls = 4,
            };
            subscriptionClient.RegisterMessageHandler(this.OnOfferUpdated, messageHandlerOptions);
        }

        protected override async Task RunAsync(CancellationToken cancellationToken)
        {
            logger.Debug("Creating database if required");

            var cosmosClient = this.GetCosmosClient();
            var databaseResult = await cosmosClient
                .Databases
                .CreateDatabaseIfNotExistsAsync(databaseId)
                .ContinueOnAnyContext();
            var database = databaseResult.Database;
            var mapItemsContainerResult = await database
                .Containers
                .CreateContainerIfNotExistsAsync(collectionId, "/quadKey")
                .ContinueOnAnyContext();
            this.mapItemsContainer = mapItemsContainerResult.Container;

            logger.Debug("Database creation complete");
        }

        public Task<List<MapItem>> Search(SearchFilter filter) =>
            this.ReportExceptionsWithin(this.logger, (logger) => SearchImpl(logger, filter));

        internal async Task<List<MapItem>> SearchImpl(ILogger logger, SearchFilter filter)
        {
            using (logger.Performance("Searching for map items using filter {@Filter}", filter))
            {
                var queryDefinition = GetSqlQueryDefinition(logger, filter);
                var mapItems = await GetMapItemsMatching(logger, this.mapItemsContainer, queryDefinition, filter).ContinueOnAnyContext();
                var results = mapItems
                    .Select(mapItem => mapItem.ToOfferServiceObject())
                    .Cast<MapItem>()
                    .ToList();

                logger.Debug("Results for filter {@Filter}: {@Results}", filter, results);

                return results;
            }
        }

        private static CosmosSqlQueryDefinition GetSqlQueryDefinition(ILogger logger, SearchFilter filter)
        {
            var parameters = new Dictionary<string, object>();
            var clauses = new StringBuilder();

            // TODO: filter on types

            // TODO: filter out deleted items with a status timestamp > some period (1 day? 1 week? 1 month?)

            var sql = new StringBuilder("SELECT * FROM o");
            logger.Debug("SQL for search using filter {@Filter} is {SQL}, parameters are {Parameters}", filter, sql, parameters);
            var queryDefinition = new CosmosSqlQueryDefinition(sql.ToString());

            foreach (var parameter in parameters)
            {
                queryDefinition.UseParameter(parameter.Key, parameter.Value);
            }

            return queryDefinition;
        }

        private static async Task<List<MapItemEntity>> GetMapItemsMatching(
            ILogger logger,
            CosmosContainer mapItemsContainer,
            CosmosSqlQueryDefinition queryDefinition,
            SearchFilter filter)
        {
            var itemQuery = mapItemsContainer
                .Items
                .CreateItemQuery<MapItemEntity>(queryDefinition, filter.QuadKey);
            var results = new List<MapItemEntity>();

            while (itemQuery.HasMoreResults)
            {
                var currentResultSet = await itemQuery
                    .FetchNextSetAsync()
                    .ContinueOnAnyContext();

                foreach (var mapItem in currentResultSet)
                {
                    results.Add(mapItem);
                }
            }

            logger.Debug("Retrieved {Count} search results for filter {@Filter}", results.Count, filter);
            return results;
        }

        protected override IEnumerable<ServiceInstanceListener> CreateServiceInstanceListeners() =>
            this.CreateServiceRemotingInstanceListeners();

        private CosmosClient GetCosmosClient()
        {
            var configurationPackage = this.Context.CodePackageActivationContext.GetConfigurationPackageObject("Config");
            var databaseConnectionString = configurationPackage.Settings.Sections["Database"].Parameters["ConnectionString"].Value;
            var cosmosConfiguration = new InfCosmosConfiguration(databaseConnectionString);
            var cosmosClient = new CosmosClient(cosmosConfiguration);

            return cosmosClient;
        }

        private async Task OnOfferUpdated(Message message, CancellationToken token)
        {
            this.logger.Debug("OnOfferUpdated");

            var offer = message.Body.FromSerializedDataContract<Offer>();

            using (logger.Performance("Updating map data for offer {@Offer}", offer))
            {
                var mapLevel = maxMapLevel;

                while (mapLevel > 0)
                {
                    var quadKey = QuadKey.From(offer.Location.Latitude, offer.Location.Longitude, mapLevel);
                    logger.Debug("Determined level {MapLevel} quad key for offer to be {QuadKey}", mapLevel, quadKey);

                    var offerMapItemEntity = offer.ToEntity(quadKey);
                    logger.Debug("Saving offer map item {@OfferMapItem}", offerMapItemEntity);
                    await this
                        .mapItemsContainer
                        .Items
                        .UpsertItemAsync(quadKey.ToString(), offerMapItemEntity)
                        .ContinueOnAnyContext();
                    logger.Debug("Offer map item saved: {@OfferMapItem}", offerMapItemEntity);

                    --mapLevel;
                }
            }
        }

        private Task OnServiceBusException(ExceptionReceivedEventArgs e)
        {
            this.logger.Error(
                e.Exception,
                "Error occurred on service bus for client ID {ClientId}, endpoint {Endpoint}, entity path {EntityPath}, action {Action}",
                e.ExceptionReceivedContext.ClientId,
                e.ExceptionReceivedContext.Endpoint,
                e.ExceptionReceivedContext.EntityPath,
                e.ExceptionReceivedContext.Action);
            return Task.CompletedTask;
        }
    }
}
