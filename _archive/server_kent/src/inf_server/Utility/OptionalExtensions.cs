namespace Utility
{
    // For "optional" fields in protos, since they default to an empty string instead of null.
    public static class OptionalExtensions
    {
        public static string ValueOr(this string @this, string defaultValue) =>
            string.IsNullOrEmpty(@this) ? defaultValue : @this;
    }
}
