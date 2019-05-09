using System;
using System.Net;
using System.Text;
using System.Threading.Tasks;
using Google.Protobuf.WellKnownTypes;
using Grpc.Core;
using InvitationCodes.Interfaces;
using Microsoft.Azure.Cosmos;
using NodaTime;
using Serilog;
using Utility;
using static InvitationCodes.Interfaces.HonorResponse.Types;
using static InvitationCodes.Interfaces.InvitationCodeService;

namespace InvitationCodes
{
    public sealed class InvitationCodesServiceImpl : InvitationCodeServiceBase
    {
        private const string schemaType = "invitationCode";
        private readonly ILogger logger;
        private CosmosContainer defaultContainer;

        public InvitationCodesServiceImpl(
            ILogger logger)
        {
            this.logger = logger.ForContext<InvitationCodesServiceImpl>();
        }

        public async Task Initialize(CosmosClient cosmosClient)
        {
            logger.Debug("Creating database if required");

            this.defaultContainer = await cosmosClient
                .CreateDefaultContainerIfNotExistsAsync()
                .ContinueOnAnyContext();

            logger.Debug("Database creation complete");
        }

        public override Task<GenerateResponse> Generate(GenerateRequest request, ServerCallContext context) =>
            APISanitizer.Sanitize(
                this.logger,
                async (logger) =>
                {
                    string code = null;

                    while (true)
                    {
                        code = GenerateRandomString(8);
                        logger.Debug("Generated random invitation code {InvitationCode}", code);

                        var existingInvitationCodeResponse = await this
                            .defaultContainer
                            .Items
                            .ReadItemAsync<InvitationCodeEntity>(code, code)
                            .ContinueOnAnyContext();

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
                        .Plus(NodaTime.Duration.FromDays(14))
                        .InUtc();
                    var entity = new InvitationCodeEntity
                    {
                        SchemaType = schemaType,
                        SchemaVersion = 1,
                        PartitionKey = schemaType,
                        Id = code,
                        ExpiryTimestamp = Timestamp.FromDateTime(expiryTimestamp.ToDateTimeUtc()),
                    };

                    await this
                        .defaultContainer
                        .Items
                        .CreateItemAsync(code, entity)
                        .ContinueOnAnyContext();

                    logger.Information("Invitation code {InvitationCode} with expiry {Expiry} has been allocated", code, expiryTimestamp);

                    return new GenerateResponse
                    {
                        Code = code,
                    };
                });

        public override Task<GetStatusResponse> GetStatus(GetStatusRequest request, ServerCallContext context) =>
            APISanitizer.Sanitize(
                this.logger,
                async (logger) =>
                {
                    var code = request.Code;

                    var existingInvitationCodeResponse = await this
                        .defaultContainer
                        .Items
                        .ReadItemAsync<InvitationCodeEntity>(schemaType, code)
                        .ContinueOnAnyContext();

                    if (existingInvitationCodeResponse.StatusCode == HttpStatusCode.NotFound)
                    {
                        logger.Warning("Invitation code {InvitationCode} does not exist - unable to determine status", code);
                        return new GetStatusResponse
                        {
                            Status = GetStatusResponse.Types.Status.NonExistant,
                        };
                    }

                    var existingInvitationCode = existingInvitationCodeResponse.Resource;

                    if (existingInvitationCode.IsHonored)
                    {
                        logger.Debug("Invitation code {InvitationCode} has been honored", code);
                        return new GetStatusResponse
                        {
                            Status = GetStatusResponse.Types.Status.Honored,
                        };
                    }

                    var now = SystemClock.Instance.GetCurrentInstant().ToDateTimeUtc();
                    var isExpired = now > existingInvitationCode.ExpiryTimestamp.ToDateTime();

                    if (isExpired)
                    {
                        logger.Debug("Invitation code {InvitationCode} is expired", code);
                        return new GetStatusResponse
                        {
                            Status = GetStatusResponse.Types.Status.Expired,
                        };
                    }

                    logger.Debug("Invitation code {InvitationCode} is pending", code);
                    return new GetStatusResponse
                    {
                        Status = GetStatusResponse.Types.Status.Pending,
                    };
                });

        public override Task<HonorResponse> Honor(HonorRequest request, ServerCallContext context) =>
            APISanitizer.Sanitize(
                this.logger,
                async (logger) =>
                {
                    var code = request.Code;

                    var existingInvitationCodeResponse = await this
                        .defaultContainer
                        .Items
                        .ReadItemAsync<InvitationCodeEntity>(schemaType, code)
                        .ContinueOnAnyContext();

                    if (existingInvitationCodeResponse.StatusCode == HttpStatusCode.NotFound)
                    {
                        logger.Warning("Invitation code {InvitationCode} does not exist - unable to honor it", code);
                        return new HonorResponse
                        {
                            Result = HonorResult.DoesNotExist,
                        };
                    }

                    var existingInvitationCode = existingInvitationCodeResponse.Resource;

                    if (existingInvitationCode.IsHonored)
                    {
                        logger.Warning("Invitation code {InvitationCode} is already honored", code);
                        return new HonorResponse
                        {
                            Result = HonorResult.AlreadyHonored,
                        };
                    }

                    var now = SystemClock.Instance.GetCurrentInstant().ToDateTimeUtc();
                    var isExpired = now > existingInvitationCode.ExpiryTimestamp.ToDateTime();

                    if (isExpired)
                    {
                        logger.Warning("Invitation code {InvitationCode} has surpassed its expiry timestamp of {ExpiryTimestamp}", code, existingInvitationCode.ExpiryTimestamp);
                        return new HonorResponse
                        {
                            Result = HonorResult.Expired,
                        };
                    }

                    logger.Debug("Invitation code {InvitationCode} is able to be honored", code);

                    existingInvitationCode.IsHonored = true;
                    await this
                        .defaultContainer
                        .Items
                        .UpsertItemAsync(schemaType, existingInvitationCode)
                        .ContinueOnAnyContext();
                    logger.Information("Invitation code {InvitationCode} is has been honored", code);

                    return new HonorResponse
                    {
                        Result = HonorResult.Success,
                    };
                });

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
