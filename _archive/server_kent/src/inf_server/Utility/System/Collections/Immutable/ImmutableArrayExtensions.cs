namespace System.Collections.Immutable
{
    public static class ImmutableArrayExtensions
    {
        public static ImmutableArray<T> EmptyIfDefault<T>(this ImmutableArray<T> @this) =>
            @this.IsDefault ? ImmutableArray<T>.Empty : @this;
    }
}