using System;
using System.Collections.Immutable;
using System.Reactive.Linq;
using API.Interfaces;
using Serilog;

namespace API.Services.Listen.ItemListeners
{
    public abstract class ItemListener : IDisposable
    {
        protected ItemListener(
            ILogger logger,
            string userId)
        {
            this.Logger = logger;
            this.UserId = userId;
        }

        public ILogger Logger { get; }

        public string UserId { get; }

        public virtual void Dispose()
        {
        }
    }

    public abstract class ItemListener<T> : ItemListener
    {
        protected ItemListener(
            ILogger logger,
            string userId) : base(logger, userId)
        {
        }

        // Gets an observable that ticks all items in [items] that match the filters in [singleItemFilters] or [itemFilters].
        public virtual IObservable<T> GetMatchingItems(
            IObservable<T> items,
            IObservable<ImmutableList<SingleItemFilterDto>> singleItemFilters,
            IObservable<ImmutableList<ItemFilterDto>> itemFilters)
        {
            var logger = this.Logger.ForContext<ItemListener<T>>();

            var matchingItems = Observable
                .Merge(
                    items
                        .WithLatestFrom(singleItemFilters, (item, filters) => (item, isMatch: IsMatch(item, filters)))
                        .Where(result => result.isMatch)
                        .Select(result => result.item),
                    items
                        .WithLatestFrom(itemFilters, (item, filters) => (item, isMatch: IsMatch(item, filters)))
                        .Where(result => result.isMatch)
                        .Select(result => result.item));

            return matchingItems;
        }

        private bool IsMatch(T item, ImmutableList<SingleItemFilterDto> filters)
        {
            if (filters.Count == 0)
            {
                return false;
            }

            this.Logger.Debug("Determining if item {@Item} matches any one of {Count} single-item filters", item, filters.Count);

            foreach (var filter in filters)
            {
                if (IsMatch(item, filter))
                {
                    return true;
                }
            }

            return false;
        }

        protected abstract bool IsMatch(T item, SingleItemFilterDto filter);

        private bool IsMatch(T item, ImmutableList<ItemFilterDto> filters)
        {
            if (filters.Count == 0)
            {
                return false;
            }

            this.Logger.Debug("Determining if item {@Item} matches any one of {Count} item filters", item, filters.Count);

            foreach (var itemFilter in filters)
            {
                if (IsMatch(item, itemFilter))
                {
                    return true;
                }
            }

            return false;
        }

        protected abstract bool IsMatch(T item, ItemFilterDto filter);
    }
}
