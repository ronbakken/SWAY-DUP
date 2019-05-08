using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using Google.Protobuf;
using Grpc.Core;
using Microsoft.Azure.Cosmos;
using Microsoft.Azure.ServiceBus;
using Newtonsoft.Json.Linq;
using Serilog;
using Users.Interfaces;
using Users.ObjectMapping;
using Utility;
using Utility.Search;
using Utility.Sql;
using Utility.Tokens;
using static Users.Interfaces.UsersService;

namespace Users
{
    public sealed class UsersServiceImpl : UsersServiceBase
    {
        public const string userSchemaType = "user";
        public const string userSessionSchemaType = "userSession";

        private readonly ILogger logger;
        private readonly TopicClient userUpdatedTopicClient;
        private CosmosContainer defaultContainer;
        private CosmosStoredProcedure saveUserSproc;

        public UsersServiceImpl(
            ILogger logger,
            TopicClient userUpdatedTopicClient)
        {
            this.logger = logger.ForContext<UsersServiceImpl>();
            this.userUpdatedTopicClient = userUpdatedTopicClient;
        }

        public async Task Initialize(CosmosClient cosmosClient)
        {
            logger.Debug("Creating database if required");

            this.defaultContainer = await cosmosClient
                .CreateDefaultContainerIfNotExistsAsync()
                .ContinueOnAnyContext();

            var createSprocResult = await defaultContainer
                .CreateStoredProcedureFromResourceIfNotExistsAsync(this.GetType(), "saveUser")
                .ContinueOnAnyContext();
            this.saveUserSproc = createSprocResult.StoredProcedure;

            logger.Debug("Database creation complete");
        }

        public override Task<GetUserResponse> GetUser(GetUserRequest request, ServerCallContext context) =>
            APISanitizer.Sanitize(
                this.logger,
                async (logger) =>
                {
                    var userId = request.Id;

                    logger.Debug("Getting user {UserId}", userId);
                    var userResponse = await this
                        .defaultContainer
                        .Items
                        .ReadItemAsync<UserEntity>(userId, userId)
                        .ContinueOnAnyContext();

                    if (userResponse.StatusCode == HttpStatusCode.NotFound)
                    {
                        logger.Debug("User {UserId} not found", userId);
                        return new GetUserResponse();
                    }

                    var userEntity = userResponse.Resource;
                    logger.Debug("Retrieved user {UserId}: {@User}", userId, userEntity);
                    var user = userEntity.ToServiceDto();

                    return new GetUserResponse
                    {
                        User = user,
                    };
                });

        public override Task<GetUserByEmailResponse> GetUserByEmail(GetUserByEmailRequest request, ServerCallContext context) =>
            APISanitizer.Sanitize(
                this.logger,
                async (logger) =>
                {
                    var email = request.Email;

                    logger.Debug("Getting user with email {Email}", email);

                    var sql = new CosmosSqlQueryDefinition("SELECT * FROM u WHERE u.schemaType = @SchemaType AND u.email = @Email");
                    sql.UseParameter("@SchemaType", userSchemaType);
                    sql.UseParameter("@Email", email);

                    // TODO: HACK: using JObject and manually deserializing to get around this: https://github.com/Azure/azure-cosmos-dotnet-v3/issues/19
                    var itemQuery = this
                        .defaultContainer
                        .Items
                        .CreateItemQuery<JObject>(sql, 2);

                    if (!itemQuery.HasMoreResults)
                    {
                        logger.Debug("No user found with email {Email}", email);
                        return new GetUserByEmailResponse();
                    }

                    var currentResultSet = await itemQuery
                        .FetchNextSetAsync()
                        .ContinueOnAnyContext();
                    var results = currentResultSet
                        .Select(Utility.Microsoft.Azure.Cosmos.ProtobufJsonSerializer.Transform<UserEntity>)
                        .Select(currentResult => currentResult.ToServiceDto())
                        .ToList();

                    if (results.Count == 0)
                    {
                        logger.Debug("No user found with email {Email}", email);
                        return new GetUserByEmailResponse();
                    }
                    else if (results.Count > 1)
                    {
                        // This indicates something has gone horribly wrong, since there should only ever be a single user with a given email address.
                        logger.Error("Email {Email} has been used to create more than one user", email);
                        throw new InvalidOperationException($"Email '{email}' has been used to create more than one user.");
                    }

                    var result = results.First();
                    logger.Debug("Retrieved user with email {Email}: {@User}", email, result);
                    return new GetUserByEmailResponse
                    {
                        User = result,
                    };
                });

        public override Task<SaveUserResponse> SaveUser(SaveUserRequest request, ServerCallContext context) =>
            APISanitizer.Sanitize(
                this.logger,
                async (logger) =>
                {
                    var user = request.User;
                    user.Id = user.Id.ValueOr(Guid.NewGuid().ToString());

                    var userEntity = user.ToEntity();

                    logger.Debug("Determining keywords for user {@User}", user);
                    var keywords = Keywords
                        .Extract(
                            user.Name,
                            user.Description,
                            user.Location?.Name,
                            user.WebsiteUrl)
                        .ToList();
                    userEntity.Keywords.AddRange(keywords);

                    logger.Debug("Saving user: {@User}", userEntity);
                    var executeResponse = await this
                        .saveUserSproc
                        .ExecuteWithLoggingAsync<UserEntity, UserEntity>(userEntity.Id, userEntity);
                    userEntity = executeResponse.Resource;
                    logger.Debug("User saved: {@User}", userEntity);

                    user = userEntity.ToServiceDto();

                    if (this.userUpdatedTopicClient != null)
                    {
                        logger.Debug("Publishing user {@User} to service bus", user);
                        var message = new Message(user.ToByteArray());
                        await this
                            .userUpdatedTopicClient
                            .SendAsync(message)
                            .ContinueOnAnyContext();
                    }

                    return new SaveUserResponse
                    {
                        User = user,
                    };
                });

        public override Task<GetUserSessionResponse> GetUserSession(GetUserSessionRequest request, ServerCallContext context) =>
            APISanitizer.Sanitize(
                this.logger,
                async (logger) =>
                {
                    var refreshToken = request.RefreshToken;

                    logger.Debug("Validating refresh token {RefreshToken}", refreshToken);
                    var validationResults = TokenManager.ValidateRefreshToken(refreshToken);

                    if (!validationResults.IsValid)
                    {
                        logger.Warning("Refresh token {RefreshToken} is invalid", refreshToken);
                        throw new InvalidOperationException("Invalid refresh token.");
                    }

                    var userId = validationResults.UserId;

                    logger.Debug("Getting session for user {UserId}, refresh token {RefreshToken}", userId, refreshToken);
                    var userSessionResponse = await this
                        .defaultContainer
                        .Items
                        .ReadItemAsync<UserSessionEntity>(userId, UserSessionIdHelper.GetIdFrom(refreshToken))
                        .ContinueOnAnyContext();

                    if (userSessionResponse.StatusCode == HttpStatusCode.NotFound)
                    {
                        logger.Warning("No session found for user {UserId}, refresh token {RefreshToken}", userId, refreshToken);
                        return new GetUserSessionResponse();
                    }

                    var userSessionEntity = userSessionResponse.Resource;
                    logger.Debug("Resolved session for user {UserId}: {@UserSession}", userId, userSessionEntity);

                    var userSession = userSessionEntity.ToServiceDto();

                    return new GetUserSessionResponse
                    {
                        UserSession = userSession,
                    };
                });

        public override Task<SaveUserSessionResponse> SaveUserSession(SaveUserSessionRequest request, ServerCallContext context) =>
            APISanitizer.Sanitize(
                this.logger,
                async (logger) =>
                {
                    var userSession = request.UserSession;
                    var refreshToken = userSession.RefreshToken;
                    logger.Debug("Validating refresh token {RefreshToken}", refreshToken);
                    var validationResults = TokenManager.ValidateRefreshToken(refreshToken);

                    if (!validationResults.IsValid)
                    {
                        logger.Warning("Refresh token {RefreshToken} is invalid", refreshToken);
                        throw new InvalidOperationException("Invalid refresh token.");
                    }

                    var userId = validationResults.UserId;
                    var userSessionEntity = userSession.ToEntity();
                    userSessionEntity.Id = UserSessionIdHelper.GetIdFrom(userSessionEntity.RefreshToken);
                    userSessionEntity.PartitionKey = userId;

                    logger.Debug("Saving session for user {UserId}: {UserSession}", userId, userSessionEntity);
                    await this
                        .defaultContainer
                        .Items
                        .CreateItemAsync(userId, userSessionEntity)
                        .ContinueOnAnyContext();
                    logger.Information("Session for user {UserId} has been saved: {UserSession}", userId, userSessionEntity);

                    return new SaveUserSessionResponse
                    {
                        UserSession = userSession,
                    };
                });

        public override Task<InvalidateUserSessionResponse> InvalidateUserSession(InvalidateUserSessionRequest request, ServerCallContext context) =>
            APISanitizer.Sanitize(
                this.logger,
                async (logger) =>
                {
                    var refreshToken = request.RefreshToken;

                    logger.Debug("Validating refresh token {RefreshToken}", refreshToken);
                    var validationResults = TokenManager.ValidateRefreshToken(refreshToken);

                    if (!validationResults.IsValid)
                    {
                        logger.Warning("Refresh token {RefreshToken} is invalid", refreshToken);
                        throw new InvalidOperationException("Invalid refresh token.");
                    }

                    var userId = validationResults.UserId;

                    logger.Debug("Deleting session for user {UserId}, refresh token {RefreshToken}", userId, refreshToken);
                    await this
                        .defaultContainer
                        .Items
                        .DeleteItemAsync<UserSessionEntity>(userId, UserSessionIdHelper.GetIdFrom(refreshToken))
                        .ContinueOnAnyContext();
                    logger.Information("Session for user {UserId} with refresh token {RefreshToken} has been invalidated", userId, refreshToken);

                    return new InvalidateUserSessionResponse();
                });

        public override Task<ListUsersResponse> ListUsers(ListUsersRequest request, ServerCallContext context) =>
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

                    this.logger.Debug("Retrieving offers users using page size {PageSize}, continuation token {ContinutationToken}, filter {@Filter}", pageSize, continuationToken, filter);

                    /**
                     * TODO: HACK: this is incredibly frustrating, but I've had to hack around several Cosmos problems as described here. This came about when
                     * adding support for locations of influence. Before that, things were working fine as is.
                     *
                     * First of all, the query I want to write is this:
                     *
                     * SELECT DISTINCT VALUE u
                     * FROM u JOIN loi IN u.locationsOfInfluence
                     * WHERE
                     *   (
                     *     (ST_WITHIN({'type':'Point','coordinates':[u.location.geoPoint.longitude,u.location.geoPoint.latitude]},{'type':'Polygon','coordinates':[[[-108,-43],[-108,-40],[-110,-40],[-110,-43],[-108,-43]]]}))
                     *     OR
                     *     (ST_WITHIN({'type':'Point','coordinates':[loi.geoPoint.longitude,loi.geoPoint.latitude]},{'type':'Polygon','coordinates':[[[-108,-43],[-108,-40],[-110,-40],[-110,-43],[-108,-43]]]}))
                     *   )
                     * ORDER BY u.created
                     *
                     * The join on the locations of influence is key. It prompted the need for DISTINCT, since otherwise the same user could be included in the
                     * results twice. The DISTINCT prompted the need for ORDER BY, which then allows the query to execute again. However, the DISTINCT is then
                     * not applied (see https://stackoverflow.com/questions/55016239/).
                     *
                     * OK, fun. So how do I get around that? Well, my plan was to execute that query anyway and then manually de-duplicate client-side using a
                     * simple hash of the ID. Sounded so simple, except that the query above runs in the portal *but not via the .NET client*. I have reported
                     * this here: https://github.com/Azure/azure-cosmos-dotnet-v3/issues/65
                     *
                     * So where does this leave me? The only alternative I can think of is to manually check each location of influence up to some maximum (3).
                     * Hence, the query is terrible and more limited, but until these bugs are fixed my hands are tied.
                     */

                    var queryBuilder = new CosmosSqlQueryDefinitionBuilder("u");

                    queryBuilder
                        .AppendScalarFieldClause(
                            "schemaType",
                            userSchemaType,
                            value => value);

                    if (filter != null)
                    {
                        queryBuilder
                            .AppendScalarFieldOneOfClause(
                                "type",
                                filter.UserTypes,
                                value => value.ToEntity().ToString().ToCamelCase())
                            .AppendArrayFieldClause(
                                "categoryIds",
                                filter.CategoryIds,
                                value => value,
                                LogicalOperator.And)
                            .AppendArrayFieldClause(
                                "socialMediaAccounts",
                                filter.SocialMediaNetworkIds,
                                value => value,
                                logicalOperator: LogicalOperator.And,
                                subFieldName: "socialNetworkProviderId")
                            .AppendMoneyAtLeastClause(
                                "minimumValue",
                                new Utility.Money(filter.MinimumValue?.CurrencyCode, filter.MinimumValue?.Units ?? 0, filter.MinimumValue?.Nanos ?? 0));

                        if (filter.NorthWest != null && filter.SouthEast != null)
                        {
                            queryBuilder
                                .AppendOpenParenthesis()
                                .AppendBoundingBoxClause(
                                    "location.geoPoint.longitude",
                                    "location.geoPoint.latitude",
                                    filter.NorthWest?.Latitude,
                                    filter.NorthWest?.Longitude,
                                    filter.SouthEast?.Latitude,
                                    filter.SouthEast?.Longitude)
                                .AppendOrIfNecessary()
                                .AppendBoundingBoxClause(
                                    "locationsOfInfluence[0].geoPoint.longitude",
                                    "locationsOfInfluence[0].geoPoint.latitude",
                                    filter.NorthWest?.Latitude,
                                    filter.NorthWest?.Longitude,
                                    filter.SouthEast?.Latitude,
                                    filter.SouthEast?.Longitude)
                                .AppendOrIfNecessary()
                                .AppendBoundingBoxClause(
                                    "locationsOfInfluence[1].geoPoint.longitude",
                                    "locationsOfInfluence[1].geoPoint.latitude",
                                    filter.NorthWest?.Latitude,
                                    filter.NorthWest?.Longitude,
                                    filter.SouthEast?.Latitude,
                                    filter.SouthEast?.Longitude)
                                .AppendOrIfNecessary()
                                .AppendBoundingBoxClause(
                                    "locationsOfInfluence[2].geoPoint.longitude",
                                    "locationsOfInfluence[2].geoPoint.latitude",
                                    filter.NorthWest?.Latitude,
                                    filter.NorthWest?.Longitude,
                                    filter.SouthEast?.Latitude,
                                    filter.SouthEast?.Longitude)
                                .AppendCloseParenthesis();
                        }

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

                        //if (filter.MinimumValue > 0)
                        //{
                        //    logger.Debug("Filtering on minimum value {MinimumValue}", filter.MinimumValue);

                        //    if (clauses.Length > 0)
                        //    {
                        //        clauses.Append(" AND ");
                        //    }

                        //    clauses.Append("u.minimalFee >= @MinimumValue");
                        //    parameters["@MinimumValue"] = filter.MinimumValue;
                        //}
                    }

                    logger.Debug("SQL for search is {SQL}, parameters are {Parameters}", queryBuilder, queryBuilder.Parameters);
                    var queryDefinition = queryBuilder.Build();

                    // TODO: HACK: using JObject and manually deserializing to get around this: https://github.com/Azure/azure-cosmos-dotnet-v3/issues/19
                    var itemQuery = defaultContainer
                        .Items
                        .CreateItemQuery<JObject>(queryDefinition, 2, maxItemCount: pageSize, continuationToken: continuationToken);
                    var items = new List<User>();
                    string nextContinuationToken = null;

                    while (itemQuery.HasMoreResults)
                    {
                        var currentResultSet = await itemQuery
                            .FetchNextSetAsync()
                            .ContinueOnAnyContext();
                        nextContinuationToken = currentResultSet.ContinuationToken;

                        foreach (var user in currentResultSet.Select(Utility.Microsoft.Azure.Cosmos.ProtobufJsonSerializer.Transform<UserEntity>))
                        {
                            items.Add(user.ToServiceDto());
                        }
                    }

                    var result = new ListUsersResponse();
                    result.Users.AddRange(items);

                    if (nextContinuationToken != null)
                    {
                        result.ContinuationToken = nextContinuationToken;
                    }

                    this.logger.Debug("Retrieved users using page size {PageSize}, continuation token {ContinutationToken}, filter {@Filter}. The next continuation token is {NextContinuationToken}: {Users}", pageSize, continuationToken, filter, nextContinuationToken, items);

                    return result;
                });
    }
}
