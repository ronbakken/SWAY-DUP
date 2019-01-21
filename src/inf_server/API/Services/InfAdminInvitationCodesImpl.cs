using System;
using System.Threading.Tasks;
using API.Interfaces;
using Grpc.Core;
using InvitationCodeManager.Interfaces;
using Microsoft.ServiceFabric.Services.Client;
using Microsoft.ServiceFabric.Services.Remoting.Client;
using static API.Interfaces.InfAdminInvitationCodes;

namespace API.Services
{
    public sealed class InfAdminInvitationCodesImpl : InfAdminInvitationCodesBase
    {
        public override async Task<GenerateInvitationCodeResponse> GenerateInvitationCode(Empty request, ServerCallContext context)
        {
            var service = GetInvitationCodeManagerService();
            var invitationCode = await service.Generate();
            var response = new GenerateInvitationCodeResponse
            {
                InvitationCode = invitationCode,
            };

            return response;
        }

        public override async Task<GetInvitationCodeStatusResponse> GetInvitationCodeStatus(GetInvitationCodeStatusRequest request, ServerCallContext context)
        {
            var service = GetInvitationCodeManagerService();
            var status = await service.GetStatus(request.InvitationCode);
            var response = new GetInvitationCodeStatusResponse
            {
                Status = status.ToDto(),
            };
            return response;
        }

        private static IInvitationCodeManagerService GetInvitationCodeManagerService() =>
            ServiceProxy.Create<IInvitationCodeManagerService>(new Uri("fabric:/server/InvitationCodeManager"), new ServicePartitionKey(1));
    }
}
