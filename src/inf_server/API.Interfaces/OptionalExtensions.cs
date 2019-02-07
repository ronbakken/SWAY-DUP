namespace API.Interfaces
{
    public static class OptionalExtensions
    {
        public static string ValueOr(this OptionalString @this, string defaultValue) =>
            @this != null ? @this.Value : defaultValue;

        public static OptionalString OptionalOr(this string @this, string defaultValue) =>
            @this == defaultValue ? null : new OptionalString { Value = @this };
    }
}
