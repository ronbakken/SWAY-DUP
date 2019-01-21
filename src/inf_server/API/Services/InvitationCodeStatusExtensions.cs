using System;
using static API.Interfaces.GetInvitationCodeStatusResponse.Types;
using Service = InvitationCodeManager.Interfaces;

namespace API.Services
{
    public static class InvitationCodeStatusExtensions
    {
        public static InvitationCodeStatus ToDto(this Service.InvitationCodeStatus @this)
        {
            switch (@this)
            {
                case Service.InvitationCodeStatus.DoesNotExist:
                    return InvitationCodeStatus.DoesNotExist;
                case Service.InvitationCodeStatus.Expired:
                    return InvitationCodeStatus.Expired;
                case Service.InvitationCodeStatus.PendingUse:
                    return InvitationCodeStatus.PendingUse;
                case Service.InvitationCodeStatus.Used:
                    return InvitationCodeStatus.Used;
                default:
                    throw new NotSupportedException();
            }
        }
    }
}
