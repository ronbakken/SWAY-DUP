using System;
using System.Collections.Generic;
using System.Fabric;
using System.Net;
using System.Threading;
using System.Threading.Tasks;
using Microsoft.Azure.Cosmos;
using Microsoft.ServiceFabric.Services.Communication.Runtime;
using Microsoft.ServiceFabric.Services.Remoting.Runtime;
using Microsoft.ServiceFabric.Services.Runtime;
using Nest;
using Serilog;
using Users.Interfaces;
using Utility;
using Utility.Diagnostics;

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
            logger.Debug("Saving data for user {UserId}: {@UserData}", userId, userData);
            var userDataEntity = userData.ToEntity(userId);
            await this.usersContainer.Items.UpsertItemAsync(userId, userDataEntity);
            logger.Debug("Data saved for user {UserId}: {@UserData}", userId, userData);

            var elasticClient = GetElasticClient();
            var indexResult = await elasticClient.IndexDocumentAsync(userDataEntity);

            if (!indexResult.IsValid)
            {
                throw new InvalidOperationException("Failed to index user.", indexResult.OriginalException);
            }

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

        public Task<SearchResults> Search(SearchFilter searchFilter) =>
            this.ReportExceptionsWithin(this.logger, (logger) => SearchImpl(logger, searchFilter));

        internal async Task<SearchResults> SearchImpl(ILogger logger, SearchFilter searchFilter)
        {
            return null;
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

        private ElasticClient GetElasticClient()
        {
            var configurationPackage = this.Context.CodePackageActivationContext.GetConfigurationPackageObject("Config");
            var configuration = configurationPackage.Settings.Sections["Search"];
            var uri = new Uri(configuration.Parameters["Uri"].Value);
            var userName = configuration.Parameters["UserName"].Value;
            var password = configuration.Parameters["Password"].Value;

            var connectionSettings = new ConnectionSettings(uri)
                .DefaultMappingFor<UserDataEntity>(m => m.IndexName("users").TypeName("_doc").IdProperty(p => p.UserId).Ignore(p => p.LoginToken))
                .BasicAuthentication(userName, password);
            var elasticClient = new ElasticClient(connectionSettings);

            return elasticClient;
        }
    }
}
