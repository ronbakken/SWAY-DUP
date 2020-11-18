using API.Interfaces;
using InvitationCodes.Interfaces;

namespace API.ObjectMapping
{
    public static class InvitationCodesExtensions
    {
        public static GetInvitationCodeStatusResponse.Types.InvitationCodeStatus ToInvitationCodeStatus(this GetStatusResponse.Types.Status @this) =>
            (GetInvitationCodeStatusResponse.Types.InvitationCodeStatus)(int)@this;
    }
}
