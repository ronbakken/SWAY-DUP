namespace System
{
    public static class StringExtensions
    {
        public static string ToCamelCase(this string @this)
        {
            if (@this == null)
            {
                return null;
            }

            if (@this.Length <= 1)
            {
                return @this;
            }

            return char.ToLowerInvariant(@this[0]) + @this.Substring(1);
        }
    }
}
