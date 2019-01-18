using System;
using API.Interfaces;
using InvitationCodeManager.Interfaces;

namespace API.Services
{
    internal static class InvitationCodeStatusExtensions
    {
        public static InvitationCodeStates ToDto(this InvitationCodeStatus @this)
        {
            switch (@this)
            {
                case InvitationCodeStatus.DoesNotExist:
                case InvitationCodeStatus.Used:
                    return InvitationCodeStates.Invalid;
                case InvitationCodeStatus.Expired:
                    return InvitationCodeStates.Expired;
                case InvitationCodeStatus.PendingUse:
                    return InvitationCodeStates.Valid;
                default:
                    throw new NotSupportedException();
            }
        }
    }
}
