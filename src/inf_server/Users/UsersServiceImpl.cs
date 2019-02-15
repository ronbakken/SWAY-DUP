using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using AutoMapper;
using Grpc.Core;
using Microsoft.Azure.Cosmos;
using Serilog;
using Users.Interfaces;
using Utility;
using Utility.Search;
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
        private CosmosContainer usersContainer;
        private CosmosContainer sessionsContainer;

        public UsersServiceImpl(
            ILogger logger)
        {
            this.logger = logger.ForContext<UsersServiceImpl>();
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
                .CreateContainerIfNotExistsAsync(usersCollectionId, "/id")
                .ContinueOnAnyContext();
            this.usersContainer = usersContainerResult.Container;
            var sessionsContainerResult = await database
                .Containers
                .CreateContainerIfNotExistsAsync(sessionsCollectionId, "/userId")
                .ContinueOnAnyContext();
            this.sessionsContainer = sessionsContainerResult.Container;

            logger.Debug("Database creation complete");
        }

        public override Task<GetUserDataResponse> GetUserData(GetUserDataRequest request, ServerCallContext context) =>
            APISanitizer.Sanitize(
                this.logger,
                async (logger) =>
                {
                    var userId = request.Id;

                    logger.Debug("Getting data for user {UserId}", userId);
                    var userDataResponse = await this
                        .usersContainer
                        .Items
                        .ReadItemAsync<UserDataEntity>(userId, userId)
                        .ContinueOnAnyContext();

                    if (userDataResponse.StatusCode == HttpStatusCode.NotFound)
                    {
                        logger.Debug("No data found for user {UserId}", userId);
                        return null;
                    }

                    var userDataEntity = userDataResponse.Resource;
                    logger.Debug("Retrieved data for user {UserId}: {@UserData}", userId, userDataEntity);
                    var userData = Mapper.Map<UserData>(userDataEntity);

                    return new GetUserDataResponse
                    {
                        UserData = userData,
                    };
                });

        public override Task<GetUserDataByEmailResponse> GetUserDataByEmail(GetUserDataByEmailRequest request, ServerCallContext context) =>
            APISanitizer.Sanitize(
                this.logger,
                async (logger) =>
                {
                    var email = request.Email;

                    logger.Debug("Getting data for user with email {Email}", email);

                    var sql = new CosmosSqlQueryDefinition("SELECT * FROM u WHERE u.email = @Email");
                    sql.UseParameter("@Email", email);

                    var itemQuery = this
                        .usersContainer
                        .Items
                        .CreateItemQuery<UserDataEntity>(sql, 2);

                    if (!itemQuery.HasMoreResults)
                    {
                        logger.Debug("No user found with email {Email}", email);
                        return new GetUserDataByEmailResponse();
                    }

                    var currentResultSet = await itemQuery
                        .FetchNextSetAsync()
                        .ContinueOnAnyContext();
                    var results = currentResultSet
                        .Select(currentResult => Mapper.Map<UserData>(currentResult))
                        .ToList();

                    if (results.Count == 0)
                    {
                        logger.Debug("No user found with email {Email}", email);
                        return new GetUserDataByEmailResponse();
                    }
                    else if (results.Count > 1)
                    {
                        // This indicates something has gone horribly wrong, since there should only ever be a single user with a given email address.
                        logger.Error("Email {Email} has been used to create more than one user", email);
                        return new GetUserDataByEmailResponse();
                    }

                    var result = results.First();
                    logger.Debug("Retrieved data for user with email {Email}: {@UserData}", email, result);
                    return new GetUserDataByEmailResponse
                    {
                        UserData = result,
                    };
                });

        public override Task<SaveUserDataResponse> SaveUserData(SaveUserDataRequest request, ServerCallContext context) =>
            APISanitizer.Sanitize(
                this.logger,
                async (logger) =>
                {
                    var userData = request.UserData;
                    userData.Id = userData.Id.ValueOr(Guid.NewGuid().ToString());

                    var userDataEntity = Mapper.Map<UserDataEntity>(userData);

                    logger.Debug("Determining keywords for user data {@UserData}", userData);
                    var keywords = Keywords
                        .Extract(
                            userData.Name,
                            userData.Description,
                            userData.Location?.Name,
                            userData.WebsiteUri)
                        .ToList();
                    userDataEntity.Keywords.AddRange(keywords);

                    logger.Debug("Saving user data: {@UserData}", userDataEntity);
                    await this
                        .usersContainer
                        .Items
                        .UpsertItemAsync(userData.Id, userDataEntity)
                        .ContinueOnAnyContext();
                    logger.Debug("User data saved: {@UserData}", userData);

                    return new SaveUserDataResponse
                    {
                        UserData = userData,
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

                    var userSession = Mapper.Map<UserSession>(userSessionEntity);

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
                    var userSessionEntity = Mapper.Map<UserSessionEntity>(userSession);
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

        public override Task<SearchResponse> Search(SearchRequest request, ServerCallContext context) =>
            APISanitizer.Sanitize(
                this.logger,
                async (logger) =>
                {
                    var filter = request.Filter;
                    var parameters = new Dictionary<string, object>();
                    var clauses = new StringBuilder();

                    if (filter.UserTypes.Count > 0)
                    {
                        logger.Debug("Filtering on user types {UserTypes}", filter.UserTypes);

                        var count = 0;

                        clauses.Append("(");

                        foreach (var userType in filter.UserTypes)
                        {
                            var userTypeEntity = Mapper.Map<UserDataEntity.Types.Type>(userType);

                            if (count > 0)
                            {
                                clauses.Append(" OR ");
                            }

                            clauses
                                .Append("c.type = @UserType")
                                .Append(count);
                            parameters[$"@UserType{count}"] = (int)userTypeEntity;
                            ++count;
                        }

                        clauses.Append(")");
                    }

                    if (filter.CategoryIds != null && filter.CategoryIds.Count > 0)
                    {
                        logger.Debug("Filtering on category IDs {CategoryIds}", filter.CategoryIds);

                        for (var i = 0; i < filter.CategoryIds.Count; ++i)
                        {
                            var categoryId = filter.CategoryIds[i];

                            if (clauses.Length > 0)
                            {
                                clauses.Append(" AND ");
                            }

                            clauses
                                .Append("ARRAY_CONTAINS(u.categoryIds, @CategoryId")
                                .Append(i)
                                .Append(")");
                            parameters[$"@CategoryId{i}"] = categoryId;
                        }
                    }

                    if (filter.GeoPoint != null)
                    {
                        logger.Debug("Filtering on location {@Location}", filter.GeoPoint);

                        if (clauses.Length > 0)
                        {
                            clauses.Append(" AND ");
                        }

                        clauses.Append("ST_DISTANCE({'type':'Point','coordinates':[u.location.longitude,u.location.latitude]},{'type':'Point','coordinates':[@Longitude,@Latitude]}) < @Distance");
                        parameters["@Longitude"] = filter.GeoPoint.Longitude;
                        parameters["@Latitude"] = filter.GeoPoint.Latitude;
                        parameters["@Distance"] = filter.LocationDistanceKms * 1000;
                    }

                    if (filter.MinimumValue > 0)
                    {
                        logger.Debug("Filtering on minimum value {MinimumValue}", filter.MinimumValue);

                        if (clauses.Length > 0)
                        {
                            clauses.Append(" AND ");
                        }

                        clauses.Append("u.minimalFee >= @MinimumValue");
                        parameters["@MinimumValue"] = filter.MinimumValue;
                    }

                    if (!string.IsNullOrWhiteSpace(filter.Phrase))
                    {
                        logger.Debug("Filtering on phrase {Phrase}", filter.Phrase);

                        var keywordsToFind = Keywords
                            .Extract(filter.Phrase)
                            .Take(10)
                            .ToList();

                        for (var i = 0; i < keywordsToFind.Count; ++i)
                        {
                            var keywordToFind = keywordsToFind[i];

                            if (clauses.Length > 0)
                            {
                                clauses.Append(" AND ");
                            }

                            clauses
                                .Append("ARRAY_CONTAINS(u.keywords, @Keyword")
                                .Append(i)
                                .Append(")");
                            parameters[$"@Keyword{i}"] = keywordToFind;
                        }
                    }

                    if (filter.SocialMediaNetworkIds != null && filter.SocialMediaNetworkIds.Count > 0)
                    {
                        logger.Debug("Filtering on social media network IDs {SocialMediaNetworkIds}", filter.SocialMediaNetworkIds);

                        for (var i = 0; i < filter.SocialMediaNetworkIds.Count; ++i)
                        {
                            var socialMediaNetworkId = filter.SocialMediaNetworkIds[i];

                            if (clauses.Length > 0)
                            {
                                clauses.Append(" AND ");
                            }

                            clauses
                                .Append(@"ARRAY_CONTAINS(u.socialMediaAccounts, {""socialNetworkProviderId"": @SocialMediaAccountId")
                                .Append(i)
                                .Append("}, true)");
                            parameters[$"@SocialMediaAccountId{i}"] = socialMediaNetworkId;
                        }
                    }

                    var sql = new StringBuilder("SELECT TOP 10 * FROM u");

                    if (clauses.Length > 0)
                    {
                        sql
                            .Append(" WHERE ")
                            .Append(clauses);
                    }

                    logger.Debug("SQL for search is {SQL}, parameters are {Parameters}", sql, parameters);
                    var queryDefinition = new CosmosSqlQueryDefinition(sql.ToString());

                    foreach (var parameter in parameters)
                    {
                        queryDefinition.UseParameter(parameter.Key, parameter.Value);
                    }

                    var itemQuery = usersContainer
                        .Items
                        .CreateItemQuery<UserDataEntity>(queryDefinition, 2);
                    var results = new List<UserData>();

                    while (itemQuery.HasMoreResults)
                    {
                        var currentResultSet = await itemQuery
                            .FetchNextSetAsync()
                            .ContinueOnAnyContext();

                        foreach (var user in currentResultSet)
                        {
                            results.Add(Mapper.Map<UserData>(user));
                        }
                    }

                    logger.Debug("Retrieved {Count} search results", results.Count);

                    var response = new SearchResponse();
                    response.Results.AddRange(results);
                    return response;
                });
    }
}
