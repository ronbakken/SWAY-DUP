using System;
using static API.Interfaces.GetInvitationCodeStatusResponse.Types;
using Service = InvitationCodes.Interfaces;

namespace API.Services.InvitationCodes
{
    public static class InvitationCodeStatusExtensions
    {
        public static InvitationCodeStatus ToDto(this Service.InvitationCodeStatus @this)
        {
            switch (@this)
            {
                case Service.InvitationCodeStatus.NonExistant:
                    return InvitationCodeStatus.DoesNotExist;
                case Service.InvitationCodeStatus.Expired:
                    return InvitationCodeStatus.Expired;
                case Service.InvitationCodeStatus.Pending:
                    return InvitationCodeStatus.PendingUse;
                case Service.InvitationCodeStatus.Honored:
                    return InvitationCodeStatus.Used;
                default:
                    throw new NotSupportedException();
            }
        }
    }
}
