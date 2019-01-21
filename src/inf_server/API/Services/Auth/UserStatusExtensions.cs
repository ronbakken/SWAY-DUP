using System;
using API.Interfaces;
using User.Interfaces;

namespace API.Services.Auth
{
    public static class UserStatusExtensions
    {
        public static AccountState ToDto(this UserStatus @this)
        {
            switch (@this)
            {
                case UserStatus.Active:
                    return AccountState.Active;
                case UserStatus.Disabled:
                    return AccountState.Disabled;
                case UserStatus.Unknown:
                    return AccountState.Unknown;
                case UserStatus.WaitingForActivation:
                    return AccountState.WaitingForActivation;
                case UserStatus.WaitingForApproval:
                    return AccountState.WaitingForApproval;
                default:
                    throw new NotSupportedException();
            }
        }

        public static UserStatus ToService(this AccountState @this)
        {
            switch (@this)
            {
                case AccountState.Active:
                    return UserStatus.Active;
                case AccountState.Disabled:
                    return UserStatus.Disabled;
                case AccountState.Unknown:
                    return UserStatus.Unknown;
                case AccountState.WaitingForActivation:
                    return UserStatus.WaitingForActivation;
                case AccountState.WaitingForApproval:
                    return UserStatus.WaitingForApproval;
                default:
                    throw new NotSupportedException();
            }
        }
    }
}
