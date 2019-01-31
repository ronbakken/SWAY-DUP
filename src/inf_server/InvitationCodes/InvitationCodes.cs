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
using Serilog;
using Utility;

namespace InvitationCodes
{
    internal sealed class InvitationCodes : StatelessService, IInvitationCodesService
    {
        private const string databaseId = "invitation_codes";
        private const string codesCollectionId = "codes";
        private readonly ILogger logger;
        private CosmosContainer codesContainer;

        public InvitationCodes(StatelessServiceContext context)
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
            var containerResult = await database.Containers.CreateContainerIfNotExistsAsync(codesCollectionId, "/code");
            this.codesContainer = containerResult.Container;

            logger.Debug("Database creation complete");
        }

        public Task<string> Generate() =>
            this.ReportExceptionsWithin(this.logger, (logger) => GenerateImpl(logger));

        internal async Task<string> GenerateImpl(ILogger logger)
        {
            string code = null;

            while (true)
            {
                code = GenerateRandomString(8);
                logger.Debug("Generated random invitation code {InvitationCode}", code);

                var existingInvitationCodeResponse = await this.codesContainer.Items.ReadItemAsync<InvitationCodeEntity>(code, code);

                if (existingInvitationCodeResponse.StatusCode == HttpStatusCode.NotFound)
                {
                    logger.Debug("Generated unique invitation code {InvitationCode}", code);
                    break;
                }
                else
                {
                    logger.Warning("Invitation code {InvitationCode} has already been allocated - trying again", code);
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

            logger.Information("Invitation code {InvitationCode} with expiry {Expiry} has been allocated", code, expiryTimestamp);

            return code;
        }

        public Task<InvitationCodeStatus> GetStatus(string code) =>
            this.ReportExceptionsWithin(this.logger, (logger) => GetStatusImpl(logger, code));

        internal async Task<InvitationCodeStatus> GetStatusImpl(ILogger logger, string code)
        {
            var existingInvitationCodeResponse = await this.codesContainer.Items.ReadItemAsync<InvitationCodeEntity>(code, code);

            if (existingInvitationCodeResponse.StatusCode == HttpStatusCode.NotFound)
            {
                logger.Warning("Invitation code {InvitationCode} does not exist - unable to determine status", code);
                return InvitationCodeStatus.NonExistant;
            }

            var existingInvitationCode = existingInvitationCodeResponse.Resource;

            if (existingInvitationCode.IsHonored)
            {
                logger.Debug("Invitation code {InvitationCode} has been honored", code);
                return InvitationCodeStatus.Honored;
            }

            var now = SystemClock.Instance.GetCurrentInstant();
            var isExpired = now > existingInvitationCode.ExpiryTimestamp.ToInstant();

            if (isExpired)
            {
                logger.Debug("Invitation code {InvitationCode} is expired", code);
                return InvitationCodeStatus.Expired;
            }

            logger.Debug("Invitation code {InvitationCode} is pending", code);
            return InvitationCodeStatus.Pending;
        }

        public Task<InvitationCodeHonorResult> Honor(string code) =>
            this.ReportExceptionsWithin(this.logger, (logger) => HonorImpl(logger, code));

        internal async Task<InvitationCodeHonorResult> HonorImpl(ILogger logger, string code)
        {
            var existingInvitationCodeResponse = await this.codesContainer.Items.ReadItemAsync<InvitationCodeEntity>(code, code);

            if (existingInvitationCodeResponse.StatusCode == HttpStatusCode.NotFound)
            {
                logger.Warning("Invitation code {InvitationCode} does not exist - unable to honor it", code);
                return InvitationCodeHonorResult.DoesNotExist;
            }

            var existingInvitationCode = existingInvitationCodeResponse.Resource;

            if (existingInvitationCode.IsHonored)
            {
                logger.Warning("Invitation code {InvitationCode} is already honored", code);
                return InvitationCodeHonorResult.AlreadyHonored;
            }

            var now = SystemClock.Instance.GetCurrentInstant();
            var isExpired = now > existingInvitationCode.ExpiryTimestamp.ToInstant();

            if (isExpired)
            {
                logger.Warning("Invitation code {InvitationCode} has surpassed its expiry timestamp of {ExpiryTimestamp}", code, existingInvitationCode.ExpiryTimestamp);
                return InvitationCodeHonorResult.Expired;
            }

            logger.Debug("Invitation code {InvitationCode} is able to be honored", code);

            existingInvitationCode = existingInvitationCode
                .With(isHonored: Option.Some(true));
            await this.codesContainer.Items.UpsertItemAsync(code, existingInvitationCode);
            logger.Information("Invitation code {InvitationCode} is has been honored", code);

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
