namespace API.Interfaces
{
    public static class OptionalExtensions
    {
        public static string ValueOr(this OptionalString @this, string defaultValue) =>
            @this != null ? @this.Value : defaultValue;
    }
}
