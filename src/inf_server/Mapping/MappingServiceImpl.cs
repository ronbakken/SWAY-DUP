using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using AutoMapper;
using Grpc.Core;
using Mapping.Interfaces;
using Microsoft.Azure.Cosmos;
using Microsoft.Azure.ServiceBus;
using Offers.Interfaces;
using Serilog;
using Utility;
using Utility.Mapping;
using static Mapping.Interfaces.MappingService;

namespace Mapping
{
    public sealed class MappingServiceImpl : MappingServiceBase
    {
        private const string databaseId = "mapping";
        private const string collectionId = "mapItems";
        private const int maxMapLevel = 21;

        private readonly ILogger logger;
        private CosmosContainer mapItemsContainer;

        public MappingServiceImpl(
            ILogger logger,
            SubscriptionClient offerUpdatedSubscriptionClient)
        {
            this.logger = logger.ForContext<MappingServiceImpl>();

            var messageHandlerOptions = new MessageHandlerOptions(this.OnServiceBusException)
            {
                AutoComplete = true,
                MaxConcurrentCalls = 4,
            };
            offerUpdatedSubscriptionClient.RegisterMessageHandler(this.OnOfferUpdated, messageHandlerOptions);
        }

        public async Task Initialize(
            CosmosClient cosmosClient,
            CancellationToken cancellationToken)
        {
            logger.Debug("Creating database if required");

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

        public override Task<SearchResponse> Search(SearchRequest request, ServerCallContext context) =>
            APISanitizer.Sanitize(
                this.logger,
                async (logger) =>
                {
                    var filter = request.Filter;

                    using (logger.Performance("Searching for map items using filter {@Filter}", filter))
                    {
                        var queryDefinition = GetSqlQueryDefinition(logger, filter);
                        var mapItemEntities = await GetMapItemsMatching(logger, this.mapItemsContainer, queryDefinition, filter).ContinueOnAnyContext();
                        var results = mapItemEntities
                            .Select(mapItemEntity => Mapper.Map<MapItem>(mapItemEntity))
                            .ToList();

                        logger.Debug("Results for filter {@Filter}: {@Results}", filter, results);

                        var response = new SearchResponse();
                        response.Results.AddRange(results);
                        return response;
                    }
                });

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

        private async Task OnOfferUpdated(Message message, CancellationToken token)
        {
            this.logger.Debug("OnOfferUpdated");

            var offer = Offer.Parser.ParseFrom(message.Body);

            using (logger.Performance("Updating map data for offer {@Offer}", offer))
            {
                var mapLevel = maxMapLevel;

                while (mapLevel > 0)
                {
                    var quadKey = QuadKey.From(offer.GeoPoint.Latitude, offer.GeoPoint.Longitude, mapLevel);
                    logger.Debug("Determined level {MapLevel} quad key for offer to be {QuadKey}", mapLevel, quadKey);

                    var offerMapItemEntity = Mapper.Map<MapItemEntity>(offer);
                    offerMapItemEntity.QuadKey = quadKey.ToString();

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
