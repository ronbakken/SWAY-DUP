﻿using System.Collections.Generic;
using System.Fabric;
using System.Net;
using System.Threading;
using System.Threading.Tasks;
using Microsoft.Azure.Cosmos;
using Microsoft.ServiceFabric.Services.Communication.Runtime;
using Microsoft.ServiceFabric.Services.Remoting.Runtime;
using Microsoft.ServiceFabric.Services.Runtime;
using Users.Interfaces;
using Utility;

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
            Log("Creating database if required.");

            var cosmosClient = this.GetCosmosClient();
            var databaseResult = await cosmosClient.Databases.CreateDatabaseIfNotExistsAsync(databaseId);
            var database = databaseResult.Database;
            var usersContainerResult = await database.Containers.CreateContainerIfNotExistsAsync(usersCollectionId, "/userId");
            this.usersContainer = usersContainerResult.Container;
            var sessionsContainerResult = await database.Containers.CreateContainerIfNotExistsAsync(sessionsCollectionId, "/userId");
            this.sessionsContainer = sessionsContainerResult.Container;

            Log("Database creation complete.");
        }

        public Task<UserData> GetUserData(string userId) =>
            this.ReportExceptionsWithin(() => GetUserDataImpl(userId));

        internal async Task<UserData> GetUserDataImpl(string userId)
        {
            Log("GetUserData: '{0}'", userId);

            Log("Getting user data.");
            var userDataResponse = await this.usersContainer.Items.ReadItemAsync<UserDataEntity>(userId, userId);

            if (userDataResponse.StatusCode == HttpStatusCode.NotFound)
            {
                return null;
            }

            var userData = userDataResponse.Resource;
            return userData.ToServiceObject();
        }

        public Task<UserData> SaveUserData(string userId, UserData userData) =>
            this.ReportExceptionsWithin(() => SaveUserDataImpl(userId, userData));

        internal async Task<UserData> SaveUserDataImpl(string userId, UserData userData)
        {
            Log("SaveUserData: '{0}'", userId);

            Log("Saving user data.");
            var userDataEntity = userData.ToEntity(userId);
            await this.usersContainer.Items.UpsertItemAsync(userId, userDataEntity);
            Log("User data saved.");

            return userData;
        }

        public Task<UserSession> GetUserSession(string refreshToken) =>
            this.ReportExceptionsWithin(() => GetSessionImpl(refreshToken));

        internal async Task<UserSession> GetSessionImpl(string refreshToken)
        {
            Log("GetSession: '{0}'", refreshToken);

            Log("Validating refresh token.");
            var validationResults = TokenManager.ValidateRefreshToken(refreshToken);
            var userId = validationResults.UserId;

            Log("Getting user session.");
            var userSessionResponse = await this.sessionsContainer.Items.ReadItemAsync<UserSessionEntity>(userId, UserSessionIdHelper.GetIdFrom(refreshToken));

            if (userSessionResponse.StatusCode == HttpStatusCode.NotFound)
            {
                return null;
            }

            var userSession = userSessionResponse.Resource;

            return userSession.ToServiceObject();
        }

        public Task<UserSession> SaveUserSession(UserSession userSession) =>
            this.ReportExceptionsWithin(() => SaveUserSessionImpl(userSession));

        internal async Task<UserSession> SaveUserSessionImpl(UserSession userSession)
        {
            Log("SaveUserSession: '{0}'", userSession.RefreshToken);

            Log("Validating refresh token.");
            var validationResults = TokenManager.ValidateRefreshToken(userSession.RefreshToken);
            var userId = validationResults.UserId;

            Log("Saving user session.");
            var userSessionEntity = userSession.ToEntity();
            await this.sessionsContainer.Items.CreateItemAsync(userId, userSessionEntity);
            Log("User session saved.");

            return userSession;
        }

        public Task InvalidateUserSession(string refreshToken) =>
            this.ReportExceptionsWithin(() => InvalidateUserSessionImpl(refreshToken));

        internal async Task InvalidateUserSessionImpl(string refreshToken)
        {
            Log("InvalidateUserSession: '{0}'", refreshToken);

            Log("Validating refresh token.");
            var validationResults = TokenManager.ValidateRefreshToken(refreshToken);
            var userId = validationResults.UserId;

            Log("Deleting user session.");
            await this.sessionsContainer.Items.DeleteItemAsync<UserSessionEntity>(userId, UserSessionIdHelper.GetIdFrom(refreshToken));
            Log("User session invalidated.");
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

        private static void Log(string message, params object[] args) =>
            ServiceEventSource.Current.Message(message, args);
    }
}
