﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;
using Grpc.Core;
using Mapping.Interfaces;
using Mapping.ObjectMapping;
using Microsoft.Azure.Cosmos;
using Microsoft.Azure.ServiceBus;
using Newtonsoft.Json.Linq;
using Offers.Interfaces;
using Serilog;
using Users.Interfaces;
using Utility;
using Utility.Mapping;
using Utility.Search;
using Utility.Sql;
using static Mapping.Interfaces.MappingService;

namespace Mapping
{
    public sealed class MappingServiceImpl : MappingServiceBase
    {
        private const string schemaType = "mapItem";
        private const int maxMapLevel = 21;

        private readonly ILogger logger;
        private CosmosContainer defaultContainer;

        public MappingServiceImpl(
            ILogger logger,
            SubscriptionClient offerUpdatedSubscriptionClient,
            SubscriptionClient userUpdatedSubscriptionClient)
        {
            this.logger = logger.ForContext<MappingServiceImpl>();

            if (offerUpdatedSubscriptionClient != null)
            {
                var messageHandlerOptions = new MessageHandlerOptions(this.OnServiceBusException)
                {
                    AutoComplete = true,
                    MaxConcurrentCalls = 4,
                };
                offerUpdatedSubscriptionClient.RegisterMessageHandler(this.OnOfferUpdated, messageHandlerOptions);
            }

            if (userUpdatedSubscriptionClient != null)
            {
                var messageHandlerOptions = new MessageHandlerOptions(this.OnServiceBusException)
                {
                    AutoComplete = true,
                    MaxConcurrentCalls = 4,
                };
                userUpdatedSubscriptionClient.RegisterMessageHandler(this.OnUserUpdated, messageHandlerOptions);
            }
        }

        public async Task Initialize(CosmosClient cosmosClient)
        {
            logger.Debug("Creating database if required");

            this.defaultContainer = await cosmosClient
                .CreateDefaultContainerIfNotExistsAsync()
                .ContinueOnAnyContext();

            logger.Debug("Database creation complete");
        }

        public override Task<ListMapItemsResponse> ListMapItems(ListMapItemsRequest request, ServerCallContext context) =>
            APISanitizer.Sanitize(
                this.logger,
                async (logger) =>
                {
                    var filter = request.Filter;

                    // TODO: revisit this limit later. Ideally, it would be significantly lower.
                    if (filter.QuadKeys.Count > 64)
                    {
                        throw new InvalidOperationException("Too many quad keys requested.");
                    }

                    using (logger.Performance("Searching for map items using filter {@Filter}", filter))
                    {
                        var queryDefinition = GetSqlQueryDefinition(logger, filter);
                        var mapItemResultTasks = filter
                            .QuadKeys
                            .Select(quadKey => GetMapItemsMatching(logger, this.defaultContainer, queryDefinition, quadKey))
                            .ToList();
                        var mapItemResults = await Task
                            .WhenAll(mapItemResultTasks)
                            .ContinueOnAnyContext();

                        var results = mapItemResults
                            .SelectMany(x => x)
                            .Select(mapItemEntity => mapItemEntity.ToMapItem())
                            .ToList();

                        logger.Debug("Results for filter {@Filter}: {@Results}", filter, results);

                        var response = new ListMapItemsResponse();
                        response.Results.AddRange(results);
                        return response;
                    }
                });

        private static CosmosSqlQueryDefinition GetSqlQueryDefinition(ILogger logger, ListMapItemsRequest.Types.Filter filter)
        {
            var queryBuilder = new CosmosSqlQueryDefinitionBuilder("m");

            queryBuilder
                .AppendScalarFieldClause(
                    "schemaType",
                    schemaType,
                    value => value);

            if (filter.ItemTypes.Count > 0)
            {
                queryBuilder.AppendOpenParenthesis();

                foreach (var itemType in filter.ItemTypes)
                {
                    queryBuilder.AppendOrIfNecessary();

                    queryBuilder
                        .Append("is_defined(");

                    switch (itemType)
                    {
                        case ListMapItemsRequest.Types.Filter.Types.ItemType.Offers:
                            queryBuilder
                                .AppendFieldName("offer");
                            break;
                        case ListMapItemsRequest.Types.Filter.Types.ItemType.Users:
                            queryBuilder
                                .AppendFieldName("user");
                            break;
                        default:
                            throw new NotSupportedException();
                    }

                    queryBuilder
                        .Append(")");
                }

                queryBuilder.AppendCloseParenthesis();
            }

            queryBuilder
                .AppendArrayFieldClause(
                    "categoryIds",
                    filter.CategoryIds,
                    value => value,
                    LogicalOperator.Or);

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

            if (filter.OfferFilter != null)
            {
                // Apply offer filter to offer items only
                queryBuilder
                    .AppendOpenParenthesis()
                    .Append("is_defined(")
                    .AppendFieldName("offer")
                    .Append(")")
                    .AppendScalarFieldOneOfClause(
                        "offer.acceptancePolicy",
                        filter.OfferFilter.AcceptancePolicies,
                        value => value.ToAcceptancePolicy().ToString().ToCamelCase())
                    .AppendScalarFieldClause(
                        "offer.businessAccountId",
                        filter.OfferFilter.BusinessAccountId.ValueOr(null),
                        value => value)
                    .AppendArrayFieldClause(
                        "offer.deliverableTypes",
                        filter.OfferFilter.DeliverableTypes,
                        value => value.ToDeliverableType().ToString().ToCamelCase())
                    .AppendArrayFieldClause(
                        "offer.deliverableSocialMediaNetworkIds",
                        filter.OfferFilter.DeliverableSocialNetworkProviderIds,
                        value => value)
                    .AppendScalarFieldOneOfClause(
                        "offer.status",
                        filter.OfferFilter.OfferStatuses,
                        value => value.ToStatus().ToString().ToCamelCase())
                    .AppendMoneyAtLeastClause(
                        "offer.cashReward",
                        new Utility.Money(filter.OfferFilter.MinimumRewardCash?.CurrencyCode, filter.OfferFilter.MinimumRewardCash?.Units ?? 0, filter.OfferFilter.MinimumRewardCash?.Nanos ?? 0))
                    .AppendMoneyAtLeastClause(
                        "offer.serviceReward",
                        new Utility.Money(filter.OfferFilter.MinimumRewardService?.CurrencyCode, filter.OfferFilter.MinimumRewardService?.Units ?? 0, filter.OfferFilter.MinimumRewardService?.Nanos ?? 0))
                    .AppendCloseParenthesis();
            }

            if (filter.UserFilter != null)
            {
                // Apply user filter to user items only
                queryBuilder
                    .AppendOpenParenthesis()
                    .Append("is_defined(")
                    .AppendFieldName("user")
                    .Append(")")
                    .AppendMoneyAtLeastClause(
                        "user.minimalFee",
                        new Utility.Money(filter.UserFilter?.MinimumValue?.CurrencyCode, filter.UserFilter?.MinimumValue?.Units ?? 0, filter.UserFilter?.MinimumValue?.Nanos ?? 0))
                    .AppendMoneyAtMostClause(
                        "user.minimalFee",
                        new Utility.Money(filter.UserFilter?.MaximumValue?.CurrencyCode, filter.UserFilter?.MaximumValue?.Units ?? 0, filter.UserFilter?.MaximumValue?.Nanos ?? 0))
                    .AppendScalarFieldOneOfClause(
                        "user.type",
                        filter.UserFilter.UserTypes,
                        value => value.ToUserType().ToString().ToCamelCase())
                    .AppendArrayFieldClause(
                        "user.socialMediaNetworkIds",
                        filter.UserFilter.SocialMediaNetworkIds,
                        value => value,
                        logicalOperator: LogicalOperator.Or)
                    .AppendCloseParenthesis();
            }

            // TODO: filter out deleted items with a status timestamp > some period (1 day? 1 week? 1 month?)

            logger.Debug("SQL for search is {SQL}, parameters are {Parameters}", queryBuilder, queryBuilder.Parameters);
            var queryDefinition = queryBuilder.Build();

            return queryDefinition;
        }

        private static async Task<List<MapItemEntity>> GetMapItemsMatching(
            ILogger logger,
            CosmosContainer mapItemsContainer,
            CosmosSqlQueryDefinition queryDefinition,
            string quadKey)
        {
            // TODO: HACK: using JObject and manually deserializing to get around this: https://github.com/Azure/azure-cosmos-dotnet-v3/issues/19
            var itemQuery = mapItemsContainer
                .Items
                .CreateItemQuery<JObject>(queryDefinition, quadKey);
            var results = new List<MapItemEntity>();

            while (itemQuery.HasMoreResults)
            {
                var currentResultSet = await itemQuery
                    .FetchNextSetAsync()
                    .ContinueOnAnyContext();

                foreach (var mapItem in currentResultSet.Select(Utility.Microsoft.Azure.Cosmos.ProtobufJsonSerializer.Transform<MapItemEntity>))
                {
                    results.Add(mapItem);
                }
            }

            logger.Debug("Retrieved {Count} search results for quad key {@QuadKey}", results.Count, quadKey);
            return results;
        }

        private async Task OnOfferUpdated(Message message, CancellationToken token)
        {
            this.logger.Debug("OnOfferUpdated");

            var offer = Offer.Parser.ParseFrom(message.Body);

            if (offer.Location?.GeoPoint == null)
            {
                logger.Warning("Offer has no location: {@Offer}", offer);
                return;
            }

            using (logger.Performance("Updating map data for offer {@Offer}", offer))
            {
                var mapLevel = maxMapLevel;
                var offerMapItemEntity = offer.ToMapItemEntity();

                while (mapLevel > 0)
                {
                    var quadKey = QuadKey.From(offer.Location.GeoPoint.Latitude, offer.Location.GeoPoint.Longitude, mapLevel);
                    offerMapItemEntity.PartitionKey = quadKey.ToString();
                    logger.Debug("Determined level {MapLevel} quad key for offer to be {QuadKey}", mapLevel, quadKey);

                    logger.Debug("Saving offer map item {@OfferMapItem}", offerMapItemEntity);
                    await this
                        .defaultContainer
                        .Items
                        .UpsertItemAsync(offerMapItemEntity.PartitionKey, offerMapItemEntity)
                        .ContinueOnAnyContext();
                    logger.Debug("Offer map item saved: {@OfferMapItem}", offerMapItemEntity);

                    --mapLevel;
                }
            }
        }

        private async Task OnUserUpdated(Message message, CancellationToken token)
        {
            this.logger.Debug("OnUserUpdated");

            var user = User.Parser.ParseFrom(message.Body);

            if (user.Location?.GeoPoint == null)
            {
                logger.Warning("User has no location: {@User}", user);
                return;
            }

            using (logger.Performance("Updating map data for user {@User}", user))
            {
                var mapLevel = maxMapLevel;
                var userMapItemEntity = user.ToMapItemEntity();

                while (mapLevel > 0)
                {
                    var quadKey = QuadKey.From(user.Location.GeoPoint.Latitude, user.Location.GeoPoint.Longitude, mapLevel);
                    userMapItemEntity.PartitionKey = quadKey.ToString();
                    logger.Debug("Determined level {MapLevel} quad key for user to be {QuadKey}", mapLevel, quadKey);

                    logger.Debug("Saving user map item {@OfferMapItem}", userMapItemEntity);
                    await this
                        .defaultContainer
                        .Items
                        .UpsertItemAsync(userMapItemEntity.PartitionKey, userMapItemEntity)
                        .ContinueOnAnyContext();
                    logger.Debug("User map item saved: {@OfferMapItem}", userMapItemEntity);

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
