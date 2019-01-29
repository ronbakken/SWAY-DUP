using System;
using System.Collections.Generic;
using System.Fabric;
using System.Net;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using InvitationCodes.Interfaces;
using Microsoft.Azure.Cosmos;
using Microsoft.ServiceFabric.Services.Communication.Runtime;
using Microsoft.ServiceFabric.Services.Remoting.Runtime;
using Microsoft.ServiceFabric.Services.Runtime;
using NodaTime;
using Optional;
using Utility;
using Utility.Diagnostics;

namespace InvitationCodes
{
    internal sealed class InvitationCodes : StatelessService, IInvitationCodesService
    {
        private const string databaseId = "invitation_codes";
        private const string codesCollectionId = "codes";
        private CosmosContainer codesContainer;

        public InvitationCodes(StatelessServiceContext context)
            : base(context)
        {
        }

        protected override async Task RunAsync(CancellationToken cancellationToken)
        {
            ServiceEventSource.Instance.Info("Creating database if required.");

            var cosmosClient = this.GetCosmosClient();
            var databaseResult = await cosmosClient.Databases.CreateDatabaseIfNotExistsAsync(databaseId);
            var database = databaseResult.Database;
            var containerResult = await database.Containers.CreateContainerIfNotExistsAsync(codesCollectionId, "/code");
            this.codesContainer = containerResult.Container;

            ServiceEventSource.Instance.Info("Database creation complete.");
        }

        public Task<string> Generate() =>
            this.ReportExceptionsWithin(ServiceEventSource.Instance, () => GenerateImpl());

        internal async Task<string> GenerateImpl()
        {
            ServiceEventSource.Instance.Info("Generate");

            string code = null;

            while (true)
            {
                code = GenerateRandomString(8);
                ServiceEventSource.Instance.Info("Generated code '{0}'.", code);

                var existingInvitationCodeResponse = await this.codesContainer.Items.ReadItemAsync<InvitationCodeEntity>(code, code);

                if (existingInvitationCodeResponse.StatusCode == HttpStatusCode.NotFound)
                {
                    ServiceEventSource.Instance.Info("Generated unique code '{0}'.", code);
                    break;
                }
                else
                {
                    ServiceEventSource.Instance.Info("Code '{0}' has already been allocated - trying again.", code);
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

            await this.codesContainer.Items.CreateItemAsync(code, entity);

            ServiceEventSource.Instance.Info("Invitation code '{0}' with expiry timestamp {1} has been allocated.", code, expiryTimestamp);

            return code;
        }

        public Task<InvitationCodeStatus> GetStatus(string code) =>
            this.ReportExceptionsWithin(ServiceEventSource.Instance, () => GetStatusImpl(code));

        internal async Task<InvitationCodeStatus> GetStatusImpl(string code)
        {
            ServiceEventSource.Instance.Info("GetStatus.");

            var existingInvitationCodeResponse = await this.codesContainer.Items.ReadItemAsync<InvitationCodeEntity>(code, code);

            if (existingInvitationCodeResponse.StatusCode == HttpStatusCode.NotFound)
            {
                ServiceEventSource.Instance.Info("Code '{0}' does not exist.", code);
                return InvitationCodeStatus.NonExistant;
            }

            var existingInvitationCode = existingInvitationCodeResponse.Resource;

            if (existingInvitationCode.IsHonored)
            {
                ServiceEventSource.Instance.Info("Code '{0}' has been honored.", code);
                return InvitationCodeStatus.Honored;
            }

            var now = SystemClock.Instance.GetCurrentInstant();
            var isExpired = now > existingInvitationCode.ExpiryTimestamp.ToInstant();

            if (isExpired)
            {
                ServiceEventSource.Instance.Info("Code '{0}' has expired.", code);
                return InvitationCodeStatus.Expired;
            }

            ServiceEventSource.Instance.Info("Code '{0}' is pending.", code);
            return InvitationCodeStatus.Pending;
        }

        public Task<InvitationCodeHonorResult> Honor(string code) =>
            this.ReportExceptionsWithin(ServiceEventSource.Instance, () => HonorImpl(code));

        internal async Task<InvitationCodeHonorResult> HonorImpl(string code)
        {
            ServiceEventSource.Instance.Info("Honor.");

            var existingInvitationCodeResponse = await this.codesContainer.Items.ReadItemAsync<InvitationCodeEntity>(code, code);

            if (existingInvitationCodeResponse.StatusCode == HttpStatusCode.NotFound)
            {
                ServiceEventSource.Instance.Info("Code '{0}' does not exist.", code);
                return InvitationCodeHonorResult.DoesNotExist;
            }

            var existingInvitationCode = existingInvitationCodeResponse.Resource;

            if (existingInvitationCode.IsHonored)
            {
                ServiceEventSource.Instance.Info("Code '{0}' has been honored.", code);
                return InvitationCodeHonorResult.AlreadyHonored;
            }

            var now = SystemClock.Instance.GetCurrentInstant();
            var isExpired = now > existingInvitationCode.ExpiryTimestamp.ToInstant();

            if (isExpired)
            {
                ServiceEventSource.Instance.Info("Code '{0}' has expired.", code);
                return InvitationCodeHonorResult.Expired;
            }

            ServiceEventSource.Instance.Info("Code '{0}' is able to be honored.", code);

            existingInvitationCode = existingInvitationCode
                .With(isHonored: Option.Some(true));
            await this.codesContainer.Items.UpsertItemAsync(code, existingInvitationCode);
            ServiceEventSource.Instance.Info("Code '{0}' is now honored.", code);

            return InvitationCodeHonorResult.Success;
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
    }
}
