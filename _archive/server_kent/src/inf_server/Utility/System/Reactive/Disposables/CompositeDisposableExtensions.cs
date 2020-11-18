using Genesis.Ensure;

namespace System.Reactive.Disposables
{
    public static class CompositeDisposableExtensions
    {
        public static IDisposable AddTo(this IDisposable @this, CompositeDisposable compositeDisposable)
        {
            Ensure.ArgumentNotNull(@this, nameof(@this));
            Ensure.ArgumentNotNull(compositeDisposable, nameof(compositeDisposable));

            compositeDisposable.Add(@this);
            return @this;
        }
    }
}
