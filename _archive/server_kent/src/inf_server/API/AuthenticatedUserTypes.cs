using System;

namespace API
{
    [Flags]
    public enum AuthenticatedUserTypes
    {
        None = 0,
        Anonymous = 1,
        Influencer = 2,
        Business = 4,
        Support = 8,
        Admin = 16,
    }
}
