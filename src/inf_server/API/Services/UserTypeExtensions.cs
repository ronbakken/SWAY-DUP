using System;
using User.Interfaces;
using api = API.Interfaces;

namespace API.Services
{
    public static class UserTypeExtensions
    {
        public static api.UserType ToDto(this UserType @this)
        {
            switch (@this)
            {
                case UserType.Admin:
                    return api.UserType.Admin;
                case UserType.Business:
                    return api.UserType.Business;
                case UserType.Influencer:
                    return api.UserType.Influencer;
                case UserType.Support:
                    return api.UserType.Support;
                default:
                    throw new NotSupportedException();
            }
        }

        public static UserType ToService(this api.UserType @this)
        {
            switch (@this)
            {
                case api.UserType.Admin:
                    return UserType.Admin;
                case api.UserType.Business:
                    return UserType.Business;
                case api.UserType.Influencer:
                    return UserType.Influencer;
                case api.UserType.Support:
                    return UserType.Support;
                default:
                    throw new NotSupportedException();
            }
        }
    }
}
