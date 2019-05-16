using System;
using System.Linq;
using System.Threading.Tasks;
using API.Interfaces;
using API.ObjectMapping;
using Google.Protobuf.Collections;
using Mapping.Interfaces;
using Serilog;
using Utility.gRPC;
using Utility.Mapping;
using static Mapping.Interfaces.MappingService;

namespace API.Services.List.ItemBatchProviders
{
    public enum SourceFilter
    {
        Offers,
        Users,
    }

    public sealed class MapItemBatchProvider : ItemBatchProvider
    {
        public MapItemBatchProvider(SourceFilter sourceFilter)
        {
            this.SourceFilter = sourceFilter;
        }

        public override string Name => "Map";

        public SourceFilter SourceFilter { get; }

        public override async Task<ItemBatch> GetItemBatch(ILogger logger, AuthenticatedUserType userType, ItemFilterDto filter, int pageSize, string continuationToken)
        {
            logger = logger.ForContext<MapItemBatchProvider>();

            if (continuationToken == "")
            {
                logger.Debug("Continuation token is empty");
                return null;
            }

            var mappingService = GetMappingServiceClient();

            var request = new ListMapItemsRequest
            {
                Filter = ToMapItemsFilter(logger, userType, this.GetCommonFilterData(filter), filter),
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

        private static ListMapItemsRequest.Types.Filter ToMapItemsFilter(ILogger logger, AuthenticatedUserType userType, CommonFilterData commonFilterData, ItemFilterDto itemFilter)
        {
            var northWestQuadKey = QuadKey.From(commonFilterData.NorthWest.Latitude, commonFilterData.NorthWest.Longitude, commonFilterData.MapLevel);
            var southEastQuadKey = QuadKey.From(commonFilterData.SouthEast.Latitude, commonFilterData.SouthEast.Longitude, commonFilterData.MapLevel);
            var quadKeys = QuadKey
                .GetRange(northWestQuadKey, southEastQuadKey)
                .Select(x => x.ToString())
                .ToList();

            logger.Debug("Determined item filter {@ItemFilter} encompasses quad keys {QuadKeys}", itemFilter, quadKeys);

            var mappingFilter = new ListMapItemsRequest.Types.Filter();

            mappingFilter.CategoryIds.AddRange(commonFilterData.CategoryIds);
            mappingFilter.Phrase = commonFilterData.Phrase;
            mappingFilter.QuadKeys.AddRange(quadKeys);

            if (itemFilter.OfferFilter != null)
            {
                mappingFilter.ItemTypes.Add(ListMapItemsRequest.Types.Filter.Types.ItemType.Offers);
                mappingFilter.OfferFilter = new ListMapItemsRequest.Types.Filter.Types.OfferFilterDto();
                mappingFilter.OfferFilter.AcceptancePolicies.AddRange(itemFilter.OfferFilter.AcceptancePolicies.Select(x => x.ToAcceptancePolicy()));
                mappingFilter.OfferFilter.BusinessAccountId = itemFilter.OfferFilter.BusinessAccountId;
                mappingFilter.OfferFilter.DeliverableTypes.AddRange(itemFilter.OfferFilter.DeliverableTypes.Select(x => x.ToListFilterDeliverableType()));
                mappingFilter.OfferFilter.MinimumRewardCash = itemFilter.OfferFilter.MinimumRewardCash.ToMappingMoney();
                mappingFilter.OfferFilter.MinimumRewardService = itemFilter.OfferFilter.MinimumRewardService.ToMappingMoney();
                mappingFilter.OfferFilter.OfferStatuses.AddRange(itemFilter.OfferFilter.OfferStatuses.Select(x => x.ToStatus()));
            }

            if (itemFilter.UserFilter != null)
            {
                mappingFilter.ItemTypes.Add(ListMapItemsRequest.Types.Filter.Types.ItemType.Users);
                mappingFilter.UserFilter = new ListMapItemsRequest.Types.Filter.Types.UserFilterDto();
                mappingFilter.UserFilter.SocialMediaNetworkIds.AddRange(itemFilter.UserFilter.SocialMediaNetworkIds);
                mappingFilter.UserFilter.UserTypes.AddRange(itemFilter.UserFilter.UserTypes.Select(x => x.ToType()));
            }

            return mappingFilter;
        }

        private CommonFilterData GetCommonFilterData(ItemFilterDto filter)
        {
            switch (this.SourceFilter)
            {
                case SourceFilter.Offers:
                    return new CommonFilterData(
                        filter.OfferFilter.MapLevel,
                        filter.OfferFilter.NorthWest,
                        filter.OfferFilter.SouthEast,
                        filter.OfferFilter.CategoryIds,
                        filter.OfferFilter.Phrase);
                case SourceFilter.Users:
                    return new CommonFilterData(
                        filter.UserFilter.MapLevel,
                        filter.UserFilter.NorthWest,
                        filter.UserFilter.SouthEast,
                        filter.UserFilter.CategoryIds,
                        filter.UserFilter.Phrase);
                default:
                    throw new NotSupportedException();
            }
        }

        private static MappingServiceClient GetMappingServiceClient() =>
            APIClientResolver.Resolve<MappingServiceClient>("mapping", 9028);

        private sealed class CommonFilterData
        {
            public CommonFilterData(
                int mapLevel,
                GeoPointDto northWest,
                GeoPointDto southEast,
                RepeatedField<string> categoryIds,
                string phrase)
            {
                this.MapLevel = mapLevel;
                this.NorthWest = northWest;
                this.SouthEast = southEast;
                this.CategoryIds = categoryIds;
                this.Phrase = phrase;
            }

            public int MapLevel { get; }

            public GeoPointDto NorthWest { get; }

            public GeoPointDto SouthEast { get; }

            public RepeatedField<string> CategoryIds { get; }

            public string Phrase { get; }
        }
    }
}
