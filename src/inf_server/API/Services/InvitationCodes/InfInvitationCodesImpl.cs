using System;
using System.Fabric;
using System.Threading.Tasks;
using API.Interfaces;
using Grpc.Core;
using InvitationCodes.Interfaces;
using Microsoft.ServiceFabric.Services.Remoting.Client;
using Serilog;
using static API.Interfaces.InfInvitationCodes;

namespace API.Services.InvitationCodes
{
    public sealed class InfInvitationCodesImpl : InfInvitationCodesBase
    {
        private readonly ILogger logger;

        public InfInvitationCodesImpl(ILogger logger)
        {
            this.logger = logger.ForContext<InfInvitationCodesImpl>();
        }

        public override Task<GenerateInvitationCodeResponse> GenerateInvitationCode(Empty request, ServerCallContext context) =>
            APISanitizer.Sanitize(
                logger,
                async (logger) =>
                {
                    var service = GetInvitationCodesService();
                    var invitationCode = await service.Generate();
                    var response = new GenerateInvitationCodeResponse
                    {
                        InvitationCode = invitationCode,
                    };

                    logger.Debug("Generated invitation code {InvitationCode}", invitationCode);

                    return response;
                });

        public override Task<GetInvitationCodeStatusResponse> GetInvitationCodeStatus(GetInvitationCodeStatusRequest request, ServerCallContext context) =>
            APISanitizer.Sanitize(
                logger,
                async (logger) =>
                {
                    var service = GetInvitationCodesService();
                    var invitationCode = request.InvitationCode;
                    var status = await service.GetStatus(invitationCode);
                    var response = new GetInvitationCodeStatusResponse
                    {
                        Status = status.ToDto(),
                    };

                    logger.Debug("Determined status of invitation code {InvitationCode} to be {InvitationCodeStatus}", invitationCode, status);

                    return response;
                });

        private static IInvitationCodesService GetInvitationCodesService() =>
            ServiceProxy.Create<IInvitationCodesService>(new Uri($"{FabricRuntime.GetActivationContext().ApplicationName}/InvitationCodes"));
    }
}
