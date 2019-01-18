namespace User.Interfaces
{
    public static class UserStatusExtensions
    {
        public static string ToDtoString(this UserStatus @this) =>
            char.ToLowerInvariant(@this.ToString()[0]) + @this.ToString().Substring(1);
    }
}
