using System;
using System.Collections.Generic;
using System.Collections.Immutable;
using System.Fabric;
using System.Linq;
using System.Net;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using Microsoft.Azure.Cosmos;
using Microsoft.ServiceFabric.Services.Communication.Runtime;
using Microsoft.ServiceFabric.Services.Remoting.Runtime;
using Microsoft.ServiceFabric.Services.Runtime;
using Serilog;
using Users.Interfaces;
using Utility;
using Utility.Search;
using Utility.Tokens;

namespace Users
{
    internal sealed class Users : StatelessService, IUsersService
    {
        private const string databaseId = "users";
        private const string usersCollectionId = "users";
        private const string sessionsCollectionId = "sessions";
        private readonly ILogger logger;
        private CosmosContainer usersContainer;
        private CosmosContainer sessionsContainer;

        public Users(StatelessServiceContext context)
            : base(context)
        {
            var configurationPackage = this.Context.CodePackageActivationContext.GetConfigurationPackageObject("Config");
            var logStorageConnectionString = configurationPackage.Settings.Sections["Logging"].Parameters["StorageConnectionString"].Value;
            this.logger = Logging.GetLogger(this, logStorageConnectionString);
        }

        protected override async Task RunAsync(CancellationToken cancellationToken)
        {
            logger.Debug("Creating database if required");

            var cosmosClient = this.GetCosmosClient();
            var databaseResult = await cosmosClient.Databases.CreateDatabaseIfNotExistsAsync(databaseId);
            var database = databaseResult.Database;
            var usersContainerResult = await database.Containers.CreateContainerIfNotExistsAsync(usersCollectionId, "/userId");
            this.usersContainer = usersContainerResult.Container;
            var sessionsContainerResult = await database.Containers.CreateContainerIfNotExistsAsync(sessionsCollectionId, "/userId");
            this.sessionsContainer = sessionsContainerResult.Container;

            logger.Debug("Database creation complete");
        }

        public Task<UserData> GetUserData(string userId) =>
            this.ReportExceptionsWithin(this.logger, (logger) => GetUserDataImpl(logger, userId));

        internal async Task<UserData> GetUserDataImpl(ILogger logger, string userId)
        {
            logger.Debug("Getting data for user {UserId}", userId);
            var userDataResponse = await this.usersContainer.Items.ReadItemAsync<UserDataEntity>(userId, userId);

            if (userDataResponse.StatusCode == HttpStatusCode.NotFound)
            {
                logger.Debug("No data found for user {UserId}", userId);
                return null;
            }

            var userData = userDataResponse.Resource;
            logger.Debug("Retrieved data for user {UserId}: {@UserData}", userId, userData);
            return userData.ToServiceObject();
        }

        public Task<UserData> SaveUserData(string userId, UserData userData) =>
            this.ReportExceptionsWithin(this.logger, (logger) => SaveUserDataImpl(logger, userId, userData));

        internal async Task<UserData> SaveUserDataImpl(ILogger logger, string userId, UserData userData)
        {
            logger.Debug("Determining keywords for user {UserId} with data {@UserData}", userId, userData);
            var keywords = Keywords
                .Extract(
                    userData.Name,
                    userData.Description,
                    userData.Location?.Name,
                    userData.WebsiteUri)
                .ToImmutableList();

            var userDataEntity = userData.ToEntity(userId, keywords);
            logger.Debug("Saving data for user {UserId}: {@UserData}", userId, userDataEntity);
            await this.usersContainer.Items.UpsertItemAsync(userId, userDataEntity);
            logger.Debug("Data saved for user {UserId}: {@UserData}", userId, userData);

            return userData;
        }

        public Task<UserSession> GetUserSession(string refreshToken) =>
            this.ReportExceptionsWithin(this.logger, (logger) => GetUserSessionImpl(logger, refreshToken));

        internal async Task<UserSession> GetUserSessionImpl(ILogger logger, string refreshToken)
        {
            logger.Debug("Validating refresh token {RefreshToken}", refreshToken);
            var validationResults = TokenManager.ValidateRefreshToken(refreshToken);

            if (!validationResults.IsValid)
            {
                logger.Warning("Refresh token {RefreshToken} is invalid", refreshToken);
                throw new InvalidOperationException("Invalid refresh token.");
            }

            var userId = validationResults.UserId;

            logger.Debug("Getting session for user {UserId}, refresh token {RefreshToken}", userId, refreshToken);
            var userSessionResponse = await this.sessionsContainer.Items.ReadItemAsync<UserSessionEntity>(userId, UserSessionIdHelper.GetIdFrom(refreshToken));

            if (userSessionResponse.StatusCode == HttpStatusCode.NotFound)
            {
                logger.Warning("No session found for user {UserId}, refresh token {RefreshToken}", userId, refreshToken);
                return null;
            }

            var userSession = userSessionResponse.Resource;
            logger.Debug("Resolved session for user {UserId}: {@UserSession}", userId, userSession);

            return userSession.ToServiceObject();
        }

        public Task<UserSession> SaveUserSession(UserSession userSession) =>
            this.ReportExceptionsWithin(this.logger, (logger) => SaveUserSessionImpl(logger, userSession));

        internal async Task<UserSession> SaveUserSessionImpl(ILogger logger, UserSession userSession)
        {
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

            logger.Debug("Saving session for user {UserId}: {UserSession}", userId, userSessionEntity);
            await this.sessionsContainer.Items.CreateItemAsync(userId, userSessionEntity);
            logger.Information("Session for user {UserId} has been saved: {UserSession}", userId, userSessionEntity);

            return userSession;
        }

        public Task InvalidateUserSession(string refreshToken) =>
            this.ReportExceptionsWithin(this.logger, (logger) => InvalidateUserSessionImpl(logger, refreshToken));

        internal async Task InvalidateUserSessionImpl(ILogger logger, string refreshToken)
        {
            logger.Debug("Validating refresh token {RefreshToken}", refreshToken);
            var validationResults = TokenManager.ValidateRefreshToken(refreshToken);

            if (!validationResults.IsValid)
            {
                logger.Warning("Refresh token {RefreshToken} is invalid", refreshToken);
                throw new InvalidOperationException("Invalid refresh token.");
            }

            var userId = validationResults.UserId;

            logger.Debug("Deleting session for user {UserId}, refresh token {RefreshToken}", userId, refreshToken);
            await this.sessionsContainer.Items.DeleteItemAsync<UserSessionEntity>(userId, UserSessionIdHelper.GetIdFrom(refreshToken));
            logger.Information("Session for user {UserId} with refresh token {RefreshToken} has been invalidated", userId, refreshToken);
        }

        public Task<List<UserData>> Search(SearchFilter filter) =>
            this.ReportExceptionsWithin(this.logger, (logger) => SearchImpl(logger, filter));

        internal async Task<List<UserData>> SearchImpl(ILogger logger, SearchFilter filter)
        {
            var parameters = new Dictionary<string, object>();
            var clauses = new StringBuilder();

            if (filter.UserTypes != UserTypes.All)
            {
                logger.Debug("Filtering on user types {UserTypes}", filter.UserTypes);

                var userTypes = Enum
                    .GetValues(typeof(UserType))
                    .Cast<UserType>()
                    .ToList();
                var count = 0;

                clauses.Append("(");

                foreach (var userType in userTypes)
                {
                    if (filter.UserTypes.Contains(userType))
                    {
                        if (count > 0)
                        {
                            clauses.Append(" OR ");
                        }

                        clauses
                            .Append("c.type = @UserType")
                            .Append(count);
                        parameters[$"@UserType{count}"] = (int)userType;
                        ++count;
                    }
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

            if (filter.Location != null)
            {
                logger.Debug("Filtering on location {@Location}", filter.Location);

                if (clauses.Length > 0)
                {
                    clauses.Append(" AND ");
                }

                clauses.Append("ST_DISTANCE({'type':'Point','coordinates':[u.location.longitude,u.location.latitude]},{'type':'Point','coordinates':[@Longitude,@Latitude]}) < @Distance");
                parameters["@Longitude"] = filter.Location.Longitude;
                parameters["@Latitude"] = filter.Location.Latitude;
                parameters["@Distance"] = filter.Location.RadiusKms * 1000;
            }

            if (filter.MinimumValue != null)
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
                var currentResultSet = await itemQuery.FetchNextSetAsync();

                foreach (var user in currentResultSet)
                {
                    results.Add(user.ToServiceObject());
                }
            }

            logger.Debug("Retrieved {Count} search results", results.Count);
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
    }
}
