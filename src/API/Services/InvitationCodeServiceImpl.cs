using System;
using System.Threading.Tasks;
using API.Interfaces;
using Grpc.Core;
using InvitationCodeManager.Interfaces;
using Microsoft.ServiceFabric.Services.Client;
using Microsoft.ServiceFabric.Services.Remoting.Client;
using static API.Interfaces.InvitationCodeService;

namespace API.Services
{
    public sealed class InvitationCodeServiceImpl : InvitationCodeServiceBase
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

        public override async Task<UseResponse> Use(UseRequest request, ServerCallContext context)
        {
            var service = GetInvitationCodeManagerService();
            var status = await service.Use(request.InvitationCode);
            var response = new UseResponse
            {
                Result = status.ToGrpc(),
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

        public static UseResponse.Types.InvitationCodeUseResult ToGrpc(this InvitationCodeUseResult @this)
        {
            switch (@this)
            {
                case InvitationCodeUseResult.AlreadyUsed:
                    return UseResponse.Types.InvitationCodeUseResult.AlreadyUsed;
                case InvitationCodeUseResult.DoesNotExist:
                    return UseResponse.Types.InvitationCodeUseResult.DoesNotExist;
                case InvitationCodeUseResult.Expired:
                    return UseResponse.Types.InvitationCodeUseResult.Expired;
                case InvitationCodeUseResult.Success:
                    return UseResponse.Types.InvitationCodeUseResult.Success;
                default:
                    throw new NotSupportedException();
            }
        }
    }
}
