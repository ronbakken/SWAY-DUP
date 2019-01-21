using System.Threading.Tasks;
using API.Interfaces;
using Grpc.Core;
using static API.Interfaces.InfAdminInvitationCodes;

namespace MockServer
{
    public class InfAdminInvitationCodesImpl : InfAdminInvitationCodesBase
    {
        public override Task<GenerateInvitationCodeResponse> GenerateInvitationCode(Empty request, ServerCallContext context)
        {
            var result = new GenerateInvitationCodeResponse
            {
                InvitationCode = "ABC123",
            };

            return Task.FromResult(result);
        }

        public override Task<GetInvitationCodeStatusResponse> GetInvitationCodeStatus(GetInvitationCodeStatusRequest request, ServerCallContext context)
        {
            var status = GetInvitationCodeStatusResponse.Types.InvitationCodeStatus.DoesNotExist;

            if (request.InvitationCode == "ABC123")
            {
                status = GetInvitationCodeStatusResponse.Types.InvitationCodeStatus.PendingUse;
            }

            var result = new GetInvitationCodeStatusResponse
            {
                Status = status,
            };

            return Task.FromResult(result);
        }
    }
}
