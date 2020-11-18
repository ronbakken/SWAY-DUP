using System.Runtime.CompilerServices;
using Genesis.Ensure;

namespace System.Threading.Tasks
{
    public static class TaskExtensions
    {
        public static ConfiguredTaskAwaitable ContinueOnAnyContext(this Task @this)
        {
            Ensure.ArgumentNotNull(@this, nameof(@this));
            return @this.ConfigureAwait(continueOnCapturedContext: false);
        }

        public static ConfiguredTaskAwaitable<T> ContinueOnAnyContext<T>(this Task<T> @this)
        {
            Ensure.ArgumentNotNull(@this, nameof(@this));
            return @this.ConfigureAwait(continueOnCapturedContext: false);
        }

        public static ConfiguredTaskAwaitable ContinueOnSameContext(this Task @this)
        {
            Ensure.ArgumentNotNull(@this, nameof(@this));
            return @this.ConfigureAwait(continueOnCapturedContext: true);
        }

        public static ConfiguredTaskAwaitable<T> ContinueOnSameContext<T>(this Task<T> @this)
        {
            Ensure.ArgumentNotNull(@this, nameof(@this));
            return @this.ConfigureAwait(continueOnCapturedContext: true);
        }

        public static void Ignore(this Task @this)
        {
            Ensure.ArgumentNotNull(@this, nameof(@this));
        }

        public static void Ignore<T>(this Task<T> @this)
        {
            Ensure.ArgumentNotNull(@this, nameof(@this));
        }
    }
}
