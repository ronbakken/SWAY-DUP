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
        private const string databaseId = "users";
        private const string usersCollectionId = "users";
        private const string sessionsCollectionId = "sessions";

        private readonly ILogger logger;
        private readonly TopicClient userUpdatedTopicClient;
        private CosmosContainer usersContainer;
        private CosmosContainer sessionsContainer;
        private CosmosStoredProcedure saveUserSproc;

        public UsersServiceImpl(
            ILogger logger,
            TopicClient userUpdatedTopicClient)
        {
            this.logger = logger.ForContext<UsersServiceImpl>();
            this.userUpdatedTopicClient = userUpdatedTopicClient;
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
            var usersContainerResult = await database
                .Containers
                .CreateContainerFromConfigurationIfNotExistsAsync(usersCollectionId, "/id")
                .ContinueOnAnyContext();
            this.usersContainer = usersContainerResult.Container;
            var sessionsContainerResult = await database
                .Containers
                .CreateContainerFromConfigurationIfNotExistsAsync(sessionsCollectionId, "/userId")
                .ContinueOnAnyContext();
            this.sessionsContainer = sessionsContainerResult.Container;

            var createSprocResult = await usersContainer
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
                        .usersContainer
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

                    var sql = new CosmosSqlQueryDefinition("SELECT * FROM u WHERE u.email = @Email");
                    sql.UseParameter("@Email", email);

                    // TODO: HACK: using JObject and manually deserializing to get around this: https://github.com/Azure/azure-cosmos-dotnet-v3/issues/19
                    var itemQuery = this
                        .usersContainer
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
                        .Select(InfCosmosConfiguration.Transform<UserEntity>)
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
                        return new GetUserByEmailResponse();
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
                        .sessionsContainer
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
                    userSessionEntity.UserId = userId;

                    logger.Debug("Saving session for user {UserId}: {UserSession}", userId, userSessionEntity);
                    await this
                        .sessionsContainer
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
                        .sessionsContainer
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

                    var clause = new FilterClauseBuilder("u");

                    if (filter != null)
                    {
                        clause
                            .AppendScalarFieldOneOfClause(
                                "type",
                                filter.UserTypes,
                                value => value.ToEntity().ToString().ToCamelCase())
                            .AppendArrayFieldClause(
                                "categoryIds",
                                filter.CategoryIds,
                                value => value,
                                FilterLogicalOperator.And)
                            .AppendArrayFieldClause(
                                "socialMediaAccounts",
                                filter.SocialMediaNetworkIds,
                                value => value,
                                logicalOperator: FilterLogicalOperator.And,
                                subFieldName: "socialNetworkProviderId")
                            .AppendMoneyAtLeastClause(
                                "minimumValue",
                                new Utility.Money(filter.MinimumValue?.CurrencyCode, filter.MinimumValue?.Units ?? 0, filter.MinimumValue?.Nanos ?? 0))
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

                            clause
                                .AppendArrayFieldClause(
                                    "keywords",
                                    keywordsToFind,
                                    value => value,
                                    FilterLogicalOperator.And);
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

                    var sql = new StringBuilder("SELECT * FROM u");

                    if (!clause.IsEmpty)
                    {
                        sql
                            .Append(" WHERE ")
                            .Append(clause);
                    }

                    logger.Debug("SQL for search is {SQL}, parameters are {Parameters}", sql, clause.Parameters);
                    var queryDefinition = new CosmosSqlQueryDefinition(sql.ToString());

                    foreach (var parameter in clause.Parameters)
                    {
                        queryDefinition.UseParameter(parameter.Key, parameter.Value);
                    }

                    // TODO: HACK: using JObject and manually deserializing to get around this: https://github.com/Azure/azure-cosmos-dotnet-v3/issues/19
                    var itemQuery = usersContainer
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

                        foreach (var user in currentResultSet.Select(InfCosmosConfiguration.Transform<UserEntity>))
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
