using System;
using Users.Interfaces;

namespace Users
{
    public static class UserStatusEntityExtensions
    {
        public static UserStatus ToServiceObject(this UserStatusEntity @this)
        {
            switch (@this)
            {
                case UserStatusEntity.Active:
                    return UserStatus.Active;
                case UserStatusEntity.Disabled:
                    return UserStatus.Disabled;
                case UserStatusEntity.Unknown:
                    return UserStatus.Unknown;
                case UserStatusEntity.WaitingForActivation:
                    return UserStatus.WaitingForActivation;
                case UserStatusEntity.WaitingForApproval:
                    return UserStatus.WaitingForApproval;
                default:
                    throw new NotSupportedException();
            }
        }

        public static UserStatusEntity ToEntity(this UserStatus @this)
        {
            switch (@this)
            {
                case UserStatus.Active:
                    return UserStatusEntity.Active;
                case UserStatus.Disabled:
                    return UserStatusEntity.Disabled;
                case UserStatus.Unknown:
                    return UserStatusEntity.Unknown;
                case UserStatus.WaitingForActivation:
                    return UserStatusEntity.WaitingForActivation;
                case UserStatus.WaitingForApproval:
                    return UserStatusEntity.WaitingForApproval;
                default:
                    throw new NotSupportedException();
            }
        }
    }
}
