namespace User.Interfaces
{
    public static class UserTypeExtensions
    {
        public static string ToDtoString(this UserType @this) =>
            char.ToLowerInvariant(@this.ToString()[0]) + @this.ToString().Substring(1);
    }
}
