using System.Collections.Generic;
using System.Fabric;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using Common.Interfaces;
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
        private const string offersCollectionId = "offers";
        private const int maxMapLevel = 21;
        private readonly ILogger logger;
        private CosmosContainer offersContainer;

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
            var offersContainerResult = await database
                .Containers
                .CreateContainerIfNotExistsAsync(offersCollectionId, "/quadKey")
                .ContinueOnAnyContext();
            this.offersContainer = offersContainerResult.Container;

            logger.Debug("Database creation complete");
        }

        public Task<List<OfferMapItem>> Search(OfferSearchFilter filter) =>
            this.ReportExceptionsWithin(this.logger, (logger) => SearchImpl(logger, filter));

        internal async Task<List<OfferMapItem>> SearchImpl(ILogger logger, OfferSearchFilter filter)
        {
            using (logger.Performance("Searching for offers using filter {@Filter}", filter))
            {
                var northWestQuadKey = QuadKey.From(filter.NorthWest.Latitude, filter.NorthWest.Longitude, filter.MapLevel);
                var southEastQuadKey = QuadKey.From(filter.SouthEast.Latitude, filter.SouthEast.Longitude, filter.MapLevel);
                var quadKeys = QuadKey
                    .GetRange(northWestQuadKey, southEastQuadKey)
                    .ToList();

                logger.Debug("Determined that filter {@Filter} encompasses quad keys {QuadKeys}", filter, quadKeys);

                var queryDefinition = GetOffersSqlQueryDefinition(logger, filter);
                var queryTasks = quadKeys
                    .Select(quadKey => GetOffersMatching(logger, this.offersContainer, queryDefinition, quadKey, filter))
                    .ToList();

                var queryResults = await Task
                    .WhenAll(queryTasks)
                    .ContinueOnAnyContext();

                var results = queryResults
                    .SelectMany(queryResult => queryResult)
                    .OrderBy(offerMapItem => offerMapItem.DistanceFromCenter)
                    .Select(offerMapItem => offerMapItem.ToServiceObject())
                    .ToList();

                logger.Debug("Final results for filter {@Filter}: {@Results}", filter, results);

                return results;
            }
        }

        private static CosmosSqlQueryDefinition GetOffersSqlQueryDefinition(ILogger logger, OfferSearchFilter filter)
        {
            var parameters = new Dictionary<string, object>();
            var clauses = new StringBuilder();

            logger.Debug("Filtering on locations {@NorthWest} to {@SouthEast}", filter.NorthWest, filter.SouthEast);

            if (clauses.Length > 0)
            {
                clauses.Append(" AND ");
            }

            // TODO: normalize the geolocations?
            var northWest = filter.NorthWest;
            var southEast = filter.SouthEast;
            var center = new GeoLocation((northWest.Latitude + southEast.Latitude) / 2, (northWest.Longitude + southEast.Longitude) / 2);

            // Coordinates for the polygon that surrounds the bounding box
            var boundingBoxCoordinates = new[]
            {
                (northWest.Longitude, northWest.Latitude),
                (northWest.Longitude, southEast.Latitude),
                (southEast.Longitude, southEast.Latitude),
                (southEast.Longitude, northWest.Latitude),
                (northWest.Longitude, northWest.Latitude),
            };
            logger.Debug("Bounding box polygon coordinates are {BoundingBoxCoordinates}", boundingBoxCoordinates);

            var boundingBoxCoordinatesSql = boundingBoxCoordinates
                .Aggregate(
                    new StringBuilder(),
                    (acc, next) =>
                    {
                        if (acc.Length > 0)
                        {
                            acc.Append(",");
                        }

                        acc
                            .Append("[")
                            .Append(next.Longitude)
                            .Append(",")
                            .Append(next.Latitude)
                            .Append("]");

                        return acc;
                    },
                    acc => acc.ToString());

            clauses.Append($"ST_WITHIN({{'type':'Point','coordinates':[o.location.longitude,o.location.latitude]}},{{'type':'Polygon','coordinates':[[{boundingBoxCoordinatesSql}]]}})");

            var sql = new StringBuilder("SELECT o.id,o.version,o.quadKey,o.userId,o.location,ST_DISTANCE({'type':'Point','coordinates':[o.location.longitude,o.location.latitude]},{'type':'Point','coordinates':[@CenterLongitude,@CenterLatitude]}) AS distanceFromCenter FROM o");
            parameters["@CenterLongitude"] = center.Longitude;
            parameters["@CenterLatitude"] = center.Latitude;

            if (clauses.Length > 0)
            {
                sql
                    .Append(" WHERE ")
                    .Append(clauses);
            }

            logger.Debug("SQL for search using filter {@Filter} is {SQL}, parameters are {Parameters}", filter, sql, parameters);
            var queryDefinition = new CosmosSqlQueryDefinition(sql.ToString());

            foreach (var parameter in parameters)
            {
                queryDefinition.UseParameter(parameter.Key, parameter.Value);
            }

            return queryDefinition;
        }

        private static async Task<List<OfferMapItemQueryEntity>> GetOffersMatching(
            ILogger logger,
            CosmosContainer offersContainer,
            CosmosSqlQueryDefinition queryDefinition,
            QuadKey quadKey,
            OfferSearchFilter filter)
        {
            var itemQuery = offersContainer
                .Items
                .CreateItemQuery<OfferMapItemQueryEntity>(queryDefinition, quadKey.ToString());
            var results = new List<OfferMapItemQueryEntity>();

            while (itemQuery.HasMoreResults)
            {
                var currentResultSet = await itemQuery
                    .FetchNextSetAsync()
                    .ContinueOnAnyContext();

                foreach (var offerMapItem in currentResultSet)
                {
                    results.Add(offerMapItem);
                }
            }

            logger.Debug("Retrieved {Count} search results for filter {@Filter} in quad key {QuadKey}", results.Count, filter, quadKey);
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
                        .offersContainer
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
