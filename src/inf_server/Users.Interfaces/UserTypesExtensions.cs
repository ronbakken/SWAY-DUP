using System;

namespace Users.Interfaces
{
    public static class UserTypesExtensions
    {
        public static bool Contains(this UserTypes @this, UserType value)
        {
            switch (value)
            {
                case UserType.Admin:
                    return @this.HasFlag(UserTypes.Admin);
                case UserType.Business:
                    return @this.HasFlag(UserTypes.Business);
                case UserType.Influencer:
                    return @this.HasFlag(UserTypes.Influencer);
                case UserType.Support:
                    return @this.HasFlag(UserTypes.Support);
                case UserType.Unknown:
                    return false;
                default:
                    throw new NotSupportedException();
            }
        }
    }
}
