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
        private CosmosContainer usersContainer;
        private CosmosContainer sessionsContainer;

        public Users(StatelessServiceContext context)
            : base(context)
        {
        }

        protected override async Task RunAsync(CancellationToken cancellationToken)
        {
            ServiceEventSource.Current.Message("Creating database if required.");

            var cosmosClient = this.GetCosmosClient();
            var databaseResult = await cosmosClient.Databases.CreateDatabaseIfNotExistsAsync(databaseId);
            var database = databaseResult.Database;
            var usersContainerResult = await database.Containers.CreateContainerIfNotExistsAsync(usersCollectionId, "/userId");
            this.usersContainer = usersContainerResult.Container;
            var sessionsContainerResult = await database.Containers.CreateContainerIfNotExistsAsync(sessionsCollectionId, "/userId");
            this.sessionsContainer = sessionsContainerResult.Container;

            ServiceEventSource.Current.Message("Database creation complete.");
        }

        public Task<UserData> GetUserData(string userId) =>
            this.ReportExceptionsWithin(ServiceEventSource.Current, () => GetUserDataImpl(userId));

        internal async Task<UserData> GetUserDataImpl(string userId)
        {
            ServiceEventSource.Current.Message("GetUserData: '{0}'", userId);

            ServiceEventSource.Current.Message("Getting user data.");
            var userDataResponse = await this.usersContainer.Items.ReadItemAsync<UserDataEntity>(userId, userId);

            if (userDataResponse.StatusCode == HttpStatusCode.NotFound)
            {
                return null;
            }

            var userData = userDataResponse.Resource;
            return userData.ToServiceObject();
        }

        public Task<UserData> SaveUserData(string userId, UserData userData) =>
            this.ReportExceptionsWithin(ServiceEventSource.Current, () => SaveUserDataImpl(userId, userData));

        internal async Task<UserData> SaveUserDataImpl(string userId, UserData userData)
        {
            ServiceEventSource.Current.Message("SaveUserData: '{0}'", userId);

            ServiceEventSource.Current.Message("Saving user data.");
            var userDataEntity = userData.ToEntity(userId);
            await this.usersContainer.Items.UpsertItemAsync(userId, userDataEntity);
            ServiceEventSource.Current.Message("User data saved.");

            ServiceEventSource.Current.Message("Indexing user data.");
            var elasticClient = GetElasticClient();
            var indexResult = await elasticClient.IndexDocumentAsync(userDataEntity);

            if (!indexResult.IsValid)
            {
                ServiceEventSource.Current.Message("Failed to index user: {0}", indexResult.OriginalException);
                throw new InvalidOperationException("Failed to index user.", indexResult.OriginalException);
            }

            return userData;
        }

        public Task<UserSession> GetUserSession(string refreshToken) =>
            this.ReportExceptionsWithin(ServiceEventSource.Current, () => GetUserSessionImpl(refreshToken));

        internal async Task<UserSession> GetUserSessionImpl(string refreshToken)
        {
            ServiceEventSource.Current.Message("GetSession: '{0}'", refreshToken);

            ServiceEventSource.Current.Message("Validating refresh token.");
            var validationResults = TokenManager.ValidateRefreshToken(refreshToken);

            if (!validationResults.IsValid)
            {
                throw new InvalidOperationException("Invalid refresh token.");
            }

            var userId = validationResults.UserId;

            ServiceEventSource.Current.Message("Getting user session.");
            var userSessionResponse = await this.sessionsContainer.Items.ReadItemAsync<UserSessionEntity>(userId, UserSessionIdHelper.GetIdFrom(refreshToken));

            if (userSessionResponse.StatusCode == HttpStatusCode.NotFound)
            {
                return null;
            }

            var userSession = userSessionResponse.Resource;

            return userSession.ToServiceObject();
        }

        public Task<UserSession> SaveUserSession(UserSession userSession) =>
            this.ReportExceptionsWithin(ServiceEventSource.Current, () => SaveUserSessionImpl(userSession));

        internal async Task<UserSession> SaveUserSessionImpl(UserSession userSession)
        {
            ServiceEventSource.Current.Message("SaveUserSession: '{0}'", userSession.RefreshToken);

            ServiceEventSource.Current.Message("Validating refresh token.");
            var validationResults = TokenManager.ValidateRefreshToken(userSession.RefreshToken);

            if (!validationResults.IsValid)
            {
                throw new InvalidOperationException("Invalid refresh token.");
            }

            var userId = validationResults.UserId;

            ServiceEventSource.Current.Message("Saving user session.");
            var userSessionEntity = userSession.ToEntity();
            await this.sessionsContainer.Items.CreateItemAsync(userId, userSessionEntity);
            ServiceEventSource.Current.Message("User session saved.");

            return userSession;
        }

        public Task InvalidateUserSession(string refreshToken) =>
            this.ReportExceptionsWithin(ServiceEventSource.Current, () => InvalidateUserSessionImpl(refreshToken));

        internal async Task InvalidateUserSessionImpl(string refreshToken)
        {
            ServiceEventSource.Current.Message("InvalidateUserSession: '{0}'", refreshToken);

            ServiceEventSource.Current.Message("Validating refresh token.");
            var validationResults = TokenManager.ValidateRefreshToken(refreshToken);

            if (!validationResults.IsValid)
            {
                throw new InvalidOperationException("Invalid refresh token.");
            }

            var userId = validationResults.UserId;

            ServiceEventSource.Current.Message("Deleting user session.");
            await this.sessionsContainer.Items.DeleteItemAsync<UserSessionEntity>(userId, UserSessionIdHelper.GetIdFrom(refreshToken));
            ServiceEventSource.Current.Message("User session invalidated.");
        }

        public Task<SearchResults> Search(SearchFilter searchFilter) =>
            this.ReportExceptionsWithin(ServiceEventSource.Current, () => SearchImpl(searchFilter));

        internal async Task<SearchResults> SearchImpl(SearchFilter searchFilter)
        {
            ServiceEventSource.Current.Message("Search.");

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

            ServiceEventSource.Current.Message("Elastic Search URI: {0}", uri);
            ServiceEventSource.Current.Message("Elastic Search user name: {0}", userName);
            ServiceEventSource.Current.Message("Elastic Search password: {0}", password);

            var connectionSettings = new ConnectionSettings(uri)
                .DefaultMappingFor<UserDataEntity>(m => m.IndexName("users").TypeName("_doc").IdProperty(p => p.UserId).Ignore(p => p.LoginToken))
                .BasicAuthentication(userName, password);
            var elasticClient = new ElasticClient(connectionSettings);

            return elasticClient;
        }
    }
}
