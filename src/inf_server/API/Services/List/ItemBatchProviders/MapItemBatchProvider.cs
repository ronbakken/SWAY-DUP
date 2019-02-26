using System.Linq;
using System.Threading.Tasks;
using API.Interfaces;
using API.ObjectMapping;
using Mapping.Interfaces;
using Serilog;
using Utility;
using Utility.Mapping;
using static Mapping.Interfaces.MappingService;

namespace API.Services.List.ItemBatchProviders
{
    public sealed class MapItemBatchProvider : ItemBatchProvider
    {
        public static readonly MapItemBatchProvider Instance = new MapItemBatchProvider();

        private MapItemBatchProvider()
        {
        }

        public override string Name => "Map";

        public override async Task<ItemBatch> GetItemBatch(ILogger logger, AuthenticatedUserType userType, ItemFilterDto filter, int pageSize, string continuationToken)
        {
            logger = logger.ForContext<MapItemBatchProvider>();

            if (continuationToken == "")
            {
                logger.Debug("Continuation token is empty");
                return null;
            }

            var mappingService = await GetMappingServiceClient().ContinueOnAnyContext();

            var request = new ListMapItemsRequest
            {
                Filter = ToMapItemsFilter(logger, userType, filter),
            };
            var response = await mappingService
                .ListMapItemsAsync(request);
            var items = response
                .Results
                .Select(mapItem => mapItem.ToItemDto())
                .ToList();
            var result = new ItemBatch(
                items,
                "");

            logger.Debug("Returning {Count} items", items.Count);

            return result;
        }

        private static ListMapItemsRequest.Types.Filter ToMapItemsFilter(ILogger logger, AuthenticatedUserType userType, ItemFilterDto itemFilter)
        {
            var northWestQuadKey = QuadKey.From(itemFilter.NorthWest.Latitude, itemFilter.NorthWest.Longitude, itemFilter.MapLevel);
            var southEastQuadKey = QuadKey.From(itemFilter.SouthEast.Latitude, itemFilter.SouthEast.Longitude, itemFilter.MapLevel);
            var quadKeys = QuadKey
                .GetRange(northWestQuadKey, southEastQuadKey)
                .Select(x => x.ToString())
                .ToList();

            logger.Debug("Determined item filter {@ItemFilter} encompasses quad keys {QuadKeys}", itemFilter, quadKeys);

            var mappingFilter = new ListMapItemsRequest.Types.Filter();

            mappingFilter.CategoryIds.AddRange(itemFilter.CategoryIds);
            mappingFilter.ItemTypes.AddRange(itemFilter.ItemTypes.Select(x => x.ToItemType()));
            mappingFilter.Phrase = itemFilter.Phrase;
            mappingFilter.QuadKeys.AddRange(quadKeys);

            if (itemFilter.OfferFilter != null)
            {
                mappingFilter.OfferFilter = new ListMapItemsRequest.Types.Filter.Types.OfferFilterDto();
                mappingFilter.OfferFilter.AcceptancePolicies.AddRange(itemFilter.OfferFilter.AcceptancePolicies.Select(x => x.ToAcceptancePolicy()));
                mappingFilter.OfferFilter.BusinessAccountId = itemFilter.OfferFilter.BusinessAccountId;
                mappingFilter.OfferFilter.DeliverableTypes.AddRange(itemFilter.OfferFilter.DeliverableTypes.Select(x => x.ToListFilterDeliverableType()));
                mappingFilter.OfferFilter.MinimumReward = itemFilter.OfferFilter.MinimumReward.ToMappingMoney();
                mappingFilter.OfferFilter.OfferStatuses.AddRange(itemFilter.OfferFilter.OfferStatuses.Select(x => x.ToStatus()));
                mappingFilter.OfferFilter.RewardTypes.AddRange(itemFilter.OfferFilter.RewardTypes.Select(x => x.ToListFilterRewardType()));
            }

            if (itemFilter.UserFilter != null)
            {
                mappingFilter.UserFilter = new ListMapItemsRequest.Types.Filter.Types.UserFilterDto();
                mappingFilter.UserFilter.SocialMediaNetworkIds.AddRange(itemFilter.UserFilter.SocialMediaNetworkIds);
                mappingFilter.UserFilter.UserTypes.AddRange(itemFilter.UserFilter.UserTypes.Select(x => x.ToType()));
            }

            return mappingFilter;
        }

        private static Task<MappingServiceClient> GetMappingServiceClient() =>
            APIClientResolver.Resolve<MappingServiceClient>("Mapping");
    }
}
