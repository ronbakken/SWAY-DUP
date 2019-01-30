using System;
using System.Fabric;
using System.Threading.Tasks;
using API.Interfaces;
using Grpc.Core;
using InvitationCodes.Interfaces;
using Microsoft.ServiceFabric.Services.Remoting.Client;
using static API.Interfaces.InfInvitationCodes;

namespace API.Services.InvitationCodes
{
    public sealed class InfInvitationCodesImpl : InfInvitationCodesBase
    {
        public override Task<GenerateInvitationCodeResponse> GenerateInvitationCode(Empty request, ServerCallContext context) =>
            APISanitizer.Sanitize(
                async () =>
                {
                    ServiceEventSource.Current.Message("GenerateInvitationCode.");

                    var service = GetInvitationCodesService();
                    var invitationCode = await service.Generate();
                    var response = new GenerateInvitationCodeResponse
                    {
                        InvitationCode = invitationCode,
                    };

                    ServiceEventSource.Current.Message("Generated invitation code '{0}'.", invitationCode);

                    return response;
                });

        public override Task<GetInvitationCodeStatusResponse> GetInvitationCodeStatus(GetInvitationCodeStatusRequest request, ServerCallContext context) =>
            APISanitizer.Sanitize(
                async () =>
                {
                    ServiceEventSource.Current.Message("GetInvitationCodeStatus.");

                    var service = GetInvitationCodesService();
                    var status = await service.GetStatus(request.InvitationCode);
                    var response = new GetInvitationCodeStatusResponse
                    {
                        Status = status.ToDto(),
                    };
                    return response;
                });

        private static IInvitationCodesService GetInvitationCodesService() =>
            ServiceProxy.Create<IInvitationCodesService>(new Uri($"{FabricRuntime.GetActivationContext().ApplicationName}/InvitationCodes"));
    }
}
