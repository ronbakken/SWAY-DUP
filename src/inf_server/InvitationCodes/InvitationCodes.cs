using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Fabric;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using InvitationCodes.Interfaces;
using Microsoft.Azure.Documents;
using Microsoft.Azure.Documents.Client;
using Microsoft.Azure.Documents.Linq;
using Microsoft.ServiceFabric.Services.Communication.Runtime;
using Microsoft.ServiceFabric.Services.Remoting.Runtime;
using Microsoft.ServiceFabric.Services.Runtime;
using NodaTime;
using Optional;
using Utility;
using Utility.Serialization;

namespace InvitationCodes
{
    internal sealed class InvitationCodes : StatelessService, IInvitationCodesService
    {
        private const string databaseId = "invitation_codes";
        private const string codesCollectionId = "codes";

        public InvitationCodes(StatelessServiceContext context)
            : base(context)
        {
        }

        protected override async Task RunAsync(CancellationToken cancellationToken)
        {
            Log("Creating database if required.");

            var documentClient = this.GetDocumentClient();
            await documentClient.CreateDatabaseIfNotExistsAsync(new Database { Id = databaseId });

            var codesCollection = new DocumentCollection
            {
                Id = codesCollectionId,
                PartitionKey = new PartitionKeyDefinition
                {
                    Paths = new Collection<string>
                    {
                        "/code",
                    },
                }
            };
            await documentClient.CreateDocumentCollectionIfNotExistsAsync(UriFactory.CreateDatabaseUri(databaseId), codesCollection);

            Log("Database creation complete.");
        }

        public Task<string> Generate() =>
            this.ReportExceptionsWithin(() => GenerateImpl());

        internal async Task<string> GenerateImpl()
        {
            Log("Generate");

            var documentClient = this.GetDocumentClient();
            string code = null;

            while (true)
            {
                code = GenerateRandomString(8);
                Log("Generated code '{0}'.", code);

                var existingInvitationCode = await GetInvitationCode(documentClient, code);
                var codeExists = existingInvitationCode != null;

                if (codeExists)
                {
                    Log("Code '{0}' has already been allocated - trying again.", code);
                }
                else
                {
                    Log("Generated unique code '{0}'.", code);
                    break;
                }
            }

            var expiryTimestamp = SystemClock
                .Instance
                .GetCurrentInstant()
                .Plus(Duration.FromDays(14))
                .InUtc();
            var entity = new InvitationCodeEntity(
                code,
                expiryTimestamp);

            await documentClient
                .CreateDocumentAsync(GetCodesCollectionUri(), entity);

            Log("Invitation code '{0}' with expiry timestamp {1} has been allocated.", code, expiryTimestamp);

            return code;
        }

        public Task<InvitationCodeStatus> GetStatus(string code) =>
            this.ReportExceptionsWithin(() => GetStatusImpl(code));

        internal async Task<InvitationCodeStatus> GetStatusImpl(string code)
        {
            Log("GetStatus.");

            var documentClient = this.GetDocumentClient();
            var existingInvitationCode = await GetInvitationCode(documentClient, code);

            if (existingInvitationCode == null)
            {
                Log("Code '{0}' does not exist.", code);
                return InvitationCodeStatus.NonExistant;
            }

            if (existingInvitationCode.IsHonored)
            {
                Log("Code '{0}' has been honored.", code);
                return InvitationCodeStatus.Honored;
            }

            var now = SystemClock.Instance.GetCurrentInstant();
            var isExpired = now > existingInvitationCode.ExpiryTimestamp.ToInstant();

            if (isExpired)
            {
                Log("Code '{0}' has expired.", code);
                return InvitationCodeStatus.Expired;
            }

            Log("Code '{0}' is pending.", code);
            return InvitationCodeStatus.Pending;
        }

        public Task<InvitationCodeHonorResult> Honor(string code) =>
            this.ReportExceptionsWithin(() => HonorImpl(code));

        internal async Task<InvitationCodeHonorResult> HonorImpl(string code)
        {
            Log("Honor.");

            var documentClient = this.GetDocumentClient();
            var existingInvitationCode = await GetInvitationCode(documentClient, code);

            if (existingInvitationCode == null)
            {
                Log("Code '{0}' does not exist.", code);
                return InvitationCodeHonorResult.DoesNotExist;
            }

            if (existingInvitationCode.IsHonored)
            {
                Log("Code '{0}' has been honored.", code);
                return InvitationCodeHonorResult.AlreadyHonored;
            }

            var now = SystemClock.Instance.GetCurrentInstant();
            var isExpired = now > existingInvitationCode.ExpiryTimestamp.ToInstant();

            if (isExpired)
            {
                Log("Code '{0}' has expired.", code);
                return InvitationCodeHonorResult.Expired;
            }

            Log("Code '{0}' is able to be honored.", code);

            existingInvitationCode = existingInvitationCode
                .With(isHonored: Option.Some(true));
            await documentClient.UpsertDocumentAsync(GetCodesCollectionUri(), existingInvitationCode);
            Log("Code '{0}' is now honored.", code);

            return InvitationCodeHonorResult.Success;
        }

        protected override IEnumerable<ServiceInstanceListener> CreateServiceInstanceListeners() =>
            this.CreateServiceRemotingInstanceListeners();

        private static void Log(string message, params object[] args) =>
            ServiceEventSource.Current.Message(message, args);

        private DocumentClient GetDocumentClient()
        {
            var configurationPackage = this.Context.CodePackageActivationContext.GetConfigurationPackageObject("Config");
            var databaseConnectionString = configurationPackage.Settings.Sections["Database"].Parameters["ConnectionString"].Value;
            var documentClient = DocumentDbAccount.Parse(databaseConnectionString, InfJsonSerializerSettings.Instance);

            return documentClient;
        }

        private static async Task<InvitationCodeEntity> GetInvitationCode(DocumentClient documentClient, string code)
        {
            var query = new SqlQuerySpec("SELECT * FROM c WHERE c.code = @code", new SqlParameterCollection(
                new[]
                {
                    new SqlParameter("@code", code),
                }));
            var existingCodeQuery = documentClient
                .CreateDocumentQuery<InvitationCodeEntity>(GetCodesCollectionUri(), query, new FeedOptions { MaxItemCount = 1 })
                .AsDocumentQuery();
            var results = await existingCodeQuery.ExecuteNextAsync<InvitationCodeEntity>();

            return results.FirstOrDefault();
        }

        private static string GenerateRandomString(int length)
        {
            var sb = new StringBuilder();
            var random = new Random();
            // Intentionally left out characters that often render ambiguously, even though that is mostly down to font choice.
            var chars = "ABCDEFGHJKMNPQRSTUVWXYZ23456789";

            for (var i = 0; i < length; ++i)
            {
                var ch = chars[random.Next(chars.Length)];
                sb.Append(ch);
            }

            return sb.ToString();
        }

        private static Uri GetCodesCollectionUri() =>
            UriFactory.CreateDocumentCollectionUri(databaseId, codesCollectionId);
    }
}
