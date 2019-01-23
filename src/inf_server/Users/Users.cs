using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Fabric;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;
using Microsoft.Azure.Documents;
using Microsoft.Azure.Documents.Client;
using Microsoft.Azure.Documents.Linq;
using Microsoft.ServiceFabric.Services.Communication.Runtime;
using Microsoft.ServiceFabric.Services.Remoting.Runtime;
using Microsoft.ServiceFabric.Services.Runtime;
using Users.Interfaces;
using Utility;
using Utility.Serialization;

namespace Users
{
    internal sealed class Users : StatelessService, IUsersService
    {
        private const string databaseId = "users";
        private const string usersCollectionId = "users";
        private const string sessionsCollectionId = "sessions";

        public Users(StatelessServiceContext context)
            : base(context)
        {
        }

        protected override async Task RunAsync(CancellationToken cancellationToken)
        {
            Log("Creating database if required.");

            var documentClient = this.GetDocumentClient();
            await documentClient.CreateDatabaseIfNotExistsAsync(new Database { Id = databaseId });

            var usersCollection = new DocumentCollection
            {
                Id = usersCollectionId,
                PartitionKey = new PartitionKeyDefinition
                {
                    Paths = new Collection<string>
                    {
                        "/userId",
                    },
                }
            };
            await documentClient.CreateDocumentCollectionIfNotExistsAsync(UriFactory.CreateDatabaseUri(databaseId), usersCollection);

            var sessionsCollection = new DocumentCollection
            {
                Id = sessionsCollectionId,
                PartitionKey = new PartitionKeyDefinition
                {
                    Paths = new Collection<string>
                    {
                        "/userId",
                    },
                }
            };
            await documentClient.CreateDocumentCollectionIfNotExistsAsync(UriFactory.CreateDatabaseUri(databaseId), sessionsCollection);

            Log("Database creation complete.");
        }

        public Task<UserData> GetUserData(string userId) =>
            this.ReportExceptionsWithin(() => GetUserDataImpl(userId));

        internal async Task<UserData> GetUserDataImpl(string userId)
        {
            Log("GetUserData: '{0}'", userId);

            var documentClient = this.GetDocumentClient();

            Log("Getting user data.");
            var userData = await GetUserDataOrNull(documentClient, userId);

            return userData.ToServiceObject();
        }

        public Task<UserData> SaveUserData(string userId, UserData userData) =>
            this.ReportExceptionsWithin(() => SaveUserDataImpl(userId, userData));

        internal async Task<UserData> SaveUserDataImpl(string userId, UserData userData)
        {
            Log("SaveUserData: '{0}'", userId);

            var documentClient = this.GetDocumentClient();

            Log("Saving user data.");
            var userDataEntity = userData.ToEntity(userId);

            await documentClient.UpsertDocumentAsync(GetUsersCollectionUri(), userDataEntity);
            Log("User data saved.");

            return userData;
        }

        public Task<UserSession> GetUserSession(string refreshToken) =>
            this.ReportExceptionsWithin(() => GetSessionImpl(refreshToken));

        internal async Task<UserSession> GetSessionImpl(string refreshToken)
        {
            Log("GetSession: '{0}'", refreshToken);

            var documentClient = this.GetDocumentClient();

            Log("Getting user session.");
            var userSession = await GetUserSessionOrNull(documentClient, refreshToken);

            return userSession.ToServiceObject();
        }

        public Task<UserSession> SaveUserSession(UserSession userSession) =>
            this.ReportExceptionsWithin(() => SaveUserSessionImpl(userSession));

        internal async Task<UserSession> SaveUserSessionImpl(UserSession userSession)
        {
            Log("SaveUserSession: '{0}'", userSession.RefreshToken);

            var documentClient = this.GetDocumentClient();

            Log("Saving user session.");
            var userSessionEntity = userSession.ToEntity();

            await documentClient.CreateDocumentAsync(GetSessionsCollectionUri(), userSessionEntity);
            Log("User session saved.");

            return userSession;
        }

        public Task InvalidateUserSession(string refreshToken) =>
            this.ReportExceptionsWithin(() => InvalidateUserSessionImpl(refreshToken));

        internal async Task InvalidateUserSessionImpl(string refreshToken)
        {
            Log("InvalidateUserSession: '{0}'", refreshToken);

            var documentClient = this.GetDocumentClient();

            Log("Deleting user session.");
            await documentClient.DeleteDocumentAsync(GetSessionDocumentUri(refreshToken));

            Log("User session invalidated.");
        }

        protected override IEnumerable<ServiceInstanceListener> CreateServiceInstanceListeners() =>
            this.CreateServiceRemotingInstanceListeners();

        private DocumentClient GetDocumentClient()
        {
            var configurationPackage = this.Context.CodePackageActivationContext.GetConfigurationPackageObject("Config");
            var databaseConnectionString = configurationPackage.Settings.Sections["Database"].Parameters["ConnectionString"].Value;
            var documentClient = DocumentDbAccount.Parse(databaseConnectionString, InfJsonSerializerSettings.Instance);

            return documentClient;
        }

        private static async Task<UserSessionEntity> GetUserSessionOrNull(DocumentClient documentClient, string refreshToken)
        {
            var validateResults = TokenManager.ValidateRefreshToken(refreshToken);
            var userId = validateResults.UserId;
            var query = new SqlQuerySpec("SELECT * FROM us WHERE us.userId = @userId AND us.id = @id", new SqlParameterCollection(
                new[]
                {
                    new SqlParameter("@userId", userId),
                    new SqlParameter("@id", refreshToken.Substring(0, 254)),
                }));
            var existingUserSessionQuery = documentClient
                .CreateDocumentQuery<UserSessionEntity>(GetSessionsCollectionUri(), query, new FeedOptions { MaxItemCount = 1 })
                .AsDocumentQuery();
            var results = await existingUserSessionQuery.ExecuteNextAsync<UserSessionEntity>();

            return results.FirstOrDefault();
        }

        private static async Task<UserDataEntity> GetUserDataOrNull(DocumentClient documentClient, string userId)
        {
            var query = new SqlQuerySpec("SELECT * FROM u WHERE u.userId = @userId", new SqlParameterCollection(
                new[]
                {
                    new SqlParameter("@userId", userId),
                }));
            var existingUserDataQuery = documentClient
                .CreateDocumentQuery<UserDataEntity>(GetUsersCollectionUri(), query, new FeedOptions { MaxItemCount = 1 })
                .AsDocumentQuery();
            var results = await existingUserDataQuery.ExecuteNextAsync<UserDataEntity>();

            return results.FirstOrDefault();
        }

        private static Uri GetUsersCollectionUri() =>
            UriFactory.CreateDocumentCollectionUri(databaseId, usersCollectionId);

        private static Uri GetSessionsCollectionUri() =>
            UriFactory.CreateDocumentCollectionUri(databaseId, sessionsCollectionId);

        private static Uri GetSessionDocumentUri(string refreshToken) =>
            UriFactory.CreateDocumentUri(databaseId, sessionsCollectionId, refreshToken);

        private static void Log(string message, params object[] args) =>
            ServiceEventSource.Current.Message(message, args);
    }
}
