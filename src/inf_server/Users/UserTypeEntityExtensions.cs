using System;
using Users.Interfaces;

namespace Users
{
    public static class UserTypeEntityExtensions
    {
        public static UserType ToServiceObject(this UserTypeEntity @this)
        {
            switch (@this)
            {
                case UserTypeEntity.Admin:
                    return UserType.Admin;
                case UserTypeEntity.Business:
                    return UserType.Business;
                case UserTypeEntity.Influencer:
                    return UserType.Influencer;
                case UserTypeEntity.Support:
                    return UserType.Support;
                case UserTypeEntity.Unknown:
                    return UserType.Unknown;
                default:
                    throw new NotSupportedException();
            }
        }

        public static UserTypeEntity ToEntity(this UserType @this)
        {
            switch (@this)
            {
                case UserType.Admin:
                    return UserTypeEntity.Admin;
                case UserType.Business:
                    return UserTypeEntity.Business;
                case UserType.Influencer:
                    return UserTypeEntity.Influencer;
                case UserType.Support:
                    return UserTypeEntity.Support;
                case UserType.Unknown:
                    return UserTypeEntity.Unknown;
                default:
                    throw new NotSupportedException();
            }
        }
    }
}
