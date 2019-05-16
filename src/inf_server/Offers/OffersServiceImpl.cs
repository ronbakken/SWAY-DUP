using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using Google.Protobuf;
using Google.Protobuf.WellKnownTypes;
using Grpc.Core;
using Microsoft.Azure.Cosmos;
using Microsoft.Azure.ServiceBus;
using Newtonsoft.Json.Linq;
using Offers.Interfaces;
using Offers.ObjectMapping;
using Serilog;
using Utility;
using Utility.Search;
using Utility.Sql;
using static Offers.Interfaces.OffersService;

namespace Offers
{
    public sealed class OffersServiceImpl : OffersServiceBase
    {
        private const string schemaType = "offer";

        private readonly ILogger logger;
        private readonly TopicClient offerUpdatedTopicClient;
        private CosmosContainer defaultContainer;
        private CosmosStoredProcedure saveOfferSproc;

        public OffersServiceImpl(
            ILogger logger,
            TopicClient offerUpdatedTopicClient)
        {
            this.logger = logger.ForContext<OffersServiceImpl>();
            this.offerUpdatedTopicClient = offerUpdatedTopicClient;
        }

        public async Task Initialize(CosmosClient cosmosClient)
        {
            logger.Debug("Creating database if required");

            this.defaultContainer = await cosmosClient.CreateDefaultContainerIfNotExistsAsync();

            var createSprocResult = await defaultContainer
                .CreateStoredProcedureFromResourceIfNotExistsAsync(this.GetType(), "saveOffer")
                .ContinueOnAnyContext();
            this.saveOfferSproc = createSprocResult.StoredProcedure;

            logger.Debug("Database creation complete");
        }

        public override Task<SaveOfferResponse> SaveOffer(SaveOfferRequest request, ServerCallContext context) =>
            APISanitizer.Sanitize(
                this.logger,
                async (logger) =>
                {
                    var offer = request.Offer;
                    var offerEntity = offer.ToEntity();
                    offerEntity.Id = offerEntity.Id.ValueOr(Guid.NewGuid().ToString());
                    offerEntity.PartitionKey = offerEntity.Id;

                    logger.Debug("Determining keywords for offer {@Offer}", offer);
                    var keywords = Keywords
                        .Extract(
                            offer.BusinessName,
                            offer.BusinessDescription,
                            offer.Description,
                            offer.Location?.Name,
                            offer.Title)
                        .ToList();
                    offerEntity.Keywords.AddRange(keywords);

                    logger.Debug("Saving offer {@Offer}", offerEntity);
                    var executeResponse = await this
                        .saveOfferSproc
                        .ExecuteWithLoggingAsync<OfferEntity, OfferEntity>(offerEntity.Id, offerEntity);
                    offerEntity = executeResponse.Resource;
                    logger.Debug("Offer saved: {@Offer}", offerEntity);

                    offer = offerEntity.ToServiceDto();

                    if (this.offerUpdatedTopicClient != null)
                    {
                        logger.Debug("Publishing offer {@Offer} to service bus", offer);
                        var message = new Message(offer.ToByteArray());
                        await this
                            .offerUpdatedTopicClient
                            .SendAsync(message)
                            .ContinueOnAnyContext();
                    }

                    return new SaveOfferResponse
                    {
                        Offer = offer,
                    };
                });

        public override Task<RemoveOfferResponse> RemoveOffer(RemoveOfferRequest request, ServerCallContext context) =>
            APISanitizer.Sanitize(
                this.logger,
                async (logger) =>
                {
                    var offer = request.Offer;

                    if (offer.Id == null)
                    {
                        throw new ArgumentException("Cannot remove an offer that has no ID.");
                    }

                    if (offer.Status != OfferStatus.Active)
                    {
                        throw new ArgumentException("Cannot remove an offer unless it is active.");
                    }

                    var offerEntity = offer.ToEntity();

                    offerEntity.Status = OfferEntity.Types.Status.Inactive;
                    offerEntity.StatusTimestamp = Timestamp.FromDateTime(DateTime.UtcNow);

                    logger.Debug("Removing offer {@Offer}", offerEntity);
                    await this
                        .defaultContainer
                        .Items
                        .UpsertItemAsync(partitionKey: offerEntity.Id, offerEntity)
                        .ContinueOnAnyContext();
                    logger.Debug("Offer removed: {@Offer}", offerEntity);

                    if (this.offerUpdatedTopicClient != null)
                    {
                        logger.Debug("Publishing removal of offer {@Offer} to service bus", offer);
                        var message = new Message(offer.ToByteArray());
                        await this
                            .offerUpdatedTopicClient
                            .SendAsync(message)
                            .ContinueOnAnyContext();
                    }

                    return new RemoveOfferResponse
                    {
                        Offer = offer,
                    };
                });

        public override Task<GetOfferResponse> GetOffer(GetOfferRequest request, ServerCallContext context) =>
            APISanitizer.Sanitize(
                this.logger,
                async (logger) =>
                {
                    var id = request.Id;
                    logger.Debug("Getting offer with ID {Id}", id);

                    var result = await this
                        .defaultContainer
                        .Items
                        .ReadItemAsync<OfferEntity>(partitionKey: id, id)
                        .ContinueOnAnyContext();
                    var offerEntity = result.Resource;
                    logger.Debug("Retrieved offer with ID {Id}: {@Offer}", id, offerEntity);

                    var offer = offerEntity.ToServiceDto();

                    return new GetOfferResponse
                    {
                        Offer = offer,
                    };
                });

        public override Task<ListOffersResponse> ListOffers(ListOffersRequest request, ServerCallContext context) =>
            APISanitizer.Sanitize(
                this.logger,
                async (logger) =>
                {
                    var pageSize = request.PageSize;
                    var continuationToken = request.ContinuationToken;
                    var filter = request.Filter;

                    if (pageSize < 5 || pageSize > 100)
                    {
                        throw new ArgumentException(nameof(pageSize), "pageSize must be >= 5 and <= 100.");
                    }

                    this.logger.Debug("Retrieving offers using page size {PageSize}, continuation token {ContinutationToken}, filter {@Filter}", pageSize, continuationToken, filter);

                    var queryBuilder = new CosmosSqlQueryDefinitionBuilder("o");

                    queryBuilder
                        .AppendScalarFieldClause(
                            "schemaType",
                            schemaType,
                            value => value);

                    if (filter != null)
                    {
                        queryBuilder
                            .AppendScalarFieldClause(
                                "businessAccountId",
                                filter.BusinessAccountId.ValueOr(null),
                                value => value)
                            .AppendScalarFieldOneOfClause(
                                "acceptancePolicy",
                                filter.OfferAcceptancePolicies,
                                value => value.ToEntity().ToString().ToCamelCase())
                            .AppendScalarFieldOneOfClause(
                                "status",
                                filter.OfferStatuses,
                                value => value.ToEntity().ToString().ToCamelCase())
                            .AppendScalarFieldOneOfClause(
                                "terms.reward.type",
                                filter.RewardTypes,
                                value => value.ToEntity().ToString().ToCamelCase())
                            .AppendArrayFieldClause(
                                "terms.deliverable.deliverableTypes",
                                filter.DeliverableTypes,
                                value => value.ToEntity().ToString().ToCamelCase())
                            .AppendArrayFieldClause(
                                "categoryIds",
                                filter.CategoryIds,
                                value => value,
                                LogicalOperator.Or)
                            .AppendMoneyAtLeastClause(
                                "terms.reward.cashValue",
                                new Utility.Money(filter.MinimumReward?.CurrencyCode, filter.MinimumReward?.Units ?? 0, filter.MinimumReward?.Nanos ?? 0))
                            .AppendBoundingBoxClause(
                                "location.geoPoint.longitude",
                                "location.geoPoint.latitude",
                                filter.NorthWest?.Latitude,
                                filter.NorthWest?.Longitude,
                                filter.SouthEast?.Latitude,
                                filter.SouthEast?.Longitude);

                        if (!string.IsNullOrEmpty(filter.Phrase))
                        {
                            var keywordsToFind = Keywords
                                .Extract(filter.Phrase)
                                .Take(10)
                                .ToList();

                            queryBuilder
                                .AppendArrayFieldClause(
                                    "keywords",
                                    keywordsToFind,
                                    value => value,
                                    LogicalOperator.And);
                        }
                    }

                    logger.Debug("SQL for search is {SQL}, parameters are {Parameters}", queryBuilder, queryBuilder.Parameters);
                    var queryDefinition = queryBuilder.Build();

                    // TODO: HACK: using JObject and manually deserializing to get around this: https://github.com/Azure/azure-cosmos-dotnet-v3/issues/19
                    var itemQuery = this
                        .defaultContainer
                        .Items
                        .CreateItemQuery<JObject>(queryDefinition, 2, maxItemCount: pageSize, continuationToken: continuationToken);
                    var items = new List<Offer>();
                    string nextContinuationToken = null;

                    if (itemQuery.HasMoreResults)
                    {
                        var currentResultSet = await itemQuery
                            .FetchNextSetAsync()
                            .ContinueOnAnyContext();
                        nextContinuationToken = currentResultSet.ContinuationToken;

                        foreach (var offer in currentResultSet.Select(Utility.Microsoft.Azure.Cosmos.ProtobufJsonSerializer.Transform<OfferEntity>))
                        {
                            items.Add(offer.ToServiceDto());
                        }
                    }

                    var result = new ListOffersResponse();
                    result.Offers.AddRange(items);

                    if (nextContinuationToken != null)
                    {
                        result.ContinuationToken = nextContinuationToken;
                    }

                    this.logger.Debug("Retrieved offers using page size {PageSize}, continuation token {ContinutationToken}, filter {@Filter}. The next continuation token is {NextContinuationToken}: {Offers}", pageSize, continuationToken, filter, nextContinuationToken, items);

                    return result;
                });
    }
}