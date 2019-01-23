using Users.Interfaces;

namespace Users
{
    public static class UserSessionEntityExtensions
    {
        public static UserSession ToServiceObject(this UserSessionEntity @this)
        {
            if (@this == null)
            {
                return null;
            }

            return new UserSession(
                @this.RefreshToken,
                @this.DeviceId);
        }

        public static UserSessionEntity ToEntity(this UserSession @this)
        {
            if (@this == null)
            {
                return null;
            }

            return new UserSessionEntity(
                @this.RefreshToken?.Substring(0, 254),
                @this.RefreshToken,
                @this.DeviceId);
        }
    }
}
