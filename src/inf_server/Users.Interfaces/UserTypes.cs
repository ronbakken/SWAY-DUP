using System;

namespace Users.Interfaces
{
    [Flags]
    public enum UserTypes
    {
        None = 0,
        Anonymous = 1,
        Influencer = 2,
        Business = 4,
        Support = 8,
        Admin = 16,
        All = Anonymous | Influencer | Business | Support | Admin,
    }
}
