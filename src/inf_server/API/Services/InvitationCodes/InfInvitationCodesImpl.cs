using System.Threading.Tasks;
using API.Interfaces;
using API.ObjectMapping;
using Grpc.Core;
using InvitationCodes.Interfaces;
using Serilog;
using Utility;
using Utility.gRPC;
using static API.Interfaces.InfInvitationCodes;
using static InvitationCodes.Interfaces.InvitationCodeService;

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
                    var service = await GetInvitationCodeServiceClient().ContinueOnAnyContext();
                    var generateResponse = await service
                        .GenerateAsync(new GenerateRequest());
                    var code = generateResponse.Code;
                    var response = new GenerateInvitationCodeResponse
                    {
                        InvitationCode = code,
                    };

                    logger.Debug("Generated invitation code {InvitationCode}", code);

                    return response;
                });

        public override Task<GetInvitationCodeStatusResponse> GetInvitationCodeStatus(GetInvitationCodeStatusRequest request, ServerCallContext context) =>
            APISanitizer.Sanitize(
                logger,
                async (logger) =>
                {
                    var service = await GetInvitationCodeServiceClient().ContinueOnAnyContext();
                    var invitationCode = request.InvitationCode;
                    var getStatusResponse = await service
                        .GetStatusAsync(new GetStatusRequest { Code = invitationCode });
                    var response = new GetInvitationCodeStatusResponse
                    {
                        Status = getStatusResponse.Status.ToInvitationCodeStatus(),
                    };

                    logger.Debug("Determined status of invitation code {InvitationCode} to be {InvitationCodeStatus}", invitationCode, response);

                    return response;
                });

        private static Task<InvitationCodeServiceClient> GetInvitationCodeServiceClient() =>
            APIClientResolver.Resolve<InvitationCodeServiceClient>("InvitationCodes");
    }
}
