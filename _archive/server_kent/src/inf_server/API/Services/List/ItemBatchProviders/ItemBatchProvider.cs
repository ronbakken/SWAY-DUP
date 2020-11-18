using System.Threading.Tasks;
using API.Interfaces;
using Serilog;

namespace API.Services.List.ItemBatchProviders
{
    public abstract class ItemBatchProvider
    {
        public abstract string Name { get; }

        // continuationToken will be null for the first invocation. It's up to the batch provider to denote the final
        // batch appropriately.
        public abstract Task<ItemBatch> GetItemBatch(
            ILogger logger,
            AuthenticatedUserType userType,
            ItemFilterDto filter,
            int pageSize,
            string continuationToken);
    }
}
