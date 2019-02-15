using System;
using System.Collections.Generic;
using System.Threading;
using System.Threading.Tasks;
using AutoMapper;
using Google.Protobuf;
using Google.Protobuf.WellKnownTypes;
using Grpc.Core;
using Microsoft.Azure.Cosmos;
using Microsoft.Azure.ServiceBus;
using NodaTime;
using Offers.Interfaces;
using Optional;
using Serilog;
using Utility;
using static Offers.Interfaces.OffersService;

namespace Offers
{
    public sealed class OffersServiceImpl : OffersServiceBase
    {
        private const string databaseId = "offers";
        private const string offersCollectionId = "offers";

        private readonly ILogger logger;
        private readonly TopicClient offerUpdatedTopicClient;
        private CosmosContainer offersContainer;

        public OffersServiceImpl(
            ILogger logger,
            TopicClient offerUpdatedTopicClient)
        {
            this.logger = logger.ForContext<OffersServiceImpl>();
            this.offerUpdatedTopicClient = offerUpdatedTopicClient;
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
            var offersContainerResult = await database
                .Containers
                .CreateContainerIfNotExistsAsync(offersCollectionId, "/id")
                .ContinueOnAnyContext();
            this.offersContainer = offersContainerResult.Container;

            logger.Debug("Database creation complete");
        }

        public override Task<SaveOfferResponse> SaveOffer(SaveOfferRequest request, ServerCallContext context) =>
            APISanitizer.Sanitize(
                this.logger,
                async (logger) =>
                {
                    var offer = request.Offer;

                    if (offer.Status == Offer.Types.Status.Inactive)
                    {
                        throw new ArgumentException("Cannot save inactive offer.");
                    }

                    var offerEntity = Mapper
                        .Map<OfferEntity>(offer);

                    offerEntity.Id = offer.Id.ValueOr(Guid.NewGuid().ToString());
                    offerEntity.Status = OfferEntity.Types.Status.Active;
                    offerEntity.StatusTimestamp = Timestamp.FromDateTime(DateTime.UtcNow);
                    offer = Mapper.Map<Offer>(offerEntity);

                    logger.Debug("Saving offer {@Offer}", offerEntity);
                    await this
                        .offersContainer
                        .Items
                        .UpsertItemAsync(partitionKey: offerEntity.Id, offerEntity)
                        .ContinueOnAnyContext();
                    logger.Debug("Offer saved: {@Offer}", offerEntity);

                    logger.Debug("Publishing offer {@Offer} to service bus", offer);
                    var message = new Message(offer.ToByteArray());
                    await this
                        .offerUpdatedTopicClient
                        .SendAsync(message)
                        .ContinueOnAnyContext();

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

                    if (offer.Status != Offer.Types.Status.Active)
                    {
                        throw new ArgumentException("Cannot remove an offer unless it is active.");
                    }

                    var offerEntity = Mapper
                        .Map<OfferEntity>(offer);

                    offerEntity.Status = OfferEntity.Types.Status.Inactive;
                    offerEntity.StatusTimestamp = Timestamp.FromDateTime(DateTime.UtcNow);

                    logger.Debug("Removing offer {@Offer}", offerEntity);
                    await this
                        .offersContainer
                        .Items
                        .UpsertItemAsync(partitionKey: offerEntity.Id, offerEntity)
                        .ContinueOnAnyContext();
                    logger.Debug("Offer removed: {@Offer}", offerEntity);

                    logger.Debug("Publishing removal of offer {@Offer} to service bus", offer);
                    var message = new Message(offer.ToByteArray());
                    await this
                        .offerUpdatedTopicClient
                        .SendAsync(message)
                        .ContinueOnAnyContext();

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

                    var sql = new CosmosSqlQueryDefinition("SELECT * FROM o WHERE o.id = @Id");
                    sql.UseParameter("@Id", id);

                    var result = await this
                        .offersContainer
                        .Items
                        .ReadItemAsync<OfferEntity>(partitionKey: id, id)
                        .ContinueOnAnyContext();
                    var offerEntity = result.Resource;
                    logger.Debug("Retrieved offer with ID {Id}: {@Offer}", id, offerEntity);

                    var offer = Mapper.Map<Offer>(offerEntity);

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

                    if (pageSize < 5 || pageSize > 100)
                    {
                        throw new ArgumentException(nameof(pageSize), "pageSize must be >= 5 and <= 100.");
                    }

                    this.logger.Debug("Retrieving offers using page size {PageSize}, continuation token {ContinutationToken}", pageSize, continuationToken);
                    var sql = new CosmosSqlQueryDefinition("SELECT * FROM o");

                    var itemQuery = this
                        .offersContainer
                        .Items
                        .CreateItemQuery<OfferEntity>(sql, 2, maxItemCount: pageSize, continuationToken: continuationToken);
                    var items = new List<Offer>();
                    string nextContinuationToken = null;

                    if (itemQuery.HasMoreResults)
                    {
                        var currentResultSet = await itemQuery
                            .FetchNextSetAsync()
                            .ContinueOnAnyContext();
                        nextContinuationToken = currentResultSet.ContinuationToken;

                        foreach (var offer in currentResultSet)
                        {
                            items.Add(Mapper.Map<Offer>(offer));
                        }
                    }

                    var result = new ListOffersResponse();

                    result.Offers.AddRange(items);

                    if (nextContinuationToken != null)
                    {
                        result.ContinuationToken = nextContinuationToken;
                    }

                    this.logger.Debug("Retrieved offers using page size {PageSize}, continuation token {ContinutationToken}. The next continuation token is {NextContinuationToken}: {Offers}", pageSize, continuationToken, nextContinuationToken, items);

                    return result;
                });
    }
}
