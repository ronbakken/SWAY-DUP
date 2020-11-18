using System.Collections.Generic;
using API.Interfaces;

namespace API.Services.List.ItemBatchProviders
{
    public sealed class ItemBatch
    {
        public ItemBatch(
            List<ItemDto> items,
            string continuationToken)
        {
            this.Items = items;
            this.ContinuationToken = continuationToken;
        }

        public List<ItemDto> Items { get; }

        // Should be null if there are no further batches to obtain.
        public string ContinuationToken { get; }
    }
}
