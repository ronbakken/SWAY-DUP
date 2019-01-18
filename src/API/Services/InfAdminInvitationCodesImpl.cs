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
        public override async Task<GenerateResponse> Generate(Empty request, ServerCallContext context)
        {
            var service = GetInvitationCodeManagerService();
            var invitationCode = await service.Generate();
            var response = new GenerateResponse
            {
                InvitationCode = invitationCode,
            };

            return response;
        }

        public override async Task<GetStatusResponse> GetStatus(GetStatusRequest request, ServerCallContext context)
        {
            var service = GetInvitationCodeManagerService();
            var status = await service.GetStatus(request.InvitationCode);
            var response = new GetStatusResponse
            {
                Status = status.ToGrpc(),
            };
            return response;
        }

        private static IInvitationCodeManagerService GetInvitationCodeManagerService() =>
            ServiceProxy.Create<IInvitationCodeManagerService>(new Uri("fabric:/server/InvitationCodeManager"), new ServicePartitionKey(1));
    }

    internal static class GrpcExtensions
    {
        public static GetStatusResponse.Types.InvitationCodeStatus ToGrpc(this InvitationCodeStatus @this)
        {
            switch (@this)
            {
                case InvitationCodeStatus.DoesNotExist:
                    return GetStatusResponse.Types.InvitationCodeStatus.DoesNotExist;
                case InvitationCodeStatus.Expired:
                    return GetStatusResponse.Types.InvitationCodeStatus.Expired;
                case InvitationCodeStatus.PendingUse:
                    return GetStatusResponse.Types.InvitationCodeStatus.PendingUse;
                case InvitationCodeStatus.Used:
                    return GetStatusResponse.Types.InvitationCodeStatus.Used;
                default:
                    throw new NotSupportedException();
            }
        }
    }
}
